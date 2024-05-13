#load libraries
library(dplyr)
#load data
load("crossref.Rda")

#join different data frames together
df_journal <- data.frame()
for(x in 1:length(requests1)){
data <- fromJSON(requests1[[x]], flatten = TRUE)
df1 <- data.frame(data$message$items)
df_journal <- bind_rows(df_journal, df1)
}

#save joined data frame
save(df_journal, file = "df_journal.Rda")
