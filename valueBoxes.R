#handles preparing any value boxes needed, 
#these are later rendered in the server, and placed by the UI functions


# displays total emissions for current year
valueBoxTotEmissions <- valueBox(
  value=paste(round(currentEm,1),"MtCO2e"),
  subtitle=paste("Greenhouse gas Emissions in  ",currentYear),
  icon = icon("stats",lib='glyphicon'),
  color = "purple"
  )


#controls the wording for increase/decrease of emisions
emUpDown="Decrease"
if(perChangeLastYear>0) {
  emUpDown="Increase"
}

#displays percent change sinc elast year
valueBoxYearChange <- valueBox(
  value=paste(abs(round(perChangeLastYear*100,1)),"%"),
  subtitle=paste(emUpDown," in emissions from ",lastYear," to ",currentYear),
  icon = icon("stats",lib='glyphicon'),
  color = "green"
  )

#controls the wording for increase/decrease of emisions
emUpDown1990="Decrease"
if(perChange1990>0) {
  emUpDown1990="Increase"
}

#displays percent change since 1990
valueBoxChange1990 <- valueBox(
  value=paste(abs(round(perChange1990*100,1)),"%"),
  subtitle=paste(emUpDown1990," in emissions since 1990"),
  icon = icon("stats",lib='glyphicon'),
  color = "green"
  )

