library(dplyr)

#### load data ####
resilience_data <- read.csv("data/marsh_metrics.csv")
source("R_scripts/marsh_functions.R")

#specify HUCs that are in "new" CT reserve
CT_HUC <- c(10802050905, 11000030203, 11000030303,  11000030305, 11000030306, 11000040207)
resilience_data[which(resilience_data$HUC12 %in% CT_HUC), ]$HUC_RESERVE <- "CCT, CT"

#resilience_raw_22 is data downloaded directly from NOAA's Digital Coast website
metrics <- c("Core_Edge_ratio", "Perc_IC", "Perc_Natural" , "Perc_Ag" , 
             "Erodibility_Factor", "MEAN_Marsh_Tidal_Range","Perc_Hardened_Shoreline", 
             "Shoreline_Sinuosity", "Wetland_Connectedness", "Pct_MUC_below_MHHW", 
             "Pct_MUC_below_MTL", "UnvegVegEdge_ratio", "AVG_migration_ratio")

#### calculate ntiles from the data for each metric ####
#extract just the raw data resilience metrics columns from the original dataset
metrics_data <- resilience_data[7:19]

#calculate percentiles for each metric 
p <- seq(from = .1, to = 1, by = 0.1)

percentiles <- percentile_calc(data = metrics_data, p = p)

#create deciles and store in the empty dataframe
#please note that this is a very computationally challenging way to complete these calculations, but it will match the python code provided. 
#if users aren't concerned with code matching python, another way to calculate percentiles is included in a separate file
metrics_ntiles <- percentile_rank(metrics_data, percentiles)

#change negative factors to negative values
metrics_ntiles[,c(2,4,5,7,10,11,12)] <- metrics_ntiles[,c(2,4,5,7,10,11,12)]*-1

#### Sum the quantiles for each category and recalculate quantiles by category ####
#create an empty dataframe
ntile_summary <- data.frame(matrix(nrow = nrow(metrics_data),
                                   ncol = 4))

colnames(ntile_summary) <- c("QuantileScoreSum", 
                             "CurrentConditionSum",
                             "VulnerabilitySum",
                             "AdaptiveCapacitySum")

#create a new data frame with weighted quantiles for perc hardened shoreline and avg migration ratio 
metrics_Wntiles <- metrics_ntiles
metrics_Wntiles$Perc_Hardened_Shoreline_Quantile <- metrics_Wntiles$Perc_Hardened_Shoreline_Quantile*1.5
metrics_Wntiles$AVG_migration_ratio_Quantile <- metrics_Wntiles$AVG_migration_ratio_Quantile*2

#add total quantile sums to first column
ntile_summary$QuantileScoreSum <- round(rowSums(metrics_Wntiles[ ,1:13]),0)

#add sums for each resilience category in the next three columns
ntile_summary$CurrentConditionSum <- rowSums(select(metrics_Wntiles, 
                                                    c('Core_Edge_ratio_Quantile',
                                                      'Perc_IC_Quantile',
                                                      'Perc_Natural_Quantile',
                                                      'Perc_Ag_Quantile',
                                                      'UnvegVegEdge_ratio_Quantile')))
ntile_summary$VulnerabilitySum <- rowSums(select(metrics_Wntiles, 
                                                 c('Erodibility_Factor_Quantile',
                                                   'MEAN_Marsh_Tidal_Range_Quantile',
                                                   'Pct_MUC_below_MHHW_Quantile',
                                                   'Pct_MUC_below_MTL_Quantile')))

ntile_summary$AdaptiveCapacitySum <- round(rowSums(select(metrics_Wntiles, 
                                                          c('Perc_Hardened_Shoreline_Quantile',
                                                            'Shoreline_Sinuosity_Quantile',
                                                            'AVG_migration_ratio_Quantile',
                                                            'Wetland_Connectedness_Quantile'))), 0)

#create new quantiles from the category sums
category_sums <- ntile_summary[,c("QuantileScoreSum",
                                  "CurrentConditionSum",
                                  "AdaptiveCapacitySum")]

category_sums_p <- percentile_calc(category_sums, p)
category_ntiles <- percentile_rank(category_sums, category_sums_p)

#vulnerability
vul <- as.data.frame(ntile_summary$VulnerabilitySum)
vulnerability_sums_p <- percentile_calc(vul, p)
vulnerability_ntiles <- neg_percentile_rank(vul, vulnerability_sums_p)*-1
vulnerability_ntiles_df <- as.data.frame(vulnerability_ntiles)
colnames(vulnerability_ntiles_df) <-"VulnerabilitySum_Quantile"


#make a new dataframe with relevant identification, quantiles, and summary stats
resilience_df <-cbind(resilience_data, metrics_ntiles, ntile_summary, category_ntiles[2], vulnerability_ntiles_df, category_ntiles[,c(3,1)]) 

#### add management scores ####
ConditionCategory <- ifelse(resilience_df$CurrentConditionSum_Quantile >= 6, "High", "Low")
VulnerabilityCategory <- ifelse(resilience_df$VulnerabilitySum_Quantile <= -6, "High", "Low")
AdaptiveCapacityCategory <- ifelse(resilience_df$AdaptiveCapacitySum_Quantile >= 6, "High", "Low")
ManagementCategory <- paste(ConditionCategory, VulnerabilityCategory, AdaptiveCapacityCategory, sep = "-")

resilience_df$ConditionCategory <- ConditionCategory
resilience_df$VulnerabilityCategory <- VulnerabilityCategory
resilience_df$AdaptiveCapacityCategory <- AdaptiveCapacityCategory
resilience_df$ManagementCategory <- ManagementCategory

#### write to csv ####
#write.csv(resilience_df, "outputs/resilience_df.csv")


