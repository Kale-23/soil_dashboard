#' plot_setup
#'
#' @description sets up shiny output for plotly
#'
#' @noRd
plotly_timeseries <- function(df, new_col_name, seasonal) {
  # Extract palette
  colors <- as.character(paletteer::paletteer_d("lisa::FridaKahlo"))

  # This adds a random date in June each year
  # if connect gaps is FALSE, it will break the lines at these dates making
  # it look better
  if (!seasonal) {
    # gets the min/max year in the data
    min_year <- lubridate::year(min(df$date))
    max_year <- lubridate::year(max(df$date))
    # creates a sequence of dates in June for each year
    june_dates <- seq(
      as.Date(paste0(min_year, "-06-01")),
      as.Date(paste0(max_year, "-06-01")),
      by = "1 year"
    )

    # create a data frame with NA values for each series at each June date
    na_rows <- df[0, ]
    na_rows <- na_rows[rep(1, length(june_dates)), ]
    na_rows[,] <- NA
    na_rows$date <- june_dates

    # Step 4: Combine and keep unique rows
    df <- dplyr::bind_rows(df, na_rows) |>
      dplyr::arrange(date)
  }

  # Convert wide data into long for Plotly
  df_long <- tidyr::pivot_longer(
    df,
    cols = -date,
    names_to = "series",
    values_to = "value"
  ) |>
    dplyr::arrange(date)

  # Build the plot
  p <- plotly::plot_ly(
    data = df_long,
    x = ~date,
    y = ~value,
    color = ~series,
    colors = colors,
    type = "scatter",
    mode = "lines+markers",
    marker = list(size = 6),
    #fmt: skip
    text = ~ paste0(
      "Location: ", series, "<br>",
      "Value: ", value
    ),
    connectgaps = ifelse(seasonal, TRUE, FALSE)
  ) |>
    plotly::layout(
      yaxis = list(title = col_names_conversions()[[new_col_name]])
    )

  # remove year if seasonal
  if (seasonal) {
    p <- p |>
      plotly::layout(
        xaxis = list(
          title = "Date",
          type = 'date',
          tickformat = "%d %B"
        )
      )
  } else {
    p <- p |>
      plotly::layout(
        xaxis = list(
          title = "Date",
          type = 'date',
          tickformat = "%d %B<br>%Y"
        )
      )
  }

  # return the plotly object
  p
}


prepare_plot_data <- function(data, col, date_type) {
  if (date_type == "Seasonal") {
    data |>
      dplyr::select(date, site_name, value = dplyr::all_of(col)) |>
      # calculate water year (July 1 - June 30)
      dplyr::mutate(
        water_year = dplyr::if_else(
          lubridate::month(date) >= 7,
          lubridate::year(date) + 1,
          lubridate::year(date)
        )
      ) |>
      dplyr::mutate(site_year = paste0(stringr::str_to_title(site_name), " ", water_year)) |>
      tidyr::pivot_wider(
        names_from = "site_year",
        values_from = "value",
        values_fn = mean
      ) |>
      dplyr::mutate(
        date = dplyr::if_else(
          lubridate::year(date) >= water_year,
          as.Date(format(date, "2000-%m-%d")),
          as.Date(format(date, "1999-%m-%d")) # TODO fix this later
        )
      ) |>
      dplyr::select(-water_year, -site_name) |>
      dplyr::arrange(date)
  } else {
    data |>
      dplyr::select(date, site_name, value = dplyr::all_of(col)) |>
      dplyr::mutate(site_name = stringr::str_to_title(site_name)) |>
      tidyr::pivot_wider(
        names_from = "site_name",
        values_from = "value",
        values_fn = mean
      ) |>
      dplyr::arrange(date)
  }
}
