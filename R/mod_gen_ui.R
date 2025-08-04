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
    bslib::layout_sidebar(
      sidebar = shiny::tagList(
        shiny::uiOutput(ns("col_selector")),
        shiny::uiOutput(ns("dy_downloads")),
        shiny::downloadButton(outputId = ns("download_data"), "Download")
      ),
      shiny::tagList(
        shiny::uiOutput(ns("all_plots")),
        DT::dataTableOutput(ns("dt_table"))
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

    output$col_selector <- renderUI({
      # dynamically create column selector for time series plot
      # uses regular "data()" so plots do not reload each time user updates global filters
      req(data())

      df <- dplyr::select(data(), dplyr::where(is.numeric))

      shiny::checkboxGroupInput(
        inputId = ns("selected_cols"),
        label = "Select Columns",
        choices = colnames(df)[2:length(colnames(df))],
        selected = colnames(df)[2]
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

    # handles download button
    output$download_data <- shiny::downloadHandler(
      filename = paste0(id, "_dataset.csv"),
      content = function(file) {
        req(filtered_data())
        readr::write_csv(filtered_data(), file)
      }
    )

    # in charge of creating dygraph data for all dygraphs
    dygraph_data <- shiny::reactive({
      req(filtered_data())
      req(input$selected_cols)

      # create a list of data frames for each selected column
      lapply(input$selected_cols, function(col) {
        df <- filtered_data() |>
          dplyr::select(date, site_name, value = all_of(col)) |>
          tidyr::pivot_wider(
            names_from = "site_name",
            values_from = "value",
            values_fn = mean
          ) |>
          dplyr::arrange(date)

        list(df = df, col = col)
      })
    })

    # in charge of creating a dygraph for each dataframe
    shiny::observe({
      req(dygraph_data())
      #output$dygraph_1 <- dygraphs::renderDygraph({
      #  dygraph_setup(dygraph_data()[[1]]$df, dygraph_data()[[1]]$col)
      #})

      # create a dygraph for each selected column
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

    # in charge of creating ns info for each dygraph
    output$all_plots <- shiny::renderUI({
      req(dygraph_data())
      tagList(
        lapply(seq_along(dygraph_data()), function(i) {
          dygraphs::dygraphOutput(ns(paste0("dygraph_", i)))
        })
      )
    })

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
