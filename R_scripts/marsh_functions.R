
#function to calculate percentiles based on raw data
percentile_calc <- function(data, p) {
  empty_matrix <- matrix(nrow = length(p), ncol = ncol(data))
  colnames(empty_matrix) <- colnames(data)
  for (i in 1:nrow(empty_matrix)) {
    for (j in 1:ncol(empty_matrix)) {
      empty_matrix[i,j] = quantile(data[,j], p[i]) 
    }
  }
  empty_matrix <- as.data.frame(empty_matrix)
  return(empty_matrix)
}


#function to create a dataframe that gives percentile rank 
percentile_rank <- function(data, percentiles) {
  metric_ranks <- matrix(nrow = nrow(data), ncol = ncol(data))
  colnames(metric_ranks) <- paste(colnames(data), "Quantile", sep = "_")
  for (i in 1:nrow(data)) {
    for (j in 1:ncol(data)) {
      metric_ranks[i,j] <- ifelse(data[i,j] <= percentiles[1,j], 1,
                            ifelse(data[i,j] >= percentiles[1,j] & data[i,j] < percentiles[2,j], 2,
                            ifelse(data[i,j] >= percentiles[2,j] & data[i,j] < percentiles[3,j], 3,
                            ifelse(data[i,j] >= percentiles[3,j] & data[i,j] < percentiles[4,j], 4,
                            ifelse(data[i,j] >= percentiles[4,j] & data[i,j] < percentiles[5,j], 5,
                            ifelse(data[i,j] >= percentiles[5,j] & data[i,j] < percentiles[6,j], 6,
                            ifelse(data[i,j] >= percentiles[6,j] & data[i,j] < percentiles[7,j], 7, 
                            ifelse(data[i,j] >= percentiles[7,j] & data[i,j] < percentiles[8,j], 8,
                            ifelse(data[i,j] >= percentiles[8,j] & data[i,j] < percentiles[9,j], 9, 
                            10)))))))))
    }
  }
  metric_ranks <- as.data.frame(metric_ranks)
  return(metric_ranks)
}

#another percentile rank function, but this one is for vulnerability because this category is represented
#as negative so the interpretation of the ranks is reversed
neg_percentile_rank <- function(data, percentiles) {
  metric_ranks <- c()
  for (i in 1:nrow(data)) {
    for (j in 1:ncol(data)) {
      metric_ranks[i] <- ifelse(data[i,j] <= percentiles[1,j], 10,
                           ifelse(data[i,j] >= percentiles[1,j] & data[i,j] < percentiles[2,j], 9,
                           ifelse(data[i,j] >= percentiles[2,j] & data[i,j] < percentiles[3,j], 8,
                           ifelse(data[i,j] >= percentiles[3,j] & data[i,j] < percentiles[4,j], 7,
                           ifelse(data[i,j] >= percentiles[4,j] & data[i,j] < percentiles[5,j], 6,
                           ifelse(data[i,j] >= percentiles[5,j] & data[i,j] < percentiles[6,j], 5,
                           ifelse(data[i,j] >= percentiles[6,j] & data[i,j] < percentiles[7,j], 4, 
                           ifelse(data[i,j] >= percentiles[7,j] & data[i,j] < percentiles[8,j], 3,
                           ifelse(data[i,j] >= percentiles[8,j] & data[i,j] < percentiles[9,j], 2, 
                          1)))))))))
    }
  }
  return(metric_ranks)
}

# return mean with standard deviation in parenthesis 
meansd <- function(x, ...){
  mean1 <-   signif(round(mean(x, na.rm=T),3), 3)   #calculate mean and round
  sd1 <- signif(round(sd(x, na.rm=T), 3),3) # std deviation - round adding zeros
  psd <- paste("(", sd1, ")", sep="") #remove spaces
  out <- paste(mean1, psd)  # paste together mean  standard deviation
  if (str_detect(out,"NA")) {out="NA"}   # if missing do not add sd
  return(out)
}
## function code from https://github.com/another-smith/meanSE/blob/main/mean%20and%20se%20table10-12with%20functions.Rmd
