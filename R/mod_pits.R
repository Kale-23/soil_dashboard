#' pits UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_pits_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' pits Server Functions
#'
#' @noRd 
mod_pits_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_pits_ui("pits_1")
    
## To be copied in the server
# mod_pits_server("pits_1")
