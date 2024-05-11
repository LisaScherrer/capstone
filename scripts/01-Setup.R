library(httr)
library(jsonlite)

details<-read.csv("details.csv", sep = ";")

fetch_news_articles <- function(api_id, api_key, title, language = "en", published_at_start, published_at_end, max_results = 100) {
  url <- "https://api.aylien.com/news/stories"
  
  headers <- add_headers(
    `X-AYLIEN-NewsAPI-Application-ID` = api_id,
    `X-AYLIEN-NewsAPI-Application-Key` = api_key
  )
  
  all_articles <- list()
  current_page <- 1
  total_fetched <- 0
  
  repeat {
    query <- list(
      title = title,
      language = language,
      published_at_start = published_at_start,
      published_at_end = published_at_end,
      per_page = 10, # Adjust per page limit as needed, based on API max limits
      page = current_page
    )
    
    response <- GET(url, headers, query = query)
    articles <- content(response, "parsed", simplifyVector = TRUE)
    
    if (length(articles$stories) == 0 || total_fetched >= max_results) {
      break
    }
    
    all_articles <- c(all_articles, articles$stories)
    total_fetched <- total_fetched + length(articles$stories)
    current_page <- current_page + 1
  }
  
  return(all_articles)
}

api_id <- details$ID
api_key <- details$KEY
published_at_start <- "2023-01-01T00:00:00Z"
published_at_end <- "2024-12-31T23:59:59Z"
title <- "Interview"

# Fetch up to 100 articles
articles <- fetch_news_articles(api_id, api_key, title, "en", published_at_start, published_at_end, 100)