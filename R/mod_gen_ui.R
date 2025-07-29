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
        dyDownload(
          id = ns("dygraph_plot"),
          label = "Download Plot",
          usetitle = TRUE,
          asbutton = TRUE
        ),
        shiny::downloadButton(outputId = ns("download_data"), "Download")
      ),
      shiny::tagList(
        dygraphs::dygraphOutput(ns("dygraph_plot")),
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

    # output time series plot
    output$dygraph_plot <- dygraphs::renderDygraph({
      req(filtered_data())
      req(input$selected_cols)

      # render dygraph using the selected columns
      dygraph_setup(
        filtered_data(),
        input$selected_cols
      )
    })

    # output data table at bottom
    output$dt_table <- DT::renderDataTable({
      req(filtered_data())
      req(input$selected_cols)

      # filter data based on selected columns
      df <- filtered_data() |>
        dplyr::select(!dplyr::where(is.numeric), dplyr::all_of(input$selected_cols))

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

    output$dygraphs <- shiny::reactive({
      req(filtered_data())
      req(input$selected_cols)

      # split data into multiple dataframes where each one is a numeric column
      # specified by input$selected_cols, and split by site_name
      # each will get its own dy graph
      dfs <- list()
      for (col in input$selected_cols) {
        df <- filtered_data() |>
          dplyr::select(c("date", "site_name", col)) |>
          tidyr::pivot_wider(
            names_from = "site_name",
            values_from = col
          )
        # put both the new df and column name into a list so that dygraph_setup
        # can see the data and the column name for the Y axis label
        ret_values <- list(df, col)
        dfs <- list(dfs, ret_values)
      }

      # return a list of dygraphs for each dataframe
      lapply(dfs, function(df) {
        dygraph_setup(df, colnames(df)[2:length(colnames(df))])
      })
    })
  })
}

## To be copied in the UI
# mod_gen_ui_ui("gen_ui_1")

## To be copied in the server
# mod_gen_ui_server("gen_ui_1")
