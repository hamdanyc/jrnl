# eb_proc.R

# Init ----
library(pdftools)
library(ruimtehol)
library(dplyr)
library(readr)
library(caret)
set.seed(123456789)

# load("jurnal.RData")
# source("func_clean.R")
source("func_tag.R")

# Get training data ----
source("eb_class.R")
files <- list.files(path = "jrnl",pattern = "pdf$", full.names = TRUE)
text <- sapply(files, pdf_text, USE.NAMES = FALSE)
# df <- lapply(text, function(x) paste(x, collapse = "\n"))
# df <- data.frame("text" = Reduce(rbind, df),
#                 fix.empty.names = FALSE)
# df$text <- clean_string(df$text)

df_jrnl <- tibble("text" = text, class)

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
                        early_stopping = 0.8, validationPatience = 10,
                        dim = 50,
                        lr = 0.01, epoch = 40, loss = "softmax", adagrad = TRUE,
                        similarity = "cosine", negSearchLimit = 50,
                        ngrams = 2, minCount = 2, bucket = 100000,
                        maxTrainTime = 2 * 60)
# model <- embed_tagspace(x = train$text, y = train$classification)

# plot ----
plot(model)
pred <- lapply(test$text, function(x) tag_fun(x))
predict(model, "Both conventional methods of breeding and can be used as a reference in case of trade\n", k = 3)
pred <- tibble("classification"=Reduce(rbind, pred),
                   fix.empty.names = FALSE)
# convert to factor
test$classification <- as.factor(test$classification)
pred$classification <- as.factor(pred$classification)

caret::confusionMatrix(pred$classification,test$classification)

# Save trained model ---- 
# as a binary file or as TSV so that you can inspect the embeddings e.g. with data.table::fread("textembed.tsv")
starspace_save_model(model, file = "myapp/jrnl.ruimtehol", method = "ruimtehol")
starspace_save_model(motextdel, file = "jrnl.tsv", method = "tsv-data.table")
save.image("myapp/grade.RData")
save.image("jurnal.RData")

# Load a pre-trained model ----
# or pre-trained embeddings
# model <- starspace_load_model("jrnl.ruimtehol",      method = "ruimtehol")
# model <- starspace_load_model("jrnl.tsv", method = "tsv-data.table", trainMode = 5)
