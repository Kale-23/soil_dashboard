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
 
  )
}
    
#' frost Server Functions
#'
#' @noRd 
mod_frost_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_frost_ui("frost_1")
    
## To be copied in the server
# mod_frost_server("frost_1")
