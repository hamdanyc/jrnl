# proc_corpus

# Init ----
library(readtext)

# read files ----
path <- paste0(getwd(),"/txt")
files <- list.files(path=path, pattern="*", full.names=TRUE)

# write corpus ----
data <- readtext(paste0(path, "*"))

# Building test data ----
# vector space model
# clean-up
clean.text <- function(x, lowercase=TRUE, numbers=TRUE, punctuation=TRUE, spaces=TRUE)
{
  # x: character string
  
  # lower case
  if (lowercase)
    x = tolower(x)
  # remove numbers
  if (numbers)
    x = gsub("[[:digit:]]", "", x)
  # remove punctuation symbols
  if (punctuation)
    x = gsub("[[:punct:]]", "", x)
  # remove extra white spaces
  if (spaces) {
    x = gsub("[ \t]{2,}", " ", x)
    x = gsub("^\\s+|\\s+$", "", x)
  }
  # return
  x
}

# txt <- clean_string(artikel)
txt <- clean.text(data$text, numbers = FALSE)
readr::write_lines(data$text, "artikel.txt")
source("mediaVector.R")
