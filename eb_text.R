# eb_text.R

# Init ----
library(ruimtehol)
set.seed(123456789)

# Get some training data ----
x <- readLines("artikel.txt", encoding = "UTF-8")
x <- x[-c(1:9)]
x <- x[sample(x = length(x), size = 1000)]
writeLines(text = x, sep = "\n", con = "artikel_train.txt")

# Train ----
set.seed(123456789)
model <- starspace(file = "artikel_train.txt", fileFormat = "fastText", dim = 10, trainMode = 5)
embedding <- as.matrix(model)
embedding[c("school", "house"), ]
dictionary <- starspace_dictionary(model)

# Save trained model ---- 
# as a binary file or as TSV so that you can inspect the embeddings e.g. with data.table::fread("textembed.tsv")
starspace_save_model(model, file = "textspace.ruimtehol", method = "ruimtehol")
starspace_save_model(model, file = "textembed.tsv", method = "tsv-data.table")

# Load a pre-trained model ----
# or pre-trained embeddings
model <- starspace_load_model("textspace.ruimtehol", method = "ruimtehol")
model <- starspace_load_model("textembed.tsv", method = "tsv-data.table", trainMode = 5)

# What is closest term from the dictionary ----
starspace_knn(model, "peningkatan kadar jenayah", k = 10)
predict(model, newdata = "kadar jenayah ekonomi",
        basedoc = c("jumlah pengangguran tertinggi","bunuh diri","kesan mental"))

