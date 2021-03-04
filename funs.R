# Make the "AppHistoryTable" in the 'db-main' SQLite database if the table does
# not already exist
make_db <- function(sql_con) {
  
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
    
    print("Created new table \"AppHistoryTable\" in \'db-main'\ database")
    
  }
  
}


# Save user input as a new record in the SQL database
save_to_db <- function(sql_con, beer, abv, cat_dog_choice) {
  
  user <- Sys.getenv("USERNAME")
  
  cat_dog_choice <- ifelse(
    cat_dog_choice == emo::ji("cat"), 
    "Cat", 
    "Dog"
  )

  inputs_list <- list(beer, abv, cat_dog_choice, user)
  
  sql_stmt <- glue::glue_sql(
    "
    INSERT INTO AppHistoryTable ([BeerName], [AbvValue], [CatOrDog], [UserName])  
    VALUES ({inputs*})
    ", 
    inputs = inputs_list, 
    .con = sql_con
  )
  
  DBI::dbExecute(
    conn = sql_con, 
    statement = sql_stmt
  )
  
  print(
    paste0(
      "One record successfully added to the database by user: ", 
      user
    )
  )
  
}