# eb_proc.R
# not use because token is a word
# embed_tagspace req string of text

# Init ----
library(pdftools)
library(ruimtehol)
library(dplyr)
library(readr)
library(caret)
library(readtext)
library(textreg)
library(tm)
set.seed(123456789)

load("jurnal.RData")
source("func_clean.R")
source("func_tag.R")

# Get training data ----
source("eb_class.R")
# files <- list.files(path = "jrnl",pattern = "pdf$", full.names = TRUE)
# jrnl <- sapply(files, pdf_text, USE.NAMES = FALSE)
# jrnl_df <- lapply(jrnl, function(x) paste(x, collapse = "\n"))
# df <- data.frame("text" = Reduce(rbind, jrnl_df),
#                  fix.empty.names = FALSE)

# Building test data (model) ----
# read in model as read.vectors("vector.bin")
prep.txt.corp <- textreg::clean.text(VCorpus(VectorSource(df$text)))
df$text <- quanteda::corpus(prep.txt.corp)

df_jrnl <- data.frame("text" = df$text, "classification" = class,
                      stringsAsFactors = FALSE)

# class_tb <- read_csv("class_tb.csv")
# df_jrnl$classification <- class$classification

# Partition sample ----
set.seed(123456789)
index <- createDataPartition(
  y = df_jrnl$classification,
  times = 1,
  p = 0.8,
  list = TRUE)

train <- df_jrnl[index$Resample1,]
test  <- df_jrnl[-index$Resample1,]

# Predict / verify model ----
model <- embed_tagspace(x = train$text, y = train$classification,
                        dim = 60,
                        lr = 0.01, epoch = 20, loss = "softmax", adagrad = TRUE, 
                        similarity = "cosine", negSearchLimit = 3,
                        ngrams = 2, minCount = 2)

# plot ----
plot(model)
# pred <- lapply(test$text, function(x) tag_fun(x))
pred <- predict(model, test$text, k = 3)
pred <- data.frame("classification"=Reduce(rbind, pred),
                   fix.empty.names = FALSE)
# tb <- table(test$classification,pred$classification)
# sum(tb[2,2],tb[3,3])/nrow(test)*100
caret::confusionMatrix(pred$classification,test$classification)

# Save trained model ---- 
# as a binary file or as TSV so that you can inspect the embeddings e.g. with data.table::fread("textembed.tsv")
starspace_save_model(model, file = "myapp/jrnl.ruimtehol", method = "ruimtehol")
starspace_save_model(model, file = "jrnl.tsv", method = "tsv-data.table")
save.image("myapp/grade.RData")
save.image("jurnal.RData")

# Load a pre-trained model ----
# or pre-trained embeddings
# model <- starspace_load_model("jrnl.ruimtehol",      method = "ruimtehol")
# model <- starspace_load_model("jrnl.tsv", method = "tsv-data.table", trainMode = 5)


