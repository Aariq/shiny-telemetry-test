# Using `shiny.telemetry`

Things to learn:

-   Object Oriented Programming (OOP) in R, specifically a little bit of R6
-   Relational databases---setting one up, reading data from one into R
-   Hosting a database on a server (or get someone else to do this for you)
-   Storing database credentials as environment variables on Posit Connect

Process:

1.  follow [quickstart guide](https://appsilon.github.io/shiny.telemetry/index.html) fir `shiny.telemetry`
2.  Modify data store. E.g. in this repo it uses a sqlite file, but you'd need to use `DataStorageMariaDB` or `DataStoragePostgreSQL` probably

``` r
telemetry <- Telemetry$new(
  data_storage = DataStorageSQLite$new(db_path = "telemetry.sqlite")
) 
```

3.  Add specifics about what you want to track in the server function with the various [`Telemetry$` functions](https://appsilon.github.io/shiny.telemetry/reference/Telemetry.html#methods). Use the `inputId` to target specific inputs.

``` r
server <- function(input, output) {
  telemetry$start_session() # 3. Minimal setup to track events
  telemetry$log_click("bins")
  telemetry$log_input("dropdown", track_value = TRUE)
  ...
```

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
