# Load Packages ---------
library(dplyr)

# Load Data --------------
load("crossref.Rda")

# Join Data Frames -------------
df_journal <- data.frame()
for(x in 1:length(requests1)){
data <- fromJSON(requests1[[x]], flatten = TRUE)
df1 <- data.frame(data$message$items)
df_journal <- bind_rows(df_journal, df1)
}

#Save Joined Data Frame --------------
save(df_journal, file = "df_journal.Rda")
