# shinyjrnl.R

# Init ----
library(shiny)
library(knitr)
library(readr)
library(pdftools)
library(ruimtehol)
library(dplyr)

# Source Files ----
source("func_clean.R")
source("func_tag.R")

class_tb <- read_csv("class_tb.csv")
model <- starspace_load_model("jrnl.ruimtehol", method = "ruimtehol")
ct_val <- 0
kw_val <- 0
er_val <- 0
rf_val <- 0
pr_val <- 0
df <- 0

# ui ----
ui <- fluidPage(
  # set initial value

  # App title
  titlePanel("Student's Assingment Grading"),
  
  # Sidebar layout ----
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # Input: Select a file
      fileInput("file", "Get File"),
      
      # Input: input for parameters
      # set min, max for class
      numericInput(inputId = "ct",
                   label = "Content",
                   value = ct_val),
      numericInput(inputId = "kw",
                   label = "Knowledge",
                   value = kw_val),
      numericInput(inputId = "er",
                   label = "Reading",
                   value = er_val),
      numericInput(inputId = "rf",
                   label = "Reference",
                   value = rf_val),
      numericInput(inputId = "pr",
                   label = "Presentation",
                   value = pr_val),
      
      # Action button
      actionButton("butgrd", label = "Grade"),

      tags$hr(),
      
      # Download button ----
      downloadButton("report", "Download Form")
    ),
    
    # Main panel ----
    mainPanel(
      
      # Output: Tabset w/plot, summary, and table
      tabsetPanel(type = "tabs",
                  tabPanel("Grade", tableOutput("grade")),
                  tabPanel("Grade Table", tableOutput("gd_tb"))
      )
    )
  )
)

# server ----
server <- function(input, output, clientData, session) {
  # read file ----
  paraph <- reactive({
    req(input$file)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
      
        txt <- pdftools::pdf_text(input$file$datapath)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    return(txt)
  })
  
  # Set gred ----
  tb_val <- reactive({
    # Pred ----
    txt <- clean_string(paraph())
    pred <- tag_fun(txt)
    tb <- class_tb %>% 
      filter(classification == pred)
  })
  
  # Init ui ----
  output$gd_tb <- renderTable({
    grade <- tb_val()
    ct_val <- grade$ct_min
    ct_max <- grade$ct_max
    kw_val <- grade$kw_min
    kw_max <- grade$kw_max
    er_val <- grade$er_min
    er_max <- grade$er_max
    rf_val <- grade$rf_min
    rf_max <- grade$rf_max
    pr_val <- grade$pr_min
    pr_max <- grade$pr_max
    
    # update ui ----
    updateNumericInput(session, "ct", max = ct_max, value = ct_val)
    updateNumericInput(session, "kw", max = kw_max, value = kw_val)
    updateNumericInput(session, "er", max = er_max, value = er_val)
    updateNumericInput(session, "rf", max = rf_max, value = rf_val)
    updateNumericInput(session, "pr", max = pr_max, value = pr_val)
    
    names(grade) <- c("Classification",
                   "Content\n(Min)","Content\n(Max)",
                   "Knowledge\n(Min)","Knowledge\n(Max)",
                   "Reading\n(Min)","Reading\n(Max)",
                   "Reference\n(Min)","Reference\n(Max)",
                   "Presentation\n(Min)","Presentation\n(Max)")
    grade

  })
  
  # Regrade ----
  observeEvent(input$butgrd,{
    output$grade <- renderTable({
      # compute marks ----
      marks <- input$ct + input$kw + input$er + input$rf + input$pr
      df <- data.frame(Content = input$ct, Knowledge = input$kw,
                       Reading = input$er, Reference = input$rf,
                       Presentation = input$pr, Mark = marks)
    })
  })
  
  # Download Handler -----
  
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    file = "report.pdf",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      
      tempReport <- file.path(tempdir(), "report.Rmd")
      
      file.copy("eb_mark.Rmd", tempReport, overwrite = TRUE)
      file.copy("eb_form.R", tempReport, overwrite = TRUE)
      
      # Set grade from re-grade module
      grade <- df
      
      # Set up parameters to pass to Rmd document
      params <- list(marks = grade)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = "marking.pdf",
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)