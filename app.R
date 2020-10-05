#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#.libPaths("C:/R")

# load the required packages
library(shiny)
require(shinydashboard)
library(ggplot2)
library(plyr)
library(dplyr)
library(rsconnect)
library(SPARQL) 
library(shinyWidgets)
library(DT)
library(tidyr)
library(plotly)



source('DataProcessing.R') # reads data from stats.gov and prepares various data frames that will be needed
source('valueBoxes.R') # code to prepare value boxes
source('Graphs.R') # code to make the static (non reactive) graphs
source('PageDataSummary.R') # code that gives UI layout for summary page
source('PageDataTab.R') #code that gives UI layout for the data exploring tab


############################### UI #####################################
theme_set(theme_minimal(base_size = 16))

# Define UI for application that draws a histogram
ui <- dashboardPage(
  
  title="Greenhouse gas emissions Scotland", 
  dashboardHeader(title = "Green House  Gas"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("DataSummary", tabName = "dataSummaryTab", icon = icon("th")),
      #here add name of the menu items     
      menuItem("Data", tabName = "dataTab", icon = icon("line-chart")) 
    )
  ), # end sidebar
  
  dashboardBody(
    #adding css file
    tags$head(
      includeCSS("style.css")
    ),
    tabItems(
      tabItem(tabName = "dataSummaryTab",
      PageDataSummary #summary page prepared in own R file, displays summary stats
      ),
      tabItem(tabName = "dataTab",
      PageDataTab #data summary page prepared in own R file, displays data tab that lets you explore data
      )
    )#end tab items
  ) # end dash body
)#end UI


############################## server ##############################

server <- function(input, output) {

  #creating the valueBoxOutput content
  output$valueBoxTotEmissions <- renderValueBox({    valueBoxTotEmissions  })
  output$valueBoxYearChange <- renderValueBox({    valueBoxYearChange  })
  output$valueBoxChange1990  <- renderValueBox({    valueBoxChange1990   })
  
  #creating the sector plot
  output$pieChartSector <- renderPlotly({    pieChartSector  })
  output$pieChartPollutant <- renderPlotly({    pieChartPollutant  })
 
  #create sector change bar chart
  output$sectorChangeChart <- renderPlotly({    sectorChangeChart  })

  #create sector change bar chart
  output$sectorChangeChartLast <- renderPlotly({    sectorChangeChartLast  })
  
  # reactive section Set it up for the check boxes for source sectors
  data_1=reactive({
    return(GHGdata[GHGdata$Sector%in%input$source_choose&GHGdata$Pollutant%in%input$pollutant_choose& GHGdata$Year>= input$range[1] & GHGdata$Year<= input$range[2],])
  })

  # output filtered data table
  output$filtered_data = DT::renderDataTable({
    DT::datatable(data_1(),
                options = list(lengthMenu = c(25, 50, 100), pageLength = 25),
                rownames = FALSE
                )
    
  })
  
  
  # Downloadable csv of selected dataset ----
  #  output$downloadData <- downloadHandler(content = subset(data_1(),  Year>= input$range[1] & Year<= input$range[2], filename="downloadData"))
  # here a tutorial to make this work
  ### https://shiny.rstudio.com/articles/download.html
  
  # Step 4 Use plotly to draw interactive linechart
  output$plot <- renderPlotly({
    
    #get relavent data taking into account user choices
    datasub=subset( GHGdata[GHGdata$Sector%in%input$source_choose[]&GHGdata$Pollutant%in%input$pollutant_choose,],  Year>= input$range[1] & Year<= input$range[2])
    
    sd <- datasub[ , c(1, 4, 2)]    
    
    #define a lotly graph object
    fig <- plot_ly()
    
    #loop through the sectors selected by user and add to graph
    for (i in input$source_choose[]){
      
      sect <- sd[sd$Sector== i,]
      
      #used to define labels for the hover text
      #theres a built in function called hoverformat that should do this but I couldn't get it to work
      label <- paste(sect[[1,3]],"\n ",round(sect[[2]],1)," MtC02")
      
      
      #add each line to the graph
      fig <- fig %>% add_trace(x = sect[[1]], y = sect[[2]], name = sect[[1,3]],
                               type = 'scatter',
                               mode = 'lines',
                               width = 4,
                               text = label,
                               hoverinfo = 'text'
                               
      )
    }  #ends loop over sectors
    
    
    #format graph axes etc here
    fig <- fig %>%
      layout(title = "",
             xaxis = list(title = "Year"),
             yaxis = list (title = "MtC02e"),
             
             showlegend = FALSE,
             legend = list(orientation = "h",   # show entries horizontally
                           xanchor = "center",  # use center of legend as anchor
                           yanchor = "top",
                           x = 100,
                           y=-50,
                           title=list(text='<b> Sectors </b>')
             )
      )
    
    print(fig)
    
    
  })
 
  # Downloadable csv of selected dataset ----
  output$downloadDataSelected <- downloadHandler(
    filename = "greenhouseGasDataCustom.csv",
    content = function(file) {
      write.csv(data_1(), file,row.names=FALSE)
    }
  )
  
  #same as above but for full dataset
  output$downloadDataFull <- downloadHandler(
    filename = "greenhouseGasDataFull.csv",
    content = function(file) {
      write.csv(GHGdata, file,row.names=FALSE)
    }
  )
  
  

}

############## run ############################

# Run the application 
shinyApp(ui = ui, server = server)

