#' @title Application Server
#' @description The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @include fct_reactive_data_connection.R
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #common <- "~/Desktop/Soil_Work/cleaned_data/"
  #frost <- reactive_data_connection(session, paste0(common, "frost_final_data.csv"))
  #pits <- reactive_data_connection(session, paste0(common, "pits_final_data.csv"))

  last_updated <- reactiveVal(Sys.time())

  # pass only last_updated to the poller
  full_dataset <- reactive_poll_connection(
    session,
    last_updated,
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vQVrMGhklEZl3pTLkxNieIO94BCYsWT9EEkLaO2iyD1CYBkmX_A3zIMpdrLEnJsydrC7oH1nDDEuL8j/pub?gid=0&single=true&output=csv"
  )

  global_filters <- mod_global_server("global_1", full_dataset)

  observe({
    req(full_dataset)
    print(full_dataset())
  })

  observeEvent(global_filters$last_updated(), {
    last_updated(global_filters$last_updated())
  })

  mod_gen_server("full_1", full_dataset, global_filters)
}
