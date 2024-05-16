# Load Libraries -----------------
library(httr)
library(jsonlite)
library(dplyr)

# Retrieving Crossref Data ------------
## Creating an empty storage list-----------
requests1 <- list()

## For Loop Data Request -------------
for(x in 0:276) { #there are 276000 records in total
  req = GET(paste(sep="","https://api.crossref.org/works?query.affiliation=universit%C3%A4t+luzern&filter=type:journal-article&rows=1000&offset=", x*1000)) 
  #only 1000 records per request
  v <- rawToChar(req$content)
  print(paste("added request with offset:", x))
  print(paste(" len=",nchar(v)))
 if (nchar(v) < 10000) break;
  
 requests1[length(requests1)+1]=v
  save(requests1, file = "crossref.Rda") #save the data after every request
}
