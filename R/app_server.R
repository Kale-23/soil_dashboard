#' @title Application Server
#' @description The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  pool <- create_db_pool()
  mod_frost_server("frost_1", pool)
  mod_pits_server("pits_1", pool)
}
