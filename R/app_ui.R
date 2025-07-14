#' @title App UI
#' @description The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @importFrom shiny tags div HTML
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # application ui logic here
    #golem::golem_welcome_page() # Remove this line to start building your UI
    tags$style(HTML("html, body { height: 100%; margin: 0; }")),

    # main layout container
    div(
      style = "
      display: flex;
      flex-direction: column;
      height: 100vh;
      ",

      bslib::card(
        height = "5vh",
        shiny::titlePanel(
          title = "Snow and Frost data viewer",
          windowTitle = "Snow and Frost Data Explorer"
        )
      ),

      #TODO fix this
      #global_ui(id = "global_1", total_height = "20vh"),

      bslib::navset_card_pill(
        height = "75vh",
        placement = "above",
        bslib::nav_panel(
          title = "Frost",
          mod_frost_ui("frost_1", pool)
        ),
        bslib::nav_panel(
          title = "Pits",
          mod_pits_ui("pits_1", pool)
        )
      )
    )
    #footer,
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "soildash"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
