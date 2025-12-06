#' @title General UI Function
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_gen_ui <- function(id, tot_height) {
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
      height = tot_height,
      sidebar = bslib::sidebar(
        width = 350,
        shiny::uiOutput(ns("col_selector")),
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
      req(global_filters$location())
      d_loc <- global_filters$location()
      if (!is.null(d_loc)) {
        df <- df |>
          dplyr::select(matches(paste(d_loc, collapse = "|")))
      }

      # filter down dates to global selection
      req(global_filters$date_range())
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
        dplyr::select(-dplyr::any_of(non_dygraph_numeric_cols())) #TODO: update these

      cols <- colnames(df) # exclude the first column (date)
      col_names <- cols #col_names_conversions()[cols]

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
      req(test_data())
      df <- test_data()
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
    plot_data <- shiny::reactive({
      req(filtered_data())
      req(input$selected_cols)
      req(global_filters$date_type())

      date_type <- global_filters$date_type()

      purrr::map(input$selected_cols, function(col) {
        df <- prepare_plot_data(filtered_data(), col, date_type)
        list(df = df, col = col)
      })
    })

    # dynamically creates ns info for each dygraph
    output$all_plots <- shiny::renderUI({
      req(plot_data())

      tagList(
        lapply(plot_data(), function(df_col) {
          col <- df_col$col
          df <- df_col$df
          seasonal <- global_filters$date_type() == "Seasonal"
          plot_id <- paste0("plot_", col) # unique ID for each plot
          output[[plot_id]] <- plotly::renderPlotly({
            plotly_timeseries(df, col, seasonal)
          })

          div(
            class = "plot-container",
            bslib::card(
              full_screen = TRUE, # can expand to fit screen
              bslib::card_header(
                col_names_conversions()[[col]]
              ),
              plotly::plotlyOutput(ns(plot_id)) # actual plot output
            ),
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
