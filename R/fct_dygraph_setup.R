#' dygraph_setup
#'
#' @description sets up shiny output for dygraph
#'
#' @return dygraphs::renderDygraph
#'
#' @noRd

dygraph_setup <- function(data, column_name) {
  df_index <- as.Date(data$date)
  df_xts <- xts::xts(data, order.by = df_index)
  print(df_xts)
  dygraphs::dygraph(df_xts) |>
    #dygraphs::dyAxis("y", label = column_name) |>
    dygraphs::dyRangeSelector(height = 20) |>
    dygraphs::dyLegend(width = 500) |>
    dygraphs::dyOptions(
      drawPoints = TRUE,
      pointSize = 2,
      colors = RColorBrewer::brewer.pal(3, "Set1")
    ) |>
    dygraphs::dyCallbacks(drawCallback = dyRegister())
}
