# Make the "AppHistoryTable" in the 'db-main' SQLite database if the table does
# not already exist
make_db <- function(sql_con) {
  
  # Only execute the logic if the "AppHistoryTable" doesn't already exist...
  if (DBI::dbExistsTable(conn = sql_con, name = "AppHistoryTable") == FALSE) {
    
    # Create the table schema 
    app_history <- tibble::tibble(
      BeerName = character(0), 
      AbvValue = numeric(0), 
      CatOrDog = character(0),  
      UserName = character(0)
    )
    
    # Create AppHistoryTable table in SQLite db using the schema
    DBI::dbWriteTable(
      conn = sql_con,
      name = "AppHistoryTable",
      value = app_history
    )
    
    # Let the user know that the table was created
    print("Created new table \"AppHistoryTable\" in \'db-main'\ database")
    
  }
  
}


# Save user input as a new record in the SQL database
save_to_db <- function(sql_con, beer, abv, cat_dog_choice) {
  
  # Capture the system username of the current user 
  user <- Sys.getenv("USERNAME")
  
  # Capture whether the user selected the dog or cat emoji in the app
  cat_dog_choice <- ifelse(
    cat_dog_choice == emo::ji("cat"), 
    "Cat", 
    "Dog"
  )

  # Create a list holding the inputs from the app
  inputs_list <- list(beer, abv, cat_dog_choice, user)
  
  # Create the SQL statement to insert the data captured in the `inputs_list` 
  # into the SQLite database table
  sql_stmt <- glue::glue_sql(
    "
    INSERT INTO AppHistoryTable ([BeerName], [AbvValue], [CatOrDog], [UserName])  
    VALUES ({inputs*})
    ", 
    inputs = inputs_list, 
    .con = sql_con
  )
  
  # Execute the SQL statement created above
  DBI::dbExecute(
    conn = sql_con, 
    statement = sql_stmt
  )
  
  # Let the user know (in the console) that a record was successfully inserted 
  # into the SQLite database
  print(
    paste0(
      "One record successfully added to the database by user: ", 
      user
    )
  )
  
}