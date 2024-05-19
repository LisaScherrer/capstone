# Load Packages ---------
library(ggplot2)
library(dplyr)

# Load Data ----
load("data/df_journal.Rda")

# Analysis and Visualisation -----

## Reference Count -----
df_journal$is.referenced.by.count[order(df_journal$is.referenced.by.count, decreasing = TRUE)]

### Filter Data Frame ------
#Rows with Citation Count 250 or Less
filtered_data <- df_journal[df_journal$is.referenced.by.count <= 250, ]

### Distribution of Reference Counts --------
#### All Articles ----------
png("hist_ref.png", width=800, height=600)
par(mar=c(4, 4, 2, 2))
hist(df_journalarticles$is.referenced.by.count, breaks=50, main="Histogram of Reference Counts",
     xlab="Number of References", ylab="Frequency", col="lightblue")
dev.off()

#### Articles with Reference Counts 250 or Less -----------
png("hist_ref250.png", width=800, height=600)
par(mar=c(4, 4, 2, 2))
hist(filtered_data$is.referenced.by.count, breaks=50, main="Histogram of Reference Counts (250 or less)",
     xlab="Number of References", ylab="Frequency", col="lightblue")
dev.off()

## Timeline ------
  # New Collumn for Year Created
df_journal$year_created <- substr(df_journal$created.date.time, start = 1, stop = 4)

### Citation Count over Time -----
png("scatter_ref_year.png", width=800, height=600)
plot(df_journal$year_created, df_journal$is.referenced.by.count, 
     main="Year created vs. Citation Count", xlab="Year Created", ylab="Citation Count", col="blue")
dev.off()

## Language ------
  # Remove Rows with Language = NA
df_na_lang_rem <- df_journal[!is.na(df_journal$language), ]

### Distribution of Citations by Language -----
png("ref_lang.png", width=800, height=600)
ggplot(df_na_lang_rem, aes(x=language, y=is.referenced.by.count, fill=language)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title="Citations by Language", x="Language", y="Citations")
dev.off()

### Distribution of Langugages over Time --------
journal_count <- df_na_lang_rem %>%
  group_by(year_created, language) %>%
  summarise(count = n(), .groups = 'drop')

png("ref_langu_time.png", width=800, height=600)
ggplot(journal_count, aes(x = as.factor(year_created), y = count, fill = language)) +
  geom_bar(stat = "identity") +
  labs(title = "Spread of Published Languages",
       x = "Year",
       y = "Number of Publications",
       fill = "Language") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Adjust text angle for better legibility
dev.off()

## Publishers ----------
  # Count Number of Papers per Publisher ------
publisher_summary <- df_journal %>%
  group_by(publisher) %>%
  summarise(paper_count = n(), .groups = 'drop') %>%
  arrange(desc(paper_count))  # Arrange in descending order of paper count

  # Find Top 10 Publishers ---------
top_publishers <- publisher_summary %>%
  slice_head(n = 10) %>%
  pull(publisher)  # Get the names of the top 10 publishers

  # Classify All other Publishers as "Others" ----
publisher_summary <- publisher_summary %>%
  mutate(publisher = if_else(publisher %in% top_publishers, publisher, "Others"))

  # Combine Counts for "Others" -------
publisher_summary <- publisher_summary %>%
  group_by(publisher) %>%
  summarise(paper_count = sum(paper_count), .groups = 'drop')

### Article Count of Top 10 Publishers -------
png("hist_publisher.png", width=800, height=600)
ggplot(publisher_summary, aes(x = publisher, y = paper_count, fill = publisher)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Number of Papers per Publisher",
       x = "Publisher",
       y = "Number of Papers") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate the x-axis labels for better readability
dev.off()
