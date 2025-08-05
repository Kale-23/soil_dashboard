#' global_ui UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_global_ui <- function(id, tot_height) {
  ns <- NS(id)
  tagList(
    bslib::card(
      height = tot_height,
      bslib::card_header("Global Filters"),
      bslib::layout_columns(
        shiny::uiOutput(ns("loc_selector")),
        shiny::uiOutput(ns("date_type_selector")),
        shiny::uiOutput(ns("date_range_selector"))
      )
    )
  )
}

#' global_ui Server Functions
#'
#' @noRd
mod_global_server <- function(id, frost, pits) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$loc_selector <- shiny::renderUI({
      frost_locs <- unique(frost()$site_name)
      pits_locs <- unique(pits()$site_name)
      all_locs <- unique(c(frost_locs, pits_locs))
      all_locs_names <- col_names_conversions()[all_locs]
      shiny::checkboxGroupInput(
        inputId = ns("location"),
        label = "Select Monitoring Locations",
        choiceNames = unname(all_locs_names),
        choiceValues = all_locs,
        selected = all_locs
      )
    })
    output$date_type_selector <- shiny::renderUI({
      shiny::radioButtons(
        inputId = ns("date_type"),
        label = "Time Series Scope",
        choices = c("Full Dataset", "Seasonal"),
        selected = "Full Dataset"
      )
    })
    output$date_range_selector <- shiny::renderUI({
      min_frost <- min(frost()$date, na.rm = TRUE)
      max_frost <- max(frost()$date, na.rm = TRUE)
      min_pits <- min(pits()$date, na.rm = TRUE)
      max_pits <- max(pits()$date, na.rm = TRUE)
      min_date <- min(min_frost, min_pits)
      max_date <- max(max_frost, max_pits)
      shiny::dateRangeInput(
        inputId = ns("date_range"),
        label = "Select Date Range",
        start = min_date,
        end = max_date,
        min = min_date,
        max = max_date,
      )
    })

    # return reactive filters
    return(
      list(
        location = shiny::reactive(input$location),
        date_type = shiny::reactive(input$date_type),
        date_range = shiny::reactive(input$date_range)
      )
    )
  })
}

## To be copied in the UI
# mod_global_ui("global_1")

## To be copied in the server
# mod_global_server("global_1")
