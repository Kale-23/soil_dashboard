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
mod_gen_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    mod <- "frost"
    ns <- session$ns

    # dynamically create column selector for time series plot
    output$col_selector <- renderUI({
      req(data())
      df <- data()

      df <- dplyr::select(df, dplyr::where(is.numeric))
      shiny::checkboxGroupInput(
        inputId = ns("selected_cols"),
        label = "Select Columns",
        choices = colnames(df),
        selected = colnames(df)[1:2]
      )
    })

    # output table
    output$dt_table <- DT::renderDataTable({
      DT::datatable(
        data()
      )
    })

    # output time series plot
    output$dygraph_plot <- dygraphs::renderDygraph({
      req(data())
      req(input$selected_cols)
      dygraph_setup(
        data(),
        input$selected_cols
      )
    })

    # handles download button
    output$download_data <- shiny::downloadHandler(
      filename = paste0(id, "_dataset.csv"),
      content = function(file) {
        req(data())
        readr::write_csv(data(), file)
      }
    )
  })
}

## To be copied in the UI
# mod_gen_ui_ui("gen_ui_1")

## To be copied in the server
# mod_gen_ui_server("gen_ui_1")
