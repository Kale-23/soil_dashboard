#' dygraph_setup
#'
#' @description sets up shiny output for dygraph
#'
#' @return dygraphs::renderDygraph
#'
#' @noRd

dygraph_setup <- function(data, column_name, seasonal = FALSE) {
  df_index <- as.Date(data$date)
  df_index <- df_index[!is.na(df_index)]
  new_col_name <- col_names_conversions()[[column_name]]
  dy_data <- data |>
    dplyr::filter(!is.na(date)) |>
    dplyr::select(-date)
  df_xts <- xts::xts(dy_data, order.by = df_index)

  labels_div_id <- paste0("labels_", column_name) # unique ID for legend div
  if (seasonal) {
    dygraphs::dygraph(df_xts, group = "dygraph") |>
      dygraphs::dyAxis("y", label = new_col_name) |>
      #dygraphs::dyAxis(
      #  "x",
      #  axisLabelFormatter = htmlwidgets::JS(js_dygraph_format_label),
      #  valueFormatter = htmlwidgets::JS(js_dygraph_format_label)
      #) |>
      dygraphs::dyRangeSelector(height = 20) |>
      dygraphs::dyLegend(
        width = 500,
        labelsDiv = labels_div_id,
        labelsSeparateLines = TRUE
      ) |>
      dygraphs::dyOptions(
        connectSeparatedPoints = TRUE,
        drawPoints = TRUE,
        pointSize = 2,
        colors = paletteer::paletteer_d("yarrr::info2")
      ) |>
      dygraphs::dyCallbacks(drawCallback = dyRegister())
  } else {
    dygraphs::dygraph(df_xts, group = "dygraph") |>
      dygraphs::dyAxis("y", label = new_col_name) |>
      dygraphs::dyRangeSelector(height = 20) |>
      dygraphs::dyLegend(
        width = 500,
        labelsDiv = labels_div_id,
        labelsSeparateLines = TRUE
      ) |>
      dygraphs::dyOptions(
        connectSeparatedPoints = TRUE,
        drawPoints = TRUE,
        pointSize = 2,
        colors = paletteer::paletteer_d(
          "yarrr::info2",
        )
      ) |>
      dygraphs::dyCallbacks(drawCallback = dyRegister())
  }
}

prepare_dygraph_data <- function(data, col, date_type) {
  if (date_type == "Seasonal") {
    data |>
      dplyr::select(date, site_name, water_year, value = all_of(col)) |>
      dplyr::mutate(site_year = paste0(site_name, "_", water_year)) |>
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
      dplyr::select(date, site_name, value = all_of(col)) |>
      tidyr::pivot_wider(
        names_from = "site_name",
        values_from = "value",
        values_fn = mean
      ) |>
      dplyr::arrange(date)
  }
}
