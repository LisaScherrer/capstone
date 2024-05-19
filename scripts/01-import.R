# Load Packages -----------------
library(httr)
library(jsonlite)
library(dplyr)

# Retrieving Data ------------

## Creating an Empty List -----------
requests1 <- list()

## Main Loop -------------
  # Request for a total of 276000 records
for(x in 0:276) {
  
  # GET request for each 1000 records
  req = GET(paste(sep="","https://api.crossref.org/works?query.affiliation=universit%C3%A4t+luzern&filter=type:journal-article&rows=1000&offset=", x*1000)) 
 
  # Convert raw data to character
  v <- rawToChar(req$content)
  print(paste("added request with offset:", x))
  print(paste(" len=",nchar(v)))
  
  # Break the loop if the character length is less than 10000
 if (nchar(v) < 10000) break;
  
  # Add the request to the list
 requests1[length(requests1)+1]=v
  
  # Save the data after every request
  save(requests1, file = "crossref.Rda") #save the data after every request
}
