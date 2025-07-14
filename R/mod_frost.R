#' frost UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_frost_ui <- function(id) {
  ns <- NS(id)

  tagList(
    card(
      card_body(
        layout_sidebar(
          #sidebar = map(names(df), ~ make_ui(df[[.x]], .x, id)),
          #TODO: fix
          sidebar = card(),
          card(
            card_header(
              "frost 1"
            ),
            tableOutput(ns("frost_plot"))
          )
        )
      )
    )
  )
}

#' frost Server Functions
#'
#' @noRd
mod_frost_server <- function(id, pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$frost_plot <- renderTable({
      trigger()
      pool::dbReadTable(pool, "frost_data")
    })

    #selected <- reactive({
    #  # make sure we have the react_data
    #  req(react_data())

    #  # filtering based on dynamic ui input
    #  dyn_vals <- names(react_data())
    #  exclude_vals <- c("site_name", "water_year", "date")

    #  filters <- dyn_vals[!dyn_vals %in% exclude_vals] |>
    #    map(
    #      ~ {
    #        input_min_max_filter <- input[[.x]] # dynamic ui input
    #        filter_var(react_data()[[.x]], input_min_max_filter)
    #      }
    #    )
    #  #print(head(filters))
    #  reduce(filters, `&`) # if all values across a row are TRUE, will show that row
    #})

    #output$frost_plot <- renderTable({
    #  #print(head(react_data()[selected(), ]))
    #  react_data()[selected(), ]
    #})
  })
}

## To be copied in the UI
# mod_frost_ui("frost_1")

## To be copied in the server
# mod_frost_server("frost_1")
