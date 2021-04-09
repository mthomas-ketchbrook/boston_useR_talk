![](www/ketchbrook_logo.png)

<hr>

# Beyond R-*stats*: Workflow Management & Data Engineering in R

This repository contains materials associated with the lightning talk given at the [Boston useR Group](https://www.meetup.com/Boston-useR/events/273566159/) meetup on October 20, 2020. 

The file [intro.R](intro.R) provides examples of the R functions discussed in the lightning talk.

This code in this talk utilizes two unique packages, the [**fs** package](https://github.com/r-lib/fs) and the [**DBI** package](https://github.com/r-dbi/DBI):  

1. The **fs** package is used to interface with the file system (create directories, move files, etc.). Though R has base functions that do a lot of this (`dir.create()`, `file.copy()`, etc.), a list of reasons why **fs** functions are a safer choice can be found [here](https://github.com/r-lib/fs#comparison-vs-base-equivalents).  

2. The **DBI** package is used to interface with database management systems, such as Postgres, SQL Server, SQLite, etc. In this talk, we will showcase how to send SQL statements to a SQLite database via the functions in this package.

## How it All Works Together...

The talk begins by demonstrating moving around the file system with both base R and the **fs** package. The [intro.R](intro.R) script demonstrates how to write a dataframe to a delimited file, remove files from a directory, copying a file from one directory to another, and renaming files. At the end of the script, a SQLite database (and database table) are created.  

The second part of the talk showcases how to use the **DBI** package to write data to a SQLite database. A [Shiny app](app.R) was created to demonstrate how a user's manual input, as well as a user's characteristics (using R environmental variables garnered from the `Sys.getenv()` base R function) can be captured within a Shiny app and written to a SQLite database with -- literally -- the *"click of a button!"*.
