# Load Packages ---------
library(ggplot2)
library(dplyr)

# Load Data ----
load("data/df_journal.Rda")

# Analysis -----

## Reference Count -----
df_journal$is.referenced.by.count[order(df_journal$is.referenced.by.count, decreasing = TRUE)]

### Top 10 Most Referenced Articles ------

# Dataframe has columns named 'title', 'is.referenced.by.count', and 'author'
top_papers <- df_journal %>%
  arrange(desc(is.referenced.by.count)) %>%
  slice_head(n = 10) %>%
  select(title, is.referenced.by.count, author)  # Adjust these column names if needed

# If 'author' is a list, and you want to convert it to a comma-separated string
top_papers$author <- sapply(top_papers$author, function(x) paste(x, collapse = ", "))

print(top_papers)
### Distribution of reference counts --------
png("hist_ref.png", width=800, height=600)
par(mar=c(4, 4, 2, 2))
hist(df_journalarticles$is.referenced.by.count, breaks=50, main="Histogram of Reference Counts",
     xlab="Number of References", ylab="Frequency", col="lightblue")
dev.off()

#### Filter Data Frame ------
#rows where reference counts are 250 or less
filtered_data <- df_journal[df_journal$is.referenced.by.count <= 250, ]

#### Histogramm ----
png("hist_ref250.png", width=800, height=600)
par(mar=c(4, 4, 2, 2))
hist(filtered_data$is.referenced.by.count, breaks=50, main="Histogram of Reference Counts (250 or less)",
     xlab="Number of References", ylab="Frequency", col="lightblue")
dev.off()

## Relation of citations and other variables ---
### Citation year vs. citation count------
# Create a new column with the first four characters of the original_column
df_journal$year_created <- substr(df_journal$created.date.time, start = 1, stop = 4)
View(df_journal$year_created)

# Creating a scatter plot
png("scatter_ref_year.png", width=800, height=600)
plot(df_journal$year_created, df_journal$is.referenced.by.count, 
     main="Year created vs. Citation Count", xlab="Year Created", ylab="Citation Count", col="blue")
dev.off()

### Language and Citations ------
print(df_journal$language)

#boxplot
df_na_lang_rem <- df_journal[!is.na(df_journal$language), ]  # Remove rows with NA values in the language column
png("ref_lang.png", width=800, height=600)
ggplot(df_na_lang_rem, aes(x=language, y=is.referenced.by.count, fill=language)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title="Citations by Language", x="Language", y="Citations")
dev.off()

# stacked bar plot showing distribution of langugages over time

# Assuming you have a 'year' and 'language' column in your df_na_lang_rem
# Filter data for the last ten years
journal_count <- df_na_lang_rem %>%
  group_by(year_created, language) %>%
  summarise(count = n(), .groups = 'drop')  # Count the number of papers per language per year

png("ref_lang_time.png", width=800, height=600)
ggplot(journal_count, aes(x = as.factor(year_created), y = count, fill = language)) +
  geom_bar(stat = "identity") +
  labs(title = "Spread of Published Languages Over the Last Ten Years",
       x = "Year",
       y = "Number of Publications",
       fill = "Language") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Adjust text angle for better legibility
dev.off()

### publishers
# Summarize data to count the number of papers per publisher
publisher_summary <- df_journal %>%
  group_by(publisher) %>%
  summarise(paper_count = n(), .groups = 'drop') %>%
  arrange(desc(paper_count))  # Arrange in descending order of paper count

# Identify the top 10 publishers
top_publishers <- publisher_summary %>%
  slice_head(n = 10) %>%
  pull(publisher)  # Get the names of the top 10 publishers

# Reclassify all other publishers as "Others"
publisher_summary <- publisher_summary %>%
  mutate(publisher = if_else(publisher %in% top_publishers, publisher, "Others"))

# Combine the counts for "Others"
publisher_summary <- publisher_summary %>%
  group_by(publisher) %>%
  summarise(paper_count = sum(paper_count), .groups = 'drop')

# Create a bar plot
png("hist_publisher.png", width=800, height=600)
ggplot(publisher_summary, aes(x = publisher, y = paper_count, fill = publisher)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Number of Papers per Publisher",
       x = "Publisher",
       y = "Number of Papers") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate the x-axis labels for better readability
dev.off()
