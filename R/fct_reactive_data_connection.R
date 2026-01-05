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

reactive_poll_connection <- function(session, last_updated_func, csv_file_path) {
  refresh_interval <- 1000 # in milliseconds

  shiny::reactivePoll(
    intervalMillis = refresh_interval,
    session = session,
    # Check function: returns the last known update timestamp
    checkFunc = function() {
      last_updated_func()
    },
    # reads csv when checkFunc reports a change
    valueFunc = function() {
      data <- readr::read_csv(
        "https://docs.google.com/spreadsheets/d/e/2PACX-1vQVrMGhklEZl3pTLkxNieIO94BCYsWT9EEkLaO2iyD1CYBkmX_A3zIMpdrLEnJsydrC7oH1nDDEuL8j/pub?gid=0&single=true&output=csv"
      ) |>
        dplyr::select(
          -c(form_response_time, sampler_email, sampler_initials),
          -dplyr::contains(c("notes", "weight", "radiation")),
        ) |>
        dplyr::mutate(sampling_date = lubridate::mdy(sampling_date), ) |>
        dplyr::rename(date = sampling_date) |>
        dplyr::filter(!dplyr::if_all(everything(), is.na))

      #data <- data[seq_len(nrow(data) - 3), ]

      data_pasture <- data |>
        dplyr::select(dplyr::contains("pasture"), date) |>
        dplyr::filter(!dplyr::if_all(everything(), is.na)) |>
        dplyr::mutate(
          avg_snow_depth = rowMeans(
            dplyr::across(dplyr::contains("snow_depth")),
            na.rm = TRUE
          ),
          avg_shallow_frost_depth = rowMeans(
            dplyr::across(dplyr::contains("shallow_frost_depth")),
            na.rm = TRUE
          ),
          avg_max_frost_depth = rowMeans(
            dplyr::across(dplyr::contains("max_frost_depth")),
            na.rm = TRUE
          ),
          avg_thaw_depth = rowMeans(
            dplyr::across(dplyr::contains("thaw_depth")),
            na.rm = TRUE
          )
        ) |>
        dplyr::rename_with(~ stringr::str_replace_all(., "pasture_", "")) |>
        dplyr::mutate(site_name = "pasture")

      data_canopy <- data |>
        dplyr::select(dplyr::contains("canopy"), date) |>
        dplyr::filter(!dplyr::if_all(everything(), is.na)) |>
        dplyr::mutate(
          avg_snow_depth = rowMeans(
            dplyr::across(dplyr::contains("snow_depth")),
            na.rm = TRUE
          ),
          avg_shallow_frost_depth = rowMeans(
            dplyr::across(dplyr::contains("shallow_frost_depth")),
            na.rm = TRUE
          ),
          avg_max_frost_depth = rowMeans(
            dplyr::across(dplyr::contains("max_frost_depth")),
            na.rm = TRUE
          ),
          avg_thaw_depth = rowMeans(
            dplyr::across(dplyr::contains("thaw_depth")),
            na.rm = TRUE
          )
        ) |>
        dplyr::rename_with(~ stringr::str_replace_all(., "canopy_", "")) |>
        dplyr::mutate(site_name = "canopy")

      combined <- dplyr::bind_rows(data_pasture, data_canopy) |>
        dplyr::select(!dplyr::contains("tube")) |>
        dplyr::arrange(
          date,
          site_name,
          swe,
          albedo,
          avg_snow_depth,
          avg_shallow_frost_depth,
          avg_max_frost_depth,
          avg_thaw_depth,
          surface_temperature_celsius,
          snow_depth_centimeters
        )

      return(combined)
    }
  )
}
