#' reactive_data_connection
#'
#' @description reactively reads in new data when file last modified time changes
#'
#' @param csv_file_path Full path to csv file
#'
#' @return reactive data that updates when the file changes
#' @noRd
reactive_data_connection <- function(session, csv_file_path) {
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

reactive_poll_connection <- function(session, global_filters, csv_file_path) {
  refresh_interval <- 1000 # in milliseconds

  shiny::reactivePoll(
    intervalMillis = refresh_interval,
    session = session,
    # Check function: returns the last known update timestamp
    checkFunc = function() {
      # rechecks file whenever the update button is clicked
      global_filters$last_updated()
    },
    # reads csv when checkFunc reports a change
    valueFunc = function() {
      readr::read_csv(csv_file_path, show_col_types = FALSE)
    }
  )
}
