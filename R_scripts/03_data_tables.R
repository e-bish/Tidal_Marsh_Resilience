#Written by Emily Bishop
#Last updated January 25, 2023

#### load packages ####
library(janitor)
library(gt)

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
reg_mgmt <- reg_mgmt %>% as.data.frame() %>% rename("Gulf of Mexico" = 1, "Mid-Atlantic" = 2, "Northeast" = 3, "Southeast" = 4, "West Coast" = 5)

#create row names
mgmt_labs <- resilience_data %>% 
  distinct(ManagementCategory) %>% 
  arrange(ManagementCategory) #matches order from the nat and reg summaries

#combine row names, and regional and national frequencies into one table
mgmt_sum <- bind_cols(mgmt_labs, reg_mgmt, Total = nat_mgmt$n) %>% 
  mutate(ManagementCategory =  factor(ManagementCategory, 
                                      levels = c("High-Low-High",
                                                 "High-High-High",
                                                 "High-Low-Low",
                                                 "Low-Low-High",
                                                 "High-High-Low",
                                                 "Low-Low-Low",
                                                 "Low-High-High",
                                                 "Low-High-Low"))) %>%
  arrange(ManagementCategory) %>% 
  adorn_totals("row") %>% 
  gt() %>% 
  cols_label(ManagementCategory = "Marsh Resilience Category") %>% 
  tab_spanner(
    label = "Region",
    columns = c(2:6)) %>%
  cols_align(
    align = "center",
    columns = everything()) %>%
  tab_options(
    table.font.name = "Calibri",
    table.font.color = "black",
    table.border.top.style = "none",
    table.border.bottom.style = "solid",
    table.border.bottom.color = "black",
    table.border.bottom.width = px(3),
    column_labels.border.bottom.color = "black",
    column_labels.border.bottom.width = px(3),
    data_row.padding = px(10)) %>%
  opt_row_striping() %>% 
  tab_style(
    style = cell_borders(sides = c("top", "bottom"),
                         color = "black",
                         weight = px(2)),
    locations = cells_body(columns = everything(),
                           rows = 9))

mgmt_sum 

#gtsave(mgmt_sum, "outputs/mgmt_sum.png", expand = 10)
