# Using `shiny.telemetry`

## Things to learn:

-   Object Oriented Programming (OOP) in R, specifically a little bit of [R6](https://r6.r-lib.org/)
-   Database basics (what is it, how to connect to it, etc. Don't need to learn SQL)
-   Hosting a Postgres, MariaDB, or MySQL database on a server (or get someone else to do this for you)
-   Storing database credentials as environment variables on Posit Connect
-   Connecting to and reading data from a database into R

## Process for setting this up with the needs assessment app ***locally*** **(on your computer only)**:

1.  follow [quickstart guide](https://appsilon.github.io/shiny.telemetry/index.html) for `shiny.telemetry`
2.  Modify data store to use a .sqlite file like so:

``` r
telemetry <- Telemetry$new(
  data_storage = DataStorageSQLite$new(db_path = "telemetry.sqlite")
) 
```

3.  Set up tracking options by adjusting arguments to `telemetry$start_session()` . See app.R for examples. May need to assign `id` to navbar.
4.  Read the data with `shiny.telemetry::Telemetry$new()$data_storage$read_event_data()`

``` r
shiny.telemetry::Telemetry$new()$data_storage$read_event_data()
# # A tibble: 6 × 8
#   time                app_name    session                    type  value id    date       username
#   <dttm>              <chr>       <chr>                      <chr> <chr> <chr> <date>     <chr>   
# 1 2023-07-20 18:20:52 (dashboard) 052ac84b776b03699160e06e1… input NA    drop… 4628696-1… NA      
# 2 2023-07-20 18:20:52 (dashboard) 052ac84b776b03699160e06e1… input B     drop… 4628696-1… NA      
# 3 2023-07-20 18:20:53 (dashboard) 052ac84b776b03699160e06e1… input NA    drop… 4628696-1… NA      
# 4 2023-07-20 18:20:53 (dashboard) 052ac84b776b03699160e06e1… input A     drop… 4628696-1… NA      
# 5 2023-07-20 18:20:55 (dashboard) 052ac84b776b03699160e06e1… input NA    bins  4628696-1… NA      
# 6 2023-07-20 18:20:55 (dashboard) 052ac84b776b03699160e06e1… logo… NA    NA    4628696-1… NA      
```

## To set this up to work with the published app:

1.  You'll need to use a web-accessible database, so instead of `data_storage = DataStorageSQLite` you'll use `DataStorageMariaDB` or `DataStoragePostgreSQL`, for example
2.  Save credentials for accessing the database as environment variables in .Renviron (BUT DON'T COMMIT THIS FILE!) and use them in setting up the data storage.
3.  You'll need to save the credentials for accessing the database as environment variables in the published app on Posit Connect.
4.  Figure out how to read data from database! `telemetry$data_storage$read_event_data()` might still work, but you might need to learn to read data into R from relational databases (this is not too difficult)
