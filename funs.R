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
  
  DBI::dbSendStatement(
    conn = sql_con, 
    statement = sql_stmt
  )
  
}