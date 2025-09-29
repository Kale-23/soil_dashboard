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
  frost <- reactive_data_connection(session, paste0(common, "frost_final_data.csv"))
  pits <- reactive_data_connection(session, paste0(common, "pits_final_data.csv"))

  global_filters <- mod_global_server("global_1", frost, pits)

  test <- reactive_poll_connection(
    session,
    global_filters,
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vSZG7Si489XNvQBhWcd8GpGPJeIOtdVJYyXrBfdn7CJ2bwUMitxG8nwuYtKd_uuTmQ47HmSeifAV7Ma/pub?output=csv"
  )

  mod_gen_server("frost_1", frost, global_filters, test)
  mod_gen_server("pits_1", pits, global_filters, test)
}
