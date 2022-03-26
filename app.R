#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(d96assign)
library(ggmap)
library(readxl)
library(writexl)

register_google(key = "yourkeygoeshere")

riversideMap <- qmap('Riverside,IL', zoom = 14, legend = 'topleft')
riversideMapBW <- qmap('Riverside,IL', zoom = 14, legend = 'topleft',color = 'bw')

ui <- fluidPage(
  
  # Title
  titlePanel("D96 Kindergarten Assignments"),
  
  # Sidebar  
  sidebarLayout(
    
    sidebarPanel(
   
      tags$small(paste0(
        "If the distance matrix has already been calculated, skip this step and just load the matrix. "
      )),   
      
      fileInput("file0", "Load Addresses",
                accept = c(
                  ".xls",
                  ".xlsx") 
      ),
        
     actionButton("do", "Calculate Distance Matrix"),
     
     
      fileInput("file1", "Load Distance Matrix",
                accept = c(
                  ".xls",
                  ".xlsx")
      ),
      
      tags$h5("Set constraints "), 
      
      sliderInput("Ames",
                  "Ames",
                  min = 0,
                  max = 100,
                  value = c(0, 100)) , 
      
      sliderInput("Blythe",
                  "Blythe",
                  min = 0,
                  max = 100,
                  value = c(0, 100))      , 
      
      sliderInput("Central",
                  "Central",
                  min = 0,
                  max = 100,
                  value = c(0, 100))  ,
      
      sliderInput("Hollywood",
                  "Hollywood",
                  min = 0,
                  max = 100,
                  value = c(0, 100)) ,
      
      wellPanel( tags$h5(paste0(
        "Totals for all students "
      )), tableOutput("statsWSibs") ) ,
      
      wellPanel(tags$h5(paste0(
        "Totals for assignable students "
      )), tableOutput("statsWOSibs") ), 
      
      # Button
      downloadButton("downloadData", "Download Assignments")
      
    ),
    
    # Main Panel
    mainPanel(
      tabsetPanel(
        
        tabPanel("Plot",  
                  plotOutput("distPlot", width = "100%", height = "900px",  
                            brush = brushOpts( id = "distPlot_brush" ) ) , verbatimTextOutput("brush_info") ) , 
        
        tabPanel("Assignments", tableOutput("table1") ) , 
        
        tabPanel("Distance Matrix", tableOutput("table2") ),
        
        tabPanel("Student Addresses", tableOutput("table3") ) 
        
        
      )
    )
  )  
  
)

server <- function(input, output) {
  
  kgAdds <- reactive({ 
    inFile <- input$file0
    
    if (is.null(inFile))
      return(NULL)
    
    read_excel(inFile$datapath)
  })
  
  observeEvent(input$do, {
  
    if(!is.null(kgAdds())){
      
      kga <- kgAdds()
      
      tmp <- getDistanceMatrix(kga)
      
      cat("\n")
      cat("Finished getting distance matrix", "\n")
      cat(paste("Status = ", tmp),"\n")
      geocodeQueryCheck()
      distQueryCheck()
      cat("\n")
      
    }
    
    
  })
  

  kgDist <- reactive({ 
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read_excel(inFile$datapath)
  })
  
  currentAssign  <- reactive({ 
    
    set.seed(1)
    minA <- input$Ames[1]
    maxA <- input$Ames[2]
    minB <- input$Blythe[1]
    maxB <- input$Blythe[2]
    minC <- input$Central[1]
    maxC <- input$Central[2]    
    minH <- input$Hollywood[1]
    maxH <- input$Hollywood[2]     
    
    kgr <- kgDist()
    if(!is.null(kgr))
    {
   
      defaultAssign <- assignStudents(kg = kgr, minA = minA, minB = minB, minC = minC, minH = minH, 
                                      maxA = maxA, maxB = maxB, maxC = maxC, maxH = maxH, penalty = 0)
      
      defaultAssign
    } else{ 
      defaultAssign <- NULL}
    
  })
  
  
  output$distPlot <- renderPlot({
    
    defaultAssign <- currentAssign()
    if(is.null(defaultAssign)){
      riversideMapBW
    }else{
      
      if(defaultAssign$status == 0){

        plotAssign(defaultAssign$assignment, what = "Assignment", ptitle = "",   
                    dsize = 3, print_map = F, googMap = riversideMap) } else 
                     {riversideMapBW}
    }
  })
  
  
  output$brush_info <- renderPrint({
    defaultAssign <- currentAssign()
    
    if(is.null(defaultAssign)){
      invisible()
    }else{
      
      if(defaultAssign$status == 0) {
        tassign <- defaultAssign$assignment
 
        row.names(tassign) <- NULL
        tassign[,c ("Ames", "Blythe",  "Central", "Hollywood")] <- round(tassign[,c ("Ames", "Blythe",  "Central", "Hollywood")],1)
        
        brushedPoints(tassign[,c("Last","First","Street","City","Assignment", "Siblings", "Ames", "Blythe",  "Central", "Hollywood","lat", "lon")], brush =  input$distPlot_brush, xvar = "lon", yvar = "lat")
        }
    }
  })
  
  
  output$statsWSibs <- renderTable({
    defaultAssign <- currentAssign()$schoolStats
    defaultAssign
  },rownames = T, digits = 0)
  
  
  output$statsWOSibs <- renderTable({
    defaultAssign <- currentAssign()$schoolStatsAssigned
    defaultAssign
  },rownames = T, digits = 0)
  
  
  # assignments 
  output$table1 <- renderTable({
      if(is.null(currentAssign())){
      
    }else{
      
      if(currentAssign()$status==0){
        defaultAssign <- currentAssign()$assignment
  
        defaultAssign[,c("Last", "First", "Street", "City", "Assignment", "Siblings", "Ames",	"Blythe",	"Central","Hollywood") ] } else{NULL}
    }
  } ,rownames = F, digits = 1)
  
  
  #  distance matrix 
  output$table2 <- renderTable({
    tmp <- kgDist()
    
    tmp[,c("Last", "First", "Street","City", "Siblings", "Ames", "Blythe",  "Central", "Hollywood","lat", "lon")]
  },rownames = F, digits = 1)
  
  # write student addresses table 
  output$table3 <- renderTable({
    kgAdds()
  },rownames = F, digits = 0)
  
  # write assignments to file  
  output$downloadData <- downloadHandler(
    filename = function() {
   
      paste0("Assignment-", format(Sys.time(), "%Y%m%d-%H-%M-%S"), ".xlsx", sep = "")
      
    },
    content = function(path) {
        write_xlsx(currentAssign()$assignment, path, col_names = TRUE)
    }
  )
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)

