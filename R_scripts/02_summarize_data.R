#### load libraries ####
library(dplyr)
library(tidyr)
library(stringr)
library(janitor)
library(gt)

#library(xlsx)
# library(ggplot2)
# library(ggrepel) #label plots
# library(patchwork)



#### functions ####
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


#### load data ####
resilience_data <- read.csv("Final/resilience_df.csv")

#resilience_df is created in 01_calculate_ntiles.R
metrics <- c("Core_Edge_ratio", "Perc_IC", "Perc_Natural" , "Perc_Ag" , 
             "Erodibility_Factor", "MEAN_Marsh_Tidal_Range","Perc_Hardened_Shoreline", 
             "Shoreline_Sinuosity", "Wetland_Connectedness", "Pct_MUC_below_MHHW", 
             "Pct_MUC_below_MTL", "UnvegVegEdge_ratio", "AVG_migration_ratio")

#summary metric names
summary_metrics <- c(metrics,"Current_Condition", "Vulnerability", "Adaptive_Capacity", "Total_Resilience")

resilience_ntiles <- resilience_data[,c(24:36, 41:44)]


#### calculate national means ####
#wide form
nat_mean <- as.data.frame.list(colMeans(resilience_ntiles))
names(nat_mean) <- summary_metrics

nat_mean$min_col = colnames(nat_mean[1:13])[apply(nat_mean[1:13], 1, which.min)]
nat_mean$max_col = colnames(nat_mean[1:13])[apply(nat_mean[1:13], 1, which.max)]

#### calculate regional means ####
#wide format
#just the means
reg_mean <- aggregate(x = resilience_ntiles,
                      by = list(resilience_data$HUC_Region),
                      FUN = mean)

reg_mean$min_col = colnames(reg_mean[2:14])[apply(reg_mean[2:14], 1, which.min)]
reg_mean$max_col = colnames(reg_mean[2:14])[apply(reg_mean[2:14], 1, which.max)]

reg_mean_sd<- aggregate(x = resilience_data[c(24:36, 41:44)],
                        by = list(resilience_data$HUC_Region),
                        FUN = meansd)

names(reg_mean_sd) <- c("Region", summary_metrics)
reg_mean[,1:18] <- reg_mean_sd

reg_sum <- reg_mean[c(1, 15:20)]

#### calculate state means ####
state_mean<- aggregate(x = resilience_ntiles,
                       by = list(resilience_data$HUC_STATE_NAME),
                       FUN = mean)

state_mean$min_col = colnames(state_mean[2:14])[apply(state_mean[2:14], 1, which.min)]
state_mean$max_col = colnames(state_mean[2:14])[apply(state_mean[2:14], 1, which.max)]

state_mean_sd<- aggregate(x = resilience_ntiles,
                          by = list(resilience_data$HUC_STATE_NAME),
                          FUN = meansd)

names(state_mean_sd) <- c("Region", summary_metrics)
state_mean[,1:18] <- state_mean_sd

state_sum <- state_mean[c(1, 15:20)]

#### reserve means ####        #### need to filter for just reserves!
reserve_mean1<- aggregate(x = resilience_ntiles,
                          by = list(resilience_data$HUC_RESERVE),
                          FUN = mean)

reserve_mean1$min_col = colnames(reserve_mean1[2:14])[apply(reserve_mean1[2:14], 1, which.min)]
reserve_mean1$max_col = colnames(reserve_mean1[2:14])[apply(reserve_mean1[2:14], 1, which.max)]

reserve_mean_sd<- aggregate(x = resilience_ntiles,
                            by = list(resilience_data$HUC_RESERVE),
                            FUN = meansd)

names(reserve_mean_sd) <- c("Reserve", summary_metrics)
reserve_mean <- reserve_mean_sd
reserve_mean <- cbind(reserve_mean, reserve_mean1[19:20])
reserve_mean[c(7, 21, 25),] <- reserve_mean1[c(7, 21, 25),] #add in values for reserves with only one HUC

#view an abbreviated version with just summary metrics
reserve_sum <- reserve_mean[c(1, 15:20)]
#just note that the cells with (sd) are character values so when you sort the 10th decile will appear next to the 1st decile

##### Highest priority marshes for conservation ####
length(which(resilience_data$ManagementCategory == "High-Low-High",))/1984 #22 % high priority for conservation
length(which(resilience_data$ManagementCategory == "Low-High-Low",))/1984 #17.5% too far gone to save

#### Table 2 ####
#calculate frequency for each  management category recommended nationally
nat_mgmt <- resilience_data %>% 
  group_by(ManagementCategory) %>% 
  summarize(n = n())

#split the main dataframe by region
mgmt_reg_list <- resilience_data %>% 
  group_split(HUC_Region)

#create an empty matrix to store frequency data for each region
reg_mgmt <- matrix(nrow = 8, ncol = 5)

#calculate frequency data for each region, store in the matrix
for (i in 1:5) {
  reg_mgmt[,i] <- mgmt_reg_list[[i]] %>% 
    group_by(ManagementCategory) %>% 
    summarize(n = n()) %>% 
    pull(n)
}

#add column names to the matrix
reg_mgmt <- reg_mgmt %>% `colnames<-`(c("Gulf of Mexico", "Mid-Atlantic", "Northeast", "Southeast", "West Coast"))

#create row names
mgmt_labs <- resilience_data %>% 
  distinct(ManagementCategory) %>% 
  arrange(ManagementCategory)   

#combine row names, and regional and national frequencies into one table
reg_mgmt <- bind_cols(mgmt_labs, reg_mgmt, National = nat_mgmt$n) %>% 
  adorn_totals("row") 

