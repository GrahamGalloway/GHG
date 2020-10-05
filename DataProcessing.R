#FIle does all the data manipulation that can be done before the app starts (runs only once)
#Main output is a dataframe called GHGdata that contains all the data read from stats.gov website
#It also prepares data needed for the various charts to save doing it repeateldy inside the app

#######################################################################################
# RETRIEVE DATA FROM STATISTICS.GOV.SCOT                                              #
#######################################################################################

# Define the statistics.gov.scot endpoint
endpoint <- "http://statistics.gov.scot/sparql"

# create query statement
query <-
  "PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?Year ?Sector ?Pollutant ?Emissions
WHERE {
?s qb:dataSet <http://statistics.gov.scot/data/greenhouse-gas-emissions-by-national-communications-category>;
<http://statistics.gov.scot/def/dimension/nationalCommunicationCategories> ?SectorURI;
<http://purl.org/linked-data/sdmx/2009/dimension#refPeriod> ?YearURI;
<http://statistics.gov.scot/def/dimension/pollutant> ?PollutantURI;
<http://statistics.gov.scot/def/measure-properties/count> ?Emissions.
?SectorURI rdfs:label ?Sector.
?YearURI rdfs:label ?Year.
?PollutantURI rdfs:label ?Pollutant.
}
ORDER BY ?Year ?Sector ?Pollutant"

# Use SPARQL package to submit query and save results to a data frame
qdata <- SPARQL(endpoint,query)
GHGdata <- qdata$results


#######################################################################################
# MANIPULATE DATA                                                                     #
#######################################################################################

# Calculate all pollutants and all sources categories and append to GHGdata
tmp1 <- aggregate(Emissions ~ Year + Pollutant, GHGdata, sum)
tmp1$Sector <- "Total - All Sectors"
tmp2 <- aggregate(Emissions ~ Year + Sector, GHGdata, sum)
tmp2$Pollutant <- "Total - All Pollutants"
tmp3 <- aggregate(Emissions ~ Year, GHGdata, sum)
tmp3$Pollutant <- "Total - All Pollutants"
tmp3$Sector <- "Total - All Sectors"
GHGdata <- rbind(GHGdata,tmp1,tmp2,tmp3)

#calculate some useful varibles from the data, such as most recent year and percent changes
currentYear = as.numeric(max(GHGdata$Year))
lastYear=currentYear-1
currentEm <-  filter( GHGdata, Sector=="Total - All Sectors" & Pollutant=="Total - All Pollutants" & Year==currentYear)$Emissions
lastEm <-  filter( GHGdata, Sector=="Total - All Sectors" & Pollutant=="Total - All Pollutants" & Year==lastYear)$Emissions
firstEm <-  filter( GHGdata, Sector=="Total - All Sectors" & Pollutant=="Total - All Pollutants" & Year==1990)$Emissions
currentLULUCF <- filter( GHGdata, Sector=="Land use, land use change and forestry" & Pollutant=="Total - All Pollutants" & Year==currentYear)$Emissions
perChangeLastYear <- currentEm/lastEm-1
perChange1990 <- currentEm/firstEm-1




# automatically define periods, sectors and pollutants for chart options
minyear <- as.numeric(min(GHGdata[,1]))
maxyear <- as.numeric(max(GHGdata[,1]))
sectorlist <- as.list(distinct(select(GHGdata,Sector)))
pollutantlist <- as.list(distinct(select(GHGdata,Pollutant)))
