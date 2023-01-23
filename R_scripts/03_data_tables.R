#### load data summaries ####
source("R_scripts/02_summarize_data.R")

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

