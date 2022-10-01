# eb_class.R

library(OneR)
library(readr)

class <- read_csv("class.csv")

# class <- read_csv("gs.csv", col_types = cols(cite = col_integer()))
# class <- bin(class$cite,nbins = 7,labels = c("Outstanding", "Excellent", "Good", "Acceptable",
#                                            "Adequate", "Limited", "Fail"),
#              na.omit = FALSE)
# class <- data.frame(class)
# names(class) <- "classification"
# class$classification <- recode(class$classification,"NA" = "Good")

