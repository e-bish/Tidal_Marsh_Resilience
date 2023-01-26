#Written by Emily Bishop
#Last updated January 25, 2023

#### load packages ####
library(dplyr)
library(tidyr)
library(stringr)

#### load functions ####
source("R_scripts/marsh_functions.R")

#### load data ####
resilience_df <- read.csv("outputs/resilience_df.csv")

#resilience_df is created in 01_calculate_ntiles.R
metrics <- c("Core_Edge_ratio", "Perc_IC", "Perc_Natural" , "Perc_Ag" , 
             "Erodibility_Factor", "MEAN_Marsh_Tidal_Range","Perc_Hardened_Shoreline", 
             "Shoreline_Sinuosity", "Wetland_Connectedness", "Pct_MUC_below_MHHW", 
             "Pct_MUC_below_MTL", "UnvegVegEdge_ratio", "AVG_migration_ratio")

#summary metric names
summary_metrics <- c(metrics,"Current_Condition", "Vulnerability", "Adaptive_Capacity", "Total_Resilience")

resilience_ntiles <- resilience_df[,c(24:36, 41:44)]

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
                      by = list(resilience_df$HUC_Region),
                      FUN = mean)

reg_mean$min_col = colnames(reg_mean[2:14])[apply(reg_mean[2:14], 1, which.min)]
reg_mean$max_col = colnames(reg_mean[2:14])[apply(reg_mean[2:14], 1, which.max)]

reg_mean_sd<- aggregate(x = resilience_df[c(24:36, 41:44)],
                        by = list(resilience_df$HUC_Region),
                        FUN = meansd)

names(reg_mean_sd) <- c("Region", summary_metrics)
reg_mean[,1:18] <- reg_mean_sd

reg_sum <- reg_mean[c(1, 15:20)]

#### calculate state means ####
state_mean<- aggregate(x = resilience_ntiles,
                       by = list(resilience_df$HUC_STATE_NAME),
                       FUN = mean)

state_mean$min_col = colnames(state_mean[2:14])[apply(state_mean[2:14], 1, which.min)]
state_mean$max_col = colnames(state_mean[2:14])[apply(state_mean[2:14], 1, which.max)]

state_mean_sd<- aggregate(x = resilience_ntiles,
                          by = list(resilience_df$HUC_STATE_NAME),
                          FUN = meansd)

names(state_mean_sd) <- c("Region", summary_metrics)
state_mean[,1:18] <- state_mean_sd

state_sum <- state_mean[c(1, 15:20)]

#### reserve means ####        
reserve_mean1<- aggregate(x = resilience_ntiles,
                          by = list(resilience_df$HUC_RESERVE),
                          FUN = mean)

reserve_mean1$min_col = colnames(reserve_mean1[2:14])[apply(reserve_mean1[2:14], 1, which.min)]
reserve_mean1$max_col = colnames(reserve_mean1[2:14])[apply(reserve_mean1[2:14], 1, which.max)]

reserve_mean_sd<- aggregate(x = resilience_ntiles,
                            by = list(resilience_df$HUC_RESERVE),
                            FUN = meansd)

names(reserve_mean_sd) <- c("Reserve", summary_metrics)
reserve_mean <- reserve_mean_sd
reserve_mean <- cbind(reserve_mean, reserve_mean1[19:20])
reserve_mean[c(8, 22, 26),] <- reserve_mean1[c(8, 22, 26),] #add in values for reserves with only one HUC

#view an abbreviated version with just summary metrics
reserve_sum <- reserve_mean[c(1, 15:20)]
#just note that the cells with (sd) are character values so when you sort the 10th decile will appear next to the 1st decile

##### Highest priority marshes for conservation ####
length(which(resilience_df$ManagementCategory == "High-Low-High",))/1984 #22 % high priority for conservation
length(which(resilience_df$ManagementCategory == "Low-High-Low",))/1984 #17.5% too far gone to save

#### Gulf Islands National Seashore example ####
GINS <- resilience_df %>% 
  dplyr::filter(HUC12 %in% c(31700090807,31700090806,31700090805,31700090703,31700090304, 
                             31401070204,31401050202,31401050205)) %>% 
  mutate(marsh_letter = c("H", "F", "G", "E", "D", "C", "B", "A")) 

GINS_avg <- purrr::map(GINS[,c(24:36, 41:44)], meansd) %>% as.data.frame.list()

GINS_state<- aggregate(x = GINS[c(24:36, 41:44)],
                       by = list(GINS$HUC_STATE_NAME),
                       FUN = meansd)
sum(GINS$Acres)
