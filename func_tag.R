# func_tag.R

tag_fun <- function(df){
  tag <- predict(model, df, k = 3)
  tag[[1]]$prediction[1]$label[1]
}