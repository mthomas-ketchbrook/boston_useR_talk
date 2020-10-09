![](www/ketchbrook_logo.png)

<hr>

# Beyond R-*stats*: Workflow Management & Data Engineering in R

This repository contains materials associated with the lightning talk given at the [Boston useR Group](https://www.meetup.com/Boston-useR/) meetup on October 20, 2020. 

The file [intro.R](intro.R) provides examples of the R functions discussed in the lightning talk.

This code in this talk utilizes two unique packages, the [**fs** package](https://github.com/r-lib/fs) and the [**DBI** package](https://github.com/r-dbi/DBI):  

1. The **fs** package is used to interface with the file system (create directories, move files, etc.). Though R has base functions that do a lot of this (`dir.create()`, `file.copy()`, etc.), a list of reasons why **fs** functions are a safer choice can be found [here](https://github.com/r-lib/fs#comparison-vs-base-equivalents).  

2. The **DBI** package is used to interface with the database management systems, such as Postgres, SQL Server, SQLite, etc. In this talk, we will showcase how to send SQL statements to a SQLite database via the functions in this package.