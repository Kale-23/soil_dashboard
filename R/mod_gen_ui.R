#' @title General UI Function
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_gen_ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$style(HTML(
      "
      #all_plots_container {
        display: flex;
        flex-direction: column;
        height: 100%;
        width: 100%;
        overflow-y: auto;
      }
      .dygraph-plot-container {
        flex: 1;
      }
      "
    )),

    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        width = 350,
        shiny::uiOutput(ns("col_selector")),
        shiny::uiOutput(ns("dy_downloads")),
        shiny::downloadButton(outputId = ns("download_data"), "Download Filtered Data")
      ),
      shiny::tagList(
        shiny::div(
          #id = "all_plots_container",
          bslib::accordion(
            bslib::accordion_panel(
              title = "Time Series Plots",
              icon = bsicons::bs_icon("graph-up"),
              open = TRUE,
              shiny::uiOutput(ns("all_plots"), fill = TRUE)
            ),
            bslib::accordion_panel(
              title = "Filtered Data Table",
              icon = bsicons::bs_icon("table"),
              open = FALSE,
              DT::dataTableOutput(ns("dt_table"))
            )
          )
        )
      )
    )
  )
}

#' General Server Functions
#'
#' @noRd
mod_gen_server <- function(id, data, global_filters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    filtered_data <- shiny::reactive({
      # filter data based on global filters which should be used for
      # everything below unless specified otherwise
      req(data())
      df <- data()

      # filter out site names to global selection
      d_loc <- global_filters$location()
      if (!is.null(d_loc)) {
        df <- df[df$site_name %in% d_loc, ]
      }

      # filter down dates to global selection
      d_range <- global_filters$date_range()
      if (!is.null(d_range)) {
        df <- df[df$date >= d_range[1] & df$date <= d_range[2], ]
      }

      # return filtered data
      df
    })

    # dynamically create column selector for time series plot
    # uses regular "data()" so plots do not reload each time user updates global filters
    output$col_selector <- renderUI({
      req(data())

      df <- data() |>
        dplyr::select(dplyr::where(is.numeric)) |>
        dplyr::select(-dplyr::any_of(non_dygraph_numeric_cols()))

      cols <- colnames(df)[-1] # exclude the first column (date)
      col_names <- col_names_conversions()[cols]

      shiny::checkboxGroupInput(
        inputId = ns("selected_cols"),
        label = "Select Columns",
        choiceNames = unname(col_names),
        choiceValues = cols,
        selected = cols[1], # default selection
      )
    })

    # output data table at bottom
    output$dt_table <- DT::renderDataTable({
      req(filtered_data())
      req(input$selected_cols)

      # filter data based on selected columns
      df <- filtered_data() |>
        dplyr::select(
          !dplyr::where(is.numeric) & !dplyr::where(is.logical),
          dplyr::all_of(input$selected_cols)
        )

      # render datatable
      DT::datatable(df)
    })

    # handles download button for the filtered dataset
    output$download_data <- shiny::downloadHandler(
      filename = paste0(id, "_dataset.csv"),
      content = function(file) {
        req(filtered_data())
        readr::write_csv(filtered_data(), file)
      }
    )

    # dynamically creates dygraph data based on selected columns
    dygraph_data <- shiny::reactive({
      req(filtered_data())
      req(input$selected_cols)
      req(global_filters$date_type())

      lapply(input$selected_cols, function(col) {
        if (global_filters$date_type() == "Seasonal") {
          df <- filtered_data() |>
            dplyr::select(date, site_name, water_year, value = all_of(col)) |>
            dplyr::mutate(
              site_year = paste0(site_name, "_", water_year)
            ) |>
            tidyr::pivot_wider(
              names_from = "site_year",
              values_from = "value",
              values_fn = mean
            ) |>
            dplyr::mutate(
              date = dplyr::if_else(
                lubridate::year(date) >= lubridate::year(as.Date(water_year)),
                as.Date(format(date, "2000-%m-%d")),
                as.Date(format(date, "1999-%m-%d")) #TODO this doesnt work yet
              )
            ) |>
            dplyr::select(-water_year, -site_name) |>
            dplyr::arrange(date)
        } else {
          df <- filtered_data() |>
            dplyr::select(date, site_name, value = all_of(col)) |>
            tidyr::pivot_wider(
              names_from = "site_name",
              values_from = "value",
              values_fn = mean
            ) |>
            dplyr::arrange(date)
        }
        list(df = df, col = col)
      })
    })

    # dynamically creates dygraphs for each selected column
    shiny::observe({
      req(dygraph_data())

      lapply(seq_along(dygraph_data()), function(i) {
        local({
          df_col <- dygraph_data()
          df <- df_col[[i]]$df
          col <- df_col[[i]]$col

          output[[paste0("dygraph_", i)]] <- dygraphs::renderDygraph({
            dygraph_setup(df, col)
          })
        })
      })
    })

    # dynamically creates ns info for each dygraph
    output$all_plots <- shiny::renderUI({
      req(dygraph_data())
      tagList(
        lapply(seq_along(dygraph_data()), function(i) {
          div(
            class = "dygraph-plot-container",
            bslib::card(
              title = dygraph_data()[[i]]$col,
              dygraphs::dygraphOutput(ns(paste0("dygraph_", i)))
            )
          )
        })
      )
    })

    # creates download buttons for each dygraph
    output$dy_downloads <- shiny::renderUI({
      req(dygraph_data())
      tagList(
        lapply(seq_along(dygraph_data()), function(i) {
          dyDownload(
            id = ns(paste0("dygraph_", i)),
            label = paste0("Download Plot ", i),
            usetitle = TRUE,
            asbutton = TRUE
          )
        })
      )
    })
  })
}

## To be copied in the UI
# mod_gen_ui_ui("gen_ui_1")

## To be copied in the server
# mod_gen_ui_server("gen_ui_1")
