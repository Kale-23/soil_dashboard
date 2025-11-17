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
  common <- "~/Desktop/Soil_Work/cleaned_data/"
  #frost <- reactive_data_connection(session, paste0(common, "frost_final_data.csv"))
  #pits <- reactive_data_connection(session, paste0(common, "pits_final_data.csv"))

  full_dataset <- reactive_poll_connection(
    session,
    global_filters,
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vQVrMGhklEZl3pTLkxNieIO94BCYsWT9EEkLaO2iyD1CYBkmX_A3zIMpdrLEnJsydrC7oH1nDDEuL8j/pub?gid=0&single=true&output=csv"
  )

  global_filters <- mod_global_server("global_1", global_dataset)

  mod_gen_server("full_1", full_dataset, global_filters)

  #mod_gen_server("frost_1", frost, global_filters, test)
  #mod_gen_server("pits_1", pits, global_filters, test)
}
