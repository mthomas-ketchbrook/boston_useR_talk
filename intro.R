library(dplyr)
library(fs)
library(RSQLite)
library(emo)


con <- RSQLite::dbConnect(
  drv = RSQLite::SQLite(), 
  "database/db-main.sqlite"
)

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
  
  # Capture the number of files in the "input" directory
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
  
}

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


archive_file <- function(file_path, archive_directory) {
  
  # If the 'archive_path' directory does not already exist, create all of
  # the subfolders under "archive" that do not yet exist
  if (!dir.exists(archive_directory)) {
    
    dir.create(
      path = archive_directory, 
      recursive = TRUE   # If "FALSE", can only create one new folder at a time; since it's true, we can create 
    )
    
  }
  
  message(cat(
    emo::ji("hourglass"), 
    "Copying 1 file from \"input\" to \"archive\""
  ))
  
  file.copy(
    from = file_path,
    to = paste0(
      archive_directory,
      "/mtcars.csv"
    )
  )
  
  Sys.sleep(3)
  
  message(cat(
    emo::ji("check"), 
    "File successfully copied to", 
    archive_directory
  ))
  
}


archive_file(
  file_path = "input/mtcars.csv", 
  archive_directory = archive_dir_name
)

fs::dir_tree()



file.rename()

file.remove()
