#' reactive_data_connection
#'
#' @description reactively reads in new data when file last modified time changes
#'
#' @param csv_file_path Full path to csv file
#'
#' @return reactive data that updates when the file changes
#'
#' @noRd
reactive_data_connection <- function(csv_file_path) {
  print(paste0("reading in ", basename(csv_file_path)))
  shiny::reactiveFileReader(
    intervalMillis = 60000, # check every minute for an update
    NULL,
    csv_file_path,
    readFunc = readr::read_csv
  )
}
