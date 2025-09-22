#' on_load
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
on_load <- function() {
  common <- "~/Desktop/Soil_Work/cleaned_data/"
  frost <- reactive_data_connection(paste0(common, "frost_final_data.csv"))
  pits <- reactive_data_connection(paste0(common, "pits_final_data.csv"))
}
