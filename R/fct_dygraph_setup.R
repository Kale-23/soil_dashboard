#' dygraph_setup
#'
#' @description sets up shiny output for dygraph
#'
#' @return dygraphs::renderDygraph
#'
#' @noRd
dygraph_setup <- function(data, filter_list) {
  df <- data
  df <- dplyr::arrange(df, date) |>
    dplyr::select(dplyr::all_of(c("date", filter_list)))
  df_index <- as.Date(df$date)
  df_xts <- xts::xts(df, order.by = df_index)
  dygraphs::dygraph(df_xts)
}
