#' @title Database Render Table
#'
#' @description sets up rendering of datatable from pits/frost
#'
#' @return DT dataTable
#'
#' @noRd
db_render_table <- function(session, pool_conn, table) {
  DT::renderDT({
    db_data <- pool::dbGetQuery(
      pool_conn,
      paste0("SELECT * FROM \"", table, "\" LIMIT 1"), # just grabs structure
    )

    DT::datatable(
      db_data,
      options = list(
        processing = TRUE,
        server = TRUE,
        pageLength = 10,
        lengthMenu = c(5, 10, 20, 50, 100)
      ),
      callback = htmlwidgets::JS(
        "table.on('request.dt', function(e, settings, json) {",
        paste0("  Shiny.setInputValue('dt_request_", table, "', {"), # set input ns
        "    draw: json.draw,",
        "    start: json.start,",
        "    length: json.length,",
        "    search: json.search.value,",
        "    order: json.order,",
        "    columns: json.columns",
        "  });",
        "});",
        # return inital empty DT, ajax will load data
        "return [];"
      )
    )
  })
}

#' @title Database Observer
#'
#' @description observes AJAX requests and querys database
#'
#' @return observeEvent
#'
#' @noRd
db_observer <- function(id, input, table) {
  request_name <- paste0("dt_request_", table)
  shiny::observeEvent(input[[request_name]], {
    req(input[[request_name]])
    request_params <- input[[request_name]]
    draw <- request_params$draw
    start <- request_params$start
    length <- request_params$length
    search_value <- request_params$search
    order_cols <- request_params$order
    columns_info <- request_params$columns

    # Build the SQL query based on DT's request parameters
    sql_query_base <- paste0("SELECT * FROM ", table)
    sql_where_clause <- ""
    sql_order_by_clause <- ""
    sql_limit_offset_clause <- ""

    # Add search filter
    if (search_value != "") {
      # This example performs a simple LIKE search across all TEXT columns.
      # For more complex or efficient searching, you might need to build
      # more specific SQL or use a full-text search index if available.
      search_cols <- c("site_name") # Columns to search
      search_conditions <- paste0(
        "(",
        paste(paste0(search_cols, " LIKE '%", search_value, "%'"), collapse = " OR "),
        ")"
      )
      sql_where_clause <- paste("WHERE", search_conditions)
    }

    # Add ordering
    if (length(order_cols) > 0) {
      order_expressions <- lapply(order_cols, function(ord) {
        col_index <- ord$column
        col_name <- columns_info[[col_index + 1]]$data # +1 because JS is 0-indexed
        direction <- ifelse(ord$dir == "asc", "ASC", "DESC")
        paste(col_name, direction)
      })
      sql_order_by_clause <- paste("ORDER BY", paste(order_expressions, collapse = ", "))
    }

    # Add limit and offset for pagination
    sql_limit_offset_clause <- paste("LIMIT", length, "OFFSET", start)

    # Combine parts of the query
    full_sql_query <- paste(
      sql_query_base,
      sql_where_clause,
      sql_order_by_clause,
      sql_limit_offset_clause
    )

    # Get total records for DataTables pagination info
    total_records_query <- paste("SELECT COUNT(*) FROM ", table, sql_where_clause)
    total_records <- dbGetQuery(con(), total_records_query)[[1]]

    # Fetch data for the current page
    data_for_page <- dbGetQuery(con(), full_sql_query)

    # Send data back to DT using a custom message
    session$sendCustomMessage(
      type = "dt-update-data",
      message = list(
        id = id, # The ID of your DTOutput
        data = data_for_page,
        # DataTables expects `recordsTotal` and `recordsFiltered` for server-side processing
        recordsTotal = total_records,
        recordsFiltered = total_records, # If no filter, recordsFiltered = recordsTotal
        draw = draw
      )
    )
  })
}
