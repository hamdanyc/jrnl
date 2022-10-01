# func_clean.R
library(tidytext)
data(stop_words)

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
