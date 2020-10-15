PageDataTab <- fluidPage(
  
  # Title
  tags$head(HTML("<title>GHG emissions by source sector and pollutant, Scotland</title>")),
  titlePanel(h1("GHG emissions by source sector and pollutant, Scotland")),
  
  # Sidebar 
  sidebarPanel(
    
    tags$h3("Options"),
    
    # Specification of range within an interval
    sliderInput("range", "Select years:",
                min = minyear, max = maxyear, value = c(1998,maxyear),sep = ""),
    
    # Insert a picker widget for source sectors
    pickerInput(
      inputId = "source_choose", 
      label = "Select source sectors", 
      choices = sectorlist$Sector, selected=sectorlist$Sector[1:10], options = list(`actions-box` = TRUE), 
      multiple = TRUE
    ),
    
    # Insert a picker widget for pollutants
    pickerInput(
      inputId = "pollutant_choose", 
      label = "Select pollutants", 
      choices = pollutantlist$Pollutant, selected=pollutantlist$Pollutant[8], options = list(`actions-box` = TRUE), 
      multiple = FALSE
    ),
    
    # Download Button
    downloadButton("downloadDataSelected", "Download selected data"),
    downloadButton("downloadDataFull", "Download full data"),
    
    # HTML STUFF - PROBABLY MOVE INTO A TAB ALONG WITH A DESCRIPTION
    tags$br(),
    tags$br(),
    tags$h3("Links"),
    tags$a(href="https://github.com/andrew-mortimer/GHG_shiny_app", "Download the source code (outdated)"),
    tags$br(),
    tags$a(href="https://statistics.gov.scot/data/greenhouse-gas-emissions-by-national-communications-category", "See original Data source")
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Summary", plotlyOutput("plot")),
      
      tabPanel("Table", 
               DT::dataTableOutput('filtered_data')
      )
      
    )
  ),
  "Please use options to select data that you wish to view. The data can be displayed as a chart or downloadable table below. You can hover over the chart to view categories and values"
  
)