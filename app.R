library(shiny)
library(readxl)
library(tidyr)
library(DT)
library(shinyjs)

# Parse data
parse_data <- function(df) {
  df <- df %>% replace_na(replace = as.list(rep(0, ncol(df))))
  return(df)
}

# Define UI
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  useShinyjs(), 
  uiOutput("main_ui")
)

# Define server logic
server <- function(input, output, session) {
  # Page state
  current_page <- reactiveVal("main")
  
  # Data containers
  raw_data <- reactiveVal(NULL)
  processed_data <- reactiveVal(NULL)
  invoice_items <- reactiveVal(NULL) # To store selected items for the invoice
  file_path <- reactiveVal(NULL)
  
  # Update file path when a file is selected
  observeEvent(input$file, {
    req(input$file)
    file_path(input$file$datapath)
    raw_data(NULL)
    processed_data(NULL)
    invoice_items(NULL)
  })
  
  # Read and process data when the upload button is clicked
  observeEvent(input$upload_button, {
    fp <- file_path()
    if (!is.null(fp)) {
      df <- read_excel(fp)
      raw_data(df)
      df <- parse_data(df)
      processed_data(df)
    } else {
      showNotification("Please upload a file first.", type = "warning")
    }
  })
  
  # Navigate to invoice creation page
  observeEvent(input$create_invoice_page, {
    current_page("create_invoice")
  })
  
  # Handle row selection in the data table
  observeEvent(input$data_table_rows_selected, {
    selected_rows <- input$data_table_rows_selected
    if (!is.null(processed_data()) && length(selected_rows) > 0) {
      invoice_items(processed_data()[selected_rows, ])
    } else {
      invoice_items(NULL)
    }
  })
  
  # Back button on invoice creation page
  observeEvent(input$back_to_main, {
    current_page("main")
    invoice_items(NULL) # Clear selected items
  })
  
  # UI renderer
  output$main_ui <- renderUI({
    if (current_page() == "main") {
      fluidPage(
        div(class = "navbar",
            div(class = "navbar-right",
                actionButton("home", "Home", class = "nav-button"),
                actionButton("about", "About", class = "nav-button"),
                actionButton("contact", "Contact", class = "nav-button")
            )
        ),
        
        div(class = "content",
            div(class = "center-container",
                sidebarLayout(
                  sidebarPanel(
                    div(class = "sidebar-box",
                        h2("Create Genomics Invoicing"),
                        fileInput("file", "Upload Master Spreadsheet (.xlsx)", accept = ".xlsx"),
                        actionButton("upload_button", "Upload Master Spreadsheet", class = "upload-button"),
                        uiOutput("create_invoice_page_ui")
                    )
                  ),
                  mainPanel(
                    DT::dataTableOutput("data_table")
                  )
                )
            )
        )
      )
    } else if (current_page() == "create_invoice") {
      fluidPage(
        div(class = "content",
            div(class = "center-container",
                h2("Select Items for Invoice"),
                DT::dataTableOutput("selected_items_table"),
                br(),
                actionButton("back_to_main", "Back to Main", class = "back-button"),
                actionButton("generate_invoice", "Generate Invoice", class = "action-button")
            )
        )
      )
    }
  })
  
  # Show "Create Invoice Page" button only after upload
  output$create_invoice_page_ui <- renderUI({
    req(processed_data())
    actionButton("create_invoice_page", "Create Invoice", class = "invoice-button")
  })
  
  # Render the interactive data table for item selection
  output$data_table <- DT::renderDataTable({
    req(processed_data())
    processed_data()
  }, selection = "multiple")
  
  # Render the table of selected items for the invoice
  output$selected_items_table <- DT::renderDataTable({
    req(invoice_items())
    invoice_items()
  })
  
  # Observe event for generating the final invoice 
  observeEvent(input$generate_invoice, {
    req(invoice_items())

    # navigating to a "invoice generated" page or triggering a download.
    showNotification("Invoice generated (logic to be implemented)", type = "message")
  })
}

# Run the application
shinyApp(ui = ui, server = server)