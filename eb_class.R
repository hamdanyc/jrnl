# eb_class.R

library(OneR)
library(readr)
library(dplyr)

df_class <- read_csv("gs.csv", col_types = cols(cite = col_integer()))
# df_class$cite[is.na(class$cite)] <- 0
# class$classification <- bin(class$cite,nbins = 7,labels = c("Outstanding", "Excellent", "Good", "Acceptable",
#                                             "Adequate", "Limited", "Fail"))

df_class <- df_class %>% 
  mutate(classification = case_when(cite > 299 ~ "Outstanding",
                                    cite <= 299 & cite > 149 ~ "Excellent",
                                    cite <= 149 & cite > 99 ~ "Good",
                                    cite <= 99 & cite > 69 ~ "Acceptable",
                                    cite <= 69 & cite > 49 ~ "Adequate",
                                    cite <= 49 & cite > 39 ~ "Limited",
                                    cite <= 39 ~ "Fail"))
# class <- data.frame(df_class$classification,stringsAsFactors = FALSE)
class <- read_csv("class.csv")
names(class) <- "classification"
