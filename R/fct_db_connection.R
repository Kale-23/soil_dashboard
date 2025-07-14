#' @title Create Database Pool
#' @description Creates a database connection pool
#'
#' @return DBI connection pool object
#'
#' @noRd
create_db_pool <- function() {
  pool_conn <- pool::dbPool(
    drv = RSQLite::SQLite(),
    dbname = get_golem_options("db_path")
  )
  shiny::onStop(function() {
    pool::poolClose(pool_conn)
  })
  pool_conn
}
