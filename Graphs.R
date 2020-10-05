#creating the sector plot
sectorData <- filter(GHGdata,Pollutant=="Total - All Pollutants" & Year==currentYear & !(Sector =="Total - All Sectors" | Sector =="Land use, land use change and forestry") )
sectorData$Sector [sectorData$Sector=="Transport (excluding international)"] <- "Transport"
sectorData$Sector [sectorData$Sector=="International Aviation and Shipping"] <- "International Transport"         



  pieChartSector <- plot_ly(sectorData, labels = ~Sector, values = ~Emissions, type = 'pie', textinfo = 'label+percent',
          marker = list(colors = ~colors)) %>%
    layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           showlegend = FALSE)
  
##################################################################
  
  #creating the pollutant plot
  pollutantData <- filter(GHGdata, Year==currentYear & Sector =="Total - All Sectors" &! Pollutant=="Total - All Pollutants" )
  
  
 
  pieChartPollutant <- plot_ly(pollutantData, labels = ~Pollutant, values = ~Emissions, type = 'pie', textinfo = 'label+percent',
            marker = list(colors = ~colors)) %>%
      layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             showlegend = FALSE)
    
  
  
  ######################################################################
  #data needed for charts
  #sector changes
  sector1990 <- filter( GHGdata,  Pollutant=="Total - All Pollutants" & Year=="1990")
  sector1990 <-sector1990 %>% rename(Emissions1990 = Emissions)
  sectorLast <- filter( GHGdata,  Pollutant=="Total - All Pollutants" & Year==lastYear)
  sectorLast <-sectorLast %>% rename(EmissionsLast = Emissions)
  sectorCurrent <- filter( GHGdata,  Pollutant=="Total - All Pollutants" & Year==currentYear)
  sectorCurrent <- sectorCurrent %>% rename(EmissionsCurrent = Emissions)
  
  sectorMerge <- merge(sector1990,sectorCurrent,by="Sector")
  sectorMerge <- merge(sectorMerge,sectorLast,by="Sector")
  sectorMerge <- subset(sectorMerge,select = c(Sector,Emissions1990, EmissionsLast, EmissionsCurrent ))
  
  sectorMerge <- transform(sectorMerge, perChange1990toCurrent = 100*(sectorMerge$EmissionsCurrent/sectorMerge$Emissions1990-1))
  sectorChange <- transform(sectorMerge, perChangelastYear = 100*(sectorMerge$EmissionsCurrent/sectorMerge$EmissionsLast-1))
  sectorChange <- sectorChange[!(sectorChange$Sector=="Land use, land use change and forestry"),] 
  sectorChange <- sectorChange[order(sectorChange$perChange1990toCurrent),]
  
  sectorChangeO1 <- sectorChange[order(sectorChange$perChange1990toCurrent),]
  sectorChangeO2 <- sectorChange[order(sectorChange$perChangelastYear),]
  
  
  #create sector change bar chart
  sectorChangeChart <-   plot_ly(sectorChangeO1, y = ~Sector, x = ~perChange1990toCurrent, type = 'bar',orientation = 'h', name = 'SF Zoo') %>% 
      layout(
        xaxis = list(title = '% change'), 
        barmode = 'group',
        yaxis = list(title = "",
                     categoryorder = "array",
                     categoryarray = ~Sector)
      )
    
    
  #####################################################################
  
  #create sector change bar chart
  sectorChangeChartLast <-     plot_ly(sectorChangeO2, y = ~Sector, x = ~perChangelastYear, type = 'bar',orientation = 'h', name = 'SF Zoo') %>% 
      layout(
        xaxis = list(title = '% change'), 
        barmode = 'group',
        yaxis = list(title = "",
                     categoryorder = "array",
                     categoryarray = ~Sector)
      )
    
    
  
  
  


