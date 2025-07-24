#' pits UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_pits_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::card(
      bslib::card_body(
        bslib::layout_sidebar(
          #sidebar = map(names(df), ~ make_ui(df[[.x]], .x, id)),
          #TODO: fix
          sidebar = bslib::card(),
          bslib::card(
            bslib::card_header(
              "pits 1"
            ),
            DT::dataTableOutput(ns("pits_plot"))
          )
        )
      )
    )
  )
}

#' pits Server Functions
#'
#' @noRd
mod_pits_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$pits_plot <- DT::renderDataTable({
      data()
    })

    #output$pits_plot <- renderTable({
    #  pool |> dplyr::tbl("pits_data")
    #})
  })
}

## To be copied in the UI
# mod_pits_ui("pits_1")

## To be copied in the server
# mod_pits_server("pits_1")
