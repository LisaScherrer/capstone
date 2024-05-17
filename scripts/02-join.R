# Load Packages ---------
library(dplyr)
library(jsonlite)

# Load Data --------------
load("crossref.Rda")

# Join Data Frames -------------
## Creating an Empty List ------------
df_journal <- data.frame()

## Main Loop ------------
for(x in 1:length(requests1)){
  # Process Request Data 
  data <- fromJSON(requests1[[x]], flatten = TRUE)
  df1 <- data.frame(data$message$items)
  
  # Join Data Frames
  df_journal <- bind_rows(df_journal, df1)
}

# Save Joined Data Frame --------------
save(df_journal, file = "df_journal.Rda")
