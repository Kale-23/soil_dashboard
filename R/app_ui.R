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
      # main layout container
      div(
        style = "
      display: flex;
      flex-direction: column;
      height: 100vh;
      ",

        bslib::card(
          height = "8vh",
          shiny::titlePanel(
            title = "Snow and Frost data viewer",
            windowTitle = "Snow and Frost Data Explorer"
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
      app_title = "soildash" #TODO: soildash
    ),

    dygraph_dependency(),
  )
}
