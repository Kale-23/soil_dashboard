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
      bslib::card_header(shiny::span(
        "Global Filters",
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "These filters apply to both datasets and all plots and tables in the dashboard."
        )
      )),
      bslib::layout_columns(
        shiny::uiOutput(ns("loc_selector")),
        shiny::uiOutput(ns("date_type_selector")),
        shiny::uiOutput(ns("date_range_selector")),
        shiny::div(
          shiny::actionButton(ns("update_sheets"), "Update Data"),
          shiny::br(),
          shiny::textOutput(ns("update_sheets_time"), inline = TRUE)
        ),
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
        label = shiny::span(
          "Select Monitoring Locations",
          bslib::tooltip(
            bsicons::bs_icon("info-circle"),
            "Select one or more monitoring locations to visualize."
          )
        ),
        choiceNames = unname(all_locs_names),
        choiceValues = all_locs,
        selected = all_locs
      )
    })
    output$date_type_selector <- shiny::renderUI({
      shiny::radioButtons(
        inputId = ns("date_type"),
        label = shiny::span(
          "Time Series Scope",
          bslib::tooltip(
            bsicons::bs_icon("info-circle"),
            "Chose between viewing the dataset in full (Full Dataset), or viewing all seasons aligned against one another (Seasonal)"
          )
        ),
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
        label = shiny::span(
          "Select Date Range",
          bslib::tooltip(
            bsicons::bs_icon("info-circle"),
            "Select a date range within the full extent of the datasets."
          )
        ),
        start = min_date,
        end = max_date,
        min = min_date,
        max = max_date,
      )
    })

    last_updated <- reactiveVal(Sys.time())

    # Update when button is clicked
    observeEvent(input$update_sheets, {
      last_updated(Sys.time())
    })

    output$update_sheets_time <- renderText({
      paste0(" Last Updated: ", format(last_updated(), "%Y-%m-%d %H:%M:%S"))
    })

    # return reactive filters
    return(
      list(
        location = shiny::reactive(input$location),
        date_type = shiny::reactive(input$date_type),
        date_range = shiny::reactive(input$date_range),
        last_updated = last_updated
      )
    )
  })
}

## To be copied in the UI
# mod_global_ui("global_1")

## To be copied in the server
# mod_global_server("global_1")
