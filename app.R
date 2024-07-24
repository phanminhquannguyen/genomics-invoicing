library(shiny)

# Define UI for application
ui <- fluidPage(
  # Application title
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with a sidebar and main panel
  sidebarLayout(
    sidebarPanel(
      h2("Sidebar"),
      p("This is a simple Shiny application that prints 'Hello, world!'")
    ),
    
    mainPanel(
      h1("Hello, world!")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # No server-side logic needed for this simple app
}

# Run the application
shinyApp(ui = ui, server = server)