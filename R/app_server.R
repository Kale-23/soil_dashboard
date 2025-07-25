common <- "~/Desktop/Soil_Work/cleaned_data/"
frost <- reactive_data_connection(paste0(common, "frost_final_data.csv"))
pits <- reactive_data_connection(paste0(common, "pits_final_data.csv"))

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
  mod_gen_server("frost_1", frost)
  mod_gen_server("pits_1", pits)
}
