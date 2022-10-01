# eb_scholar.R

# Init ----
library(scholar)
library(dplyr)
library(textstem)
library(tidytext)
library(stringr)
library(RCurl)
library(httr)
data(stop_words)

load("jrnl.RData")

# Get GS id ----
# page <- read_html(gs$url[1])
# text <- html_nodes(page, ".gs_rt2")
# gs_id <- strsplit(as.character(text),"(user=)|&")[[1]][2]
gs_pdf <- grep("pdf",gs$url,value = TRUE)

# clean text ----
clean_string <- Vectorize(function(string){
  # Lowercase
  temp <- tolower(string)
  # Remove puncuation
  temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ")
  # Shrink down to just one white space
  temp <- stringr::str_replace_all(temp,"[\\s]+", " ")
  # Remove stop words
  temp <- unlist(strsplit(temp, " "))
  temp <- temp[!temp %in% stop_words$word]
  temp <- paste(temp, collapse = " ")
  # Stem words
  temp <- textstem::stem_strings(temp)
  ## Remove any whitespace at beginning or end of line
  temp <- stringr::str_trim(temp)
  
  return(temp)
})

valid_url <- function(url_in,t=2){
  con <- url(url_in)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=t),silent=T)[1])
  suppressWarnings(try(close.connection(con),silent=T))
  ifelse(is.null(check),TRUE,FALSE)
}

# get the file ----
# try(url.exists(gs_pdf))

stringr::str_detect(gs_pdf,"/")
mx <- str_locate_all(gs_pdf, "/")
mpdf <- str_locate_all(gs_pdf, "pdf")
gs_pdf[stringr::str_detect(gs_pdf, "//")]
ml <- as.character(lapply(mx,last))
mlpdf <- as.character(lapply(mpdf,last))
fn <- substr(gs_pdf,as.integer(ml)+1,mlpdf)

download.file(gs$url[21:48], paste0("jrnl/",fn[21:48]))

# Save data ----
save.image("jrnl.RData")
