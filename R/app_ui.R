#' @title App UI
#' @description The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @importFrom shiny tags div HTML tagList
#'
#' @noRd
#'
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # application ui logic here
    #golem::golem_welcome_page() # Remove this line to start building your UI
    tags$style(HTML("html, body { height: 100%; margin: 0; }")),

    bslib::page_fluid(
      # reduces stupid ammount of space between bslib elements
      theme = bs_theme("bslib_spacer" = "0.25rem"),
      # main layout container
      div(
        style = "
        display: flex;
        flex-direction: column;
        height: 100vh;
        ",
        bslib::card(
          bslib::card_header(
            # title and tooltip
            shiny::div(
              style = "display: flex; justify-content: space-between; align-items: center;",

              shiny::span(
                shiny::h3(
                  style = "display: inline; margin-right: 0.3em;",
                  "Snow Pits and Frost Tubes Dashboard"
                ),
                bslib::tooltip(
                  bsicons::bs_icon("info-circle"),
                  # intro text
                  "Visualize and download data and graphs from the Snow Pits and Frost Tubes datasets. These datasets are collected and updated daily during the snow season",
                ),
              ),

              # source code link
              shiny::div(
                # Source code link
                shiny::a(
                  href = "https://github.com/Kale-23/soil_dashboard.git", # <-- update this link
                  target = "_blank",
                  bslib::tooltip(
                    bsicons::bs_icon("github"),
                    "View source code on GitHub"
                  )
                ),
              ),

              # theme toggle
              bslib::input_dark_mode()
            )
          ),
          #TODO fix this
          mod_global_ui("global_1", tot_height = "20vh"),

          bslib::navset_card_pill(
            height = "80vh",
            placement = "above",
            bslib::nav_panel(
              title = "Frost",
              mod_gen_ui("frost_1") # from mod_frost.R
            ),
            bslib::nav_panel(
              title = "Pits",
              mod_gen_ui("pits_1") # from mod_pits.R
            )
          )
        )
        #footer,
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources add_resource_path
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))

  tags$head(
    favicon(ext = "png"),

    bundle_resources(
      path = app_sys("app/www"),
      app_title = "soildash"
    )

    # NOTE: plotly replaced dygraph
    #dygraph_dependency(),
  )
}
