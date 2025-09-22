#' reactive_data_connection
#'
#' @description reactively reads in new data when file last modified time changes
#'
#' @param csv_file_path Full path to csv file
#'
#' @return reactive data that updates when the file changes
#' @noRd
reactive_data_connection <- function(csv_file_path) {
  refresh_interval <- 60000 # check every minute for an update
  print(paste0(
    "checking for updates to ",
    basename(csv_file_path),
    " every ",
    refresh_interval,
    " milliseconds (",
    refresh_interval / 60000,
    " minutes)"
  ))
  shiny::reactiveFileReader(
    intervalMillis = refresh_interval,
    NULL,
    csv_file_path,
    readFunc = readr::read_csv
  )
}
