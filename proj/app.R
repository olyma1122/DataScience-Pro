library(shiny)
library(ggvis)
library(ggfortify)

d<- readRDS("litedata.rds")

specieschoices <- unique(as.character(d$is_churn))
print(as.character(names(d[,2:7])))

# UI

ui<-fluidPage(
  headerPanel("Data Science Pro"),
  sidebarPanel(
    
    h4("Data Dimensions"),
    h6("*for 'Data Dimensions' paging ONLY"),
    selectInput(inputId = "x", label="x-axis Variable:", choices=as.character(names(d[,2:7])),selected='city'),
    selectInput(inputId = "y", label="y-axis Variable:", choices=as.character(names(d[,2:7])),selected='payment_plan_days'),
    
    sliderInput("n", 
                "Number of observations:", 
                value = 1200, step = 300,
                min = 1, 
                max = 1400,
                animate=animationOptions(interval=500, loop=T)),
    
    
    
    uiOutput("plot_ui")
  ),
  mainPanel(
    
    tabsetPanel(
      tabPanel("Data Dimensions", ggvisOutput("plot"),tableOutput("mtc_table")), 
      
      #tabPanel("PCA Summary", verbatimTextOutput("table1"),verbatimTextOutput("table2"),dataTableOutput("data1")),
      
      tabPanel("Original data", dataTableOutput("data1"))
      
      
    )
  )
)

#SERVER
server<-function(input,output,session){
  
  numberofdata <- reactive({
    print("Enter >>aa")
    d[1:input$n, ] 
    

  })
  
  vis <- reactive({
    print("Enter >>bb")
    d[1:input$n, ] 
    
    xvar <- prop("x", as.symbol(input$x))
    yvar <- prop("y", as.symbol(input$y))
    #Plot Data with Visualization Customization
    p1 = numberofdata() %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size.hover := 200,fillOpacity:= 0.5, fillOpacity.hover := 1,fill = ~is_churn) %>%
      
      #Specifies the size of the plot
      set_options(width = "auto", height = 500, duration = 0)
    
  })
  #Actually plots the data
  vis %>% 
    bind_shiny("plot", "plot_ui")

  
  output$table1 <- renderPrint({
    df <- d[c(1, 2, 3, 4, 5, 6, 7)]
    (prcomp(df))
  
  })
  
  output$table2 <- renderPrint({
    df <- d[c(1, 2, 3, 4, 5, 6, 7)]
    summary(prcomp(df))
  })
  
  output$data1 <- renderDataTable({
    d
  })
  
}

#Run the Shiny App to Display Webpage
shinyApp(ui=ui, server=server)

