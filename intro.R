# Beyond R-Stats: Workflow Management & Data Engineering in R
# 2020-10-20
# Michael Thomas - Ketchbrook Analytics

library(fs)   # navigate file system
library(DBI)   # work with databases
library(RSQLite)   # get driver to connect to SQLite db

library(dplyr)   # data manipulation
library(tibble)   # tidy tables
library(emo)   # add emojis to our print statements
library(lubridate)   # work with dates



# Replicate "tree" command line call to show directory structure
fs::dir_tree()


# Write Dataframe to File --------------------------------------------

# If it doesn't already exist, create a new folder named "input"
fs::dir_create("input")

# Write the 'mtcars' dataset to a .csv file in the "/input/" directory
mtcars %>% 
  write.csv(
    file = "input/mtcars.csv", 
    row.names = FALSE
  )

# Replicate "tree" command line call to show directory structure
fs::dir_tree()


# Removing Files ----------------------------------------------------------

# If there are any files in the "input" directory, remove them and print
# message to the console
if (length(list.files(path = "input")) > 0) {
  
  # Capture the number of file in the "input" directory
  num_files <- length(
    list.files(path = "input")
  )
  
  # Print a message letting the user know how many files are getting
  # removed from the "input" directory
  cat(
    emo::ji("x"), 
    "Removing", 
    num_files, 
    "file(s) from \"input\" folder"
  )
  
  # NOTE: We could use the 'file.remove()' function in base R, but it prints
  # "TRUE" to the console if a file is removed.  Since we're already
  # handling console messages with our code above, let's try using the
  # 'file_delete()' function from the {fs} package instead, which 
  # evaluates quietly (no message in the console)
  
  # Remove any existing files in the "input" directory
  fs::file_delete(
    list.files(
      path = "input", 
      full.names = TRUE
    )
  )
  
  # Remove the 'num_files' object from the environment.
  # The 'rm()' function can be useful when you are building scripts that are
  # very memory-intensive; this function can free up memory after you are done
  # using an object in your script so that the rest of your script can run a 
  # lot faster.
  rm(num_files)
  
}


# Put the file back in the "input" directory
mtcars %>% 
  write.csv(
    file = "input/mtcars.csv", 
    row.names = FALSE
  )

# Get the current date for navigating subfolders in the "archive" directory
year <- lubridate::year(lubridate::today()) %>% as.character()
month <- lubridate::month(lubridate::today()) %>% as.character()
day <- lubridate::day(lubridate::today()) %>% as.character()

# Define the path where we are going to move our "input" file to for 
# archiving purposes
archive_dir_name <- paste0(
  "archive/", 
  year, 
  "/", 
  month, 
  "/", 
  day
)


# Copying & Moving Files ---------------------------

# Create a custom function to move the file from "input" to "archive"
archive_file <- function(file_path, archive_directory) {
  
  # If the 'archive_directory' folder does not already exist, create all of
  # the subfolders under "archive" that do not yet exist
  if (!fs::dir_exists(path = archive_directory)) {
    
    fs::dir_create(
      path = archive_directory, 
      recurse = TRUE   # If "FALSE", can only create one new folder at a time; since it's true, we can create the entire hierarchy
    )
    
  }
  
  # Print message to console that file is getting copied
  message(cat(
    emo::ji("hourglass"), 
    "Copying 1 file from \"input\" to \"archive\""
  ))
  
  # Copy file from "input" to "archive" 
  fs::file_copy(
    path = file_path, 
    new_path = paste0(
      archive_directory,
      "/mtcars.csv"
    ), 
    overwrite = TRUE
  )

  # Simulate a time-intensive process
  Sys.sleep(3)
  
  # Print message to console that file was successfully copied
  message(cat(
    emo::ji("check"), 
    "File successfully copied to", 
    archive_directory
  ))
  
}


# Execute our 'archive_file()' custom function
archive_file(
  file_path = "input/mtcars.csv", 
  archive_directory = archive_dir_name
)

# View the recursive directory tree
fs::dir_tree()

# Rename the archived file to "historic_data.csv"
fs::file_move(
  path = list.files(
    path = archive_dir_name, 
    full.names = TRUE
  ), 
  new_path = paste0(
    archive_dir_name, 
    "/historic_data.csv"
  )
)



# Interface with Command Line / Powershell --------------------------------

system("powershell Start-Process \"chrome.exe\" \"www.rstudio.com\"")


# Get Environmental Variables ---------------------------------------------

# Get a list of all of the environmental variable names & their values
Sys.getenv()

# Return the value of a particular environmental variable
Sys.getenv("NUMBER_OF_PROCESSORS")

# SQLite Setup ------------------------------------------------------------

# If it doesn't already exist, create a folder called "database"
fs::dir_create("database")

# If it doesn't already exist, create the a new SQLite database file called  
# "db-main" in our "database" directory
con <- DBI::dbConnect(
  drv = RSQLite::SQLite(), 
  "database/db-main.sqlite"
)

# Create the table schema 
app_history <- tibble::tibble(
  BeerName = character(0), 
  AbvValue = numeric(0), 
  CatOrDog = character(0),  
  UserName = character(0)
)

# Create AppHistoryTable table in SQLite db using the schema
DBI::dbWriteTable(
  conn = con,
  name = "AppHistoryTable",
  value = app_history
)
