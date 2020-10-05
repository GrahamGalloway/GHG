#prepares an entire page that can be displayed in the shiny app
#page displays various summary stats and graph

PageDataSummary <- fluidPage(
  titlePanel(paste("Greenhouse Gas Emissions for Scotland ",currentYear)),
  fluidRow(
    valueBoxOutput("valueBoxTotEmissions"),
    valueBoxOutput("valueBoxYearChange"),
    valueBoxOutput("valueBoxChange1990")
  ),
  column(12,
         
         # box(
         #  title = "sector"
         #  ,status = "primary"
         #  ,solidHeader = TRUE 
         #  ,collapsible = TRUE ,
         paste0("Showing Scotlands emissions by National Communication Categories for ",currentYear),
         HTML('<br>'),
         paste0("The chart does not include 'Land use, land use change and forestry' as its an overall carbon sink of ",round(currentLULUCF,2), " MtC02e"),
         plotlyOutput("pieChartSector"),
         paste("Showing Scotland emissions by pollutant for ",currentYear),
         plotlyOutput("pieChartPollutant"),
         paste("Change in emissions from 1990 to ",currentYear),
         plotlyOutput("sectorChangeChart"),
         paste("Change in emissions from ",lastYear," to ",currentYear),
         plotlyOutput("sectorChangeChartLast")
         #  )
  )
)