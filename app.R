library(shiny)
library(shinythemes)
library(RSQLite)
library(DBI)
library(glue)

source("funs.R")

con <- RSQLite::dbConnect(
  drv = RSQLite::SQLite(), 
  "database/db-main.sqlite"
)

on.exit(
  DBI::dbDisconnect(conn = con), 
  add = TRUE
)


ui <- shiny::navbarPage(
  
  title = "Boston useR Meetup", 
  
  theme = shinythemes::shinytheme(theme = "darkly"),
  
  # shinythemes::themeSelector(), 
  
  inverse = TRUE,
  
  collapsible = TRUE, 
  
  shiny::tabPanel(
    
    title = "Home", 
    
    shiny::fluidRow(
      
      shiny::column(
        width = 4, 
        shiny::textInput(
          inputId = "beer_name", 
          label = "Please Enter the Name of Your Favorite Beer", 
          placeholder = "Type Beer Name Here"
        )
      ), 
      
      shiny::column(
        width = 4,
        shiny::sliderInput(
          inputId = "abv_value",
          label = "Please Provide the ABV% of Your Favorite Beer", 
          value = 6.5, 
          min = 0.1,
          max = 15,
          step = 0.1
        )
      ),

      shiny::column(
        width = 4,
        shiny::radioButtons(
          inputId = "cat_or_dog",
          label = "Are You More of a Cat or Dog Person?",
          choices = c(emo::ji("cat"), emo::ji("dog"))
        )
      )

    ),
    
    shiny::hr(), 

    shiny::fluidRow(
      
      shiny::column(
        width = 4, 
        shiny::actionButton(
          inputId = "save_btn",
          label = "Save New Record"
        )
      )
      
    )
    
  )
  
)


server <- function(input, output, session) {
  
  shiny::observeEvent(input$save_btn, {
    
    shiny::req(!is.null(input$beer_name))
    
    con <- RSQLite::dbConnect(
      drv = RSQLite::SQLite(), 
      "database/db-main.sqlite"
    )
    
    save_to_db(
      sql_con = con, 
      beer = input$beer_name, 
      abv = input$abv_value, 
      cat_dog_choice = input$cat_or_dog
    )
    
    DBI::dbDisconnect(conn = con)

  })
  
}

shiny::shinyApp(ui = ui, server = server)