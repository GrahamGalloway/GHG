#creating the sector plot
sectorData <- filter(GHGdata,Pollutant=="Total - All Pollutants" & Year==currentYear & !(Sector =="Total - All Sectors" | Sector =="Land use, land use change and forestry") )
sectorData$Sector [sectorData$Sector=="Transport (excluding international)"] <- "Transport"
sectorData$Sector [sectorData$Sector=="International Aviation and Shipping"] <- "International Transport"         

percent <- 100*sectorData$Emissions/sum( sectorData$Emissions)
label <- paste(sectorData$Sector,"\n ",round(sectorData$Emissions,1)," MtC02","\n ",round(percent,1)," %")

  pieChartSector <- plot_ly(sectorData, labels = ~Sector, values = ~Emissions, type = 'pie', textinfo = 'label+percent',
                            text = label,
                            hoverinfo = 'text',
          marker = list(colors = ~colors)) %>%
    layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           showlegend = FALSE)
  
##################################################################
  
  #creating the pollutant plot
  

  
  pollutantData <- filter(GHGdata, Year==currentYear & Sector =="Total - All Sectors" &! Pollutant=="Total - All Pollutants" )
  percent <- 100*pollutantData$Emissions/sum( pollutantData$Emissions)
  label <- paste(pollutantData$Pollutant,"\n ",round(pollutantData$Emissions,1)," MtC02","\n ",round(percent,1)," %")
  
 
  pieChartPollutant <- plot_ly(pollutantData, labels = ~Pollutant, values = ~Emissions, type = 'pie', textinfo = 'label+percent',
                               text = label,
                               hoverinfo = 'text',
            marker = list(colors = ~colors)) %>%
      layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             showlegend = FALSE
            )
    
  
  
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
  label <- paste( sectorChangeO1$Sector,"\n ",round(sectorChangeO1$perChange1990toCurrent,1)," %")
  
  sectorChangeChart <-   plot_ly(sectorChangeO1, y = ~Sector,
                                 x = ~perChange1990toCurrent, 
                                 type = 'bar',orientation = 'h',
                                 name = 'SF Zoo',
                                 text = label,
                                 hoverinfo = 'text') %>% 
      layout(
        xaxis = list(title = '% change'), 
        barmode = 'group',
        yaxis = list(title = "",
                     categoryorder = "array",
                     categoryarray = ~Sector)
      )
    
    
  #####################################################################
  
  #create sector change bar chart
  label <- paste( sectorChangeO2$Sector,"\n ",round(sectorChangeO2$perChangelastYear,1)," %")
  sectorChangeChartLast <-     plot_ly(sectorChangeO2,
                                       y = ~Sector,
                                       x = ~perChangelastYear,
                                       type = 'bar',orientation = 'h',
                                       name = 'SF Zoo',
                                       text = label,
                                       hoverinfo = 'text'
                                       ) %>% 
      layout(
        xaxis = list(title = '% change'), 
        barmode = 'group',
        yaxis = list(title = "",
                     categoryorder = "array",
                     categoryarray = ~Sector)
      )
    
    
  
  
  


