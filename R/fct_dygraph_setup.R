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
  #TODO: this doesn't work for some reason and it is taking too long to figure out
  #js_dygraph_format_label <- "function(x) {return 'howdy'}"
  if (seasonal) {
    dygraphs::dygraph(df_xts, group = "dygraph") |>
      dygraphs::dyAxis("y", label = new_col_name) |>
      #dygraphs::dyAxis(
      #  "x",
      #  axisLabelFormatter = htmlwidgets::JS(js_dygraph_format_label),
      #  valueFormatter = htmlwidgets::JS(js_dygraph_format_label)
      #) |>
      dygraphs::dyRangeSelector(height = 20) |>
      dygraphs::dyLegend(width = 500) |>
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
      dygraphs::dyLegend(width = 500) |>
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
