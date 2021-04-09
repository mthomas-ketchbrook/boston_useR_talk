library(shiny)
library(shinythemes)
library(DBI)
library(RSQLite)
library(glue)

# Import custom functions we created
source("funs.R")


# UI ----------------------------------------------------------------------


ui <- shiny::navbarPage(
  
  title = "Boston useR Meetup", 
  
  theme = shinythemes::shinytheme(theme = "darkly"), 
  
  inverse = TRUE,
  
  collapsible = TRUE, 
  
  # Create the "Home" tab on the app
  shiny::tabPanel(
    
    title = "Home", 
    
    shiny::fluidRow(
      
      # Add text input widget to capture the beer name entered by the user
      shiny::column(
        width = 4, 
        shiny::textInput(
          inputId = "beer_name", 
          label = "Please Enter the Name of Your Favorite Beer", 
          placeholder = "Type Beer Name Here"
        )
      ), 
      
      # Add numeric slider input widget to capture the ABV of the user's 
      # favorite beer
      shiny::column(
        width = 4,
        shiny::sliderInput(
          inputId = "abv_value",
          label = "Please Provide the ABV% of Your Favorite Beer", 
          value = 6.5,   # default value slider starts at
          min = 0.1,   # minimum allowable value
          max = 15,   # maximum allowable value
          step = 0.1   # slider increment  
        )
      ),

      # Add radio button widget to capture the user's choice of cat or dog
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

    # Add a button for the user to save their choices
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


# Server ------------------------------------------------------------------


server <- function(input, output, session) {
  
  # When the user clicks on the "Save New Record" button...
  shiny::observeEvent(input$save_btn, {
    
    # Require that they entered at least 1 character of text for the beer name
    shiny::req(nchar(input$beer_name) > 0)
    
    # Create a folder in the current working directory called "database" (if it
    # doesn't already exist)
    fs::dir_create("database")
    
    # Create a SQLite database named "db-main.sqlite", and create a connection 
    # to that database; 
    # Note: this will also connect to the SQLite database if it already exists 
    # (won't overwrite an existing database named "db-main.sqlite")
    con <- DBI::dbConnect(
      drv = RSQLite::SQLite(), 
      "database/db-main.sqlite"
    )
    
    # Add the "AppHistoryTable" to the SQLite database if it doesn't already
    # exist, using our custom `make_db()` function
    make_db(sql_con = con)
    
    # Save the user's inputs to the corresponding columns in the SQLite database, 
    # as defined by our custom `save_to_db()` function
    save_to_db(
      sql_con = con, 
      beer = input$beer_name, 
      abv = input$abv_value, 
      cat_dog_choice = input$cat_or_dog
    )
    
    # Close the connection to teh SQLite database when finished
    DBI::dbDisconnect(conn = con)

  })
  
}

shiny::shinyApp(ui = ui, server = server)