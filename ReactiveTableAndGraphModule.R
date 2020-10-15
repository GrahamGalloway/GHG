reactiveTableAndGraph <- function(input, output, session) {
  
  
  #creating the sector plot
  sectorData <- filter(GHGdata,Pollutant=="Total - All Pollutants" & Year==currentYear & !(Sector =="Total - All Sectors" | Sector =="Land use, land use change and forestry") )
  sectorData$Sector [sectorData$Sector=="Transport (excluding international)"] <- "Transport"
  sectorData$Sector [sectorData$Sector=="International Aviation and Shipping"] <- "International Transport"         
  
  
  
  output$pieChartSector2 <- renderPlotly({
    plot_ly(sectorData, labels = ~Sector, values = ~Emissions, type = 'pie', textinfo = 'label+percent',
                            marker = list(colors = ~colors)) %>%
    layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           showlegend = FALSE)
  
 
    
  })
  
  
  
}

##############################################

chartTableBoxUI <- function(id, div_width = "col-xs-12 col-sm-6 col-md-4") {
  
  ns <- NS(id)
  

      tabBox(width = 12, title = id,
             tabPanel(icon("bar-chart"),
                      plotlyOutput(ns("pieChartSector2"))
             )
            
     )
  
  
}