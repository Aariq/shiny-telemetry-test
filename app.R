#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shiny.telemetry)

# 1. Initialize telemetry with default options
telemetry <- Telemetry$new(
  data_storage = DataStorageSQLite$new(db_path = "telemetry.sqlite")
) 


# Define UI for application that draws a histogram
ui <- fluidPage(
  use_telemetry(), # 2. Add necessary Javascript to Shiny
  
  titlePanel("Old Faithful Geyser Data"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      selectInput("dropdown",
                  "Dropdown Menu",
                  choices = c("A", "B", "C"))
    ),
    
    mainPanel(
      tabsetPanel(
        id = "tabpanel", # give tabsetPanel an optional id so tracking works
        tabPanel("tab 1", plotOutput("distPlot")),
        tabPanel("tab 2", shiny::h1("HELLO")),
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # 3. Setup to track events
  telemetry$start_session(
    track_inputs = TRUE,
    track_values = TRUE,
    browser_version = FALSE,
    navigation_input_id = "tabpanel" #id of navbar or tabpanel
  ) 
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

shinyApp(ui = ui, server = server)
