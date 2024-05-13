library(httr)
library(jsonlite)
library(dplyr)
#res = GET("https://api.crossref.org/works?query.affiliation=universit%C3%A4t+luzern&filter=type:journal-article")

requests1 <- list()
for(x in 0:276) {
  req = GET(paste(sep="","https://api.crossref.org/works?query.affiliation=universit%C3%A4t+luzern&filter=type:journal-article&rows=1000&offset=", x*1000))
  v <- rawToChar(req$content)
  print(paste("added request with offset:", x))
  print(paste(" len=",nchar(v)))
 if (nchar(v) < 10000) break;
  
 requests1[length(requests1)+1]=v
  save(requests1, file = "crossref.Rda")
}

#rawToChar(
#View(requests1[1])
#data = fromJSON(requests1[[1]], flatten = TRUE)
#data = fromJSON(rawToChar(res$content), flatten = TRUE)
