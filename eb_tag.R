# eb_tag.R

# Init ----
library(ruimtehol)
library(pdftools)
library(dplyr)

source("func_clean.R")
source("func_tag.R")
model <- starspace_load_model("jrnl.ruimtehol", method = "ruimtehol")

# Get new data ----
files <- list.files(path = "jrnl_new",pattern = "pdf$", full.names = TRUE)
jrnl <- sapply(files, pdf_text, USE.NAMES = FALSE)
jrnl_df <- lapply(jrnl, function(x) paste(x, collapse = "\n"))
df <- data.frame("text"=Reduce(rbind, jrnl_df),
                 fix.empty.names = FALSE)
df$text <- clean_string(df$text)
class_tb <- read_csv("class_tb.csv")

# Predict ----
pred <- lapply(df$text, function(x) tag_fun(x))
pred <- data.frame("classification"=Reduce(rbind, pred),
                   fix.empty.names = FALSE)
# Calc score ----
# col-weightage 
ws <- c(0.5,0.5,0.5,0.5,1)
class_tb %>%
  inner_join(pred) %>% 
  transmute(class = classification, content = (ct_min+ct_max)*ws[1], knowledge = (kw_min+kw_max)*ws[2],
            reading = (er_min+er_max)*ws[3], reference = (rf_min+rf_max)*ws[4],
            present = (pr_min+pr_max)*ws[5],
            marks = content + knowledge + reading + reference + present)

  
