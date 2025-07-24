#' db_table_output
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
db_table_output <- function() {
  db_render_table <- function(pool_conn, table) {
    DT::renderDT({
      DT::datatable(
        data = NULL,
        options = list(
          serverSide = TRUE,
          ajax = list(
            url = paste0("data_", table), # will be handled in server via shiny
            type = "POST"
          ),
          processing = TRUE,
          pageLength = 10,
          lengthMenu = c(5, 10, 20, 50, 100)
        )
      )
    })
  }
}


observe_table <- function(session, input, table) {
  shiny::observeEvent(input[[paste0("data_", table)]], {
    query_data <- shiny::parseQueryString(input[[paste0("data_", table)]])

    # Do your query and filtering here — similar to how you already constructed `sql_query_base` etc.

    # Return response as JSON
    shiny::output[[paste0("data_", table)]] <- DT::dataTableAjax(
      session = session,
      data = function(...) {
        # your data fetching logic goes here, using parsed input
        data <- dbGetQuery(pool_conn, ...)
        data
      }
    )
  })
}
