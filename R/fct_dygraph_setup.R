#' dygraph_setup
#'
#' @description sets up shiny output for dygraph
#'
#' @return dygraphs::renderDygraph
#'
#' @noRd

dygraph_setup <- function(data, column_name) {
  df_index <- as.Date(data$date)
  new_col_name <- col_names_conversions()[[column_name]]
  dy_data <- data |>
    dplyr::select(-date)
  df_xts <- xts::xts(dy_data, order.by = df_index)
  dygraphs::dygraph(df_xts, group = "dygraph") |>
    dygraphs::dyAxis("y", label = new_col_name) |>
    dygraphs::dyRangeSelector(height = 20) |>
    dygraphs::dyLegend(width = 500) |>
    dygraphs::dyOptions(
      drawPoints = TRUE,
      pointSize = 2,
      colors = RColorBrewer::brewer.pal(6, "Set1")
    ) |>
    dygraphs::dyCallbacks(drawCallback = dyRegister())
}
