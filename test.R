thing <- readr::read_csv(
  "https://docs.google.com/spreadsheets/d/e/2PACX-1vQVrMGhklEZl3pTLkxNieIO94BCYsWT9EEkLaO2iyD1CYBkmX_A3zIMpdrLEnJsydrC7oH1nDDEuL8j/pub?gid=0&single=true&output=csv"
) |>
  dplyr::select(
    -c(form_response_time, sampler_email, sampler_initials),
    -dplyr::contains(c("notes", "weight", "radiation")),
  ) |>
  dplyr::mutate(
    sampling_date = lubridate::mdy(sampling_date),
  ) |>
  dplyr::rename(date = sampling_date) |>
  dplyr::filter(!dplyr::if_all(everything(), is.na))

thing <- thing[seq_len(nrow(thing) - 3), ]

thing_field <- thing |>
  dplyr::select(dplyr::contains("field"), date) |>
  dplyr::filter(!dplyr::if_all(everything(), is.na)) |>
  dplyr::rename_with(~ stringr::str_replace_all(., "field_", "")) |>
  dplyr::mutate(location = "field")

thing_canopy <- thing |>
  dplyr::select(dplyr::contains("canopy"), date) |>
  dplyr::filter(!dplyr::if_all(everything(), is.na)) |>
  dplyr::rename_with(~ stringr::str_replace_all(., "canopy_", "")) |>
  dplyr::mutate(location = "canopy")

test_data <- dplyr::bind_rows(thing_field, thing_canopy)
