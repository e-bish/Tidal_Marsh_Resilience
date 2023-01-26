#Written by Emily Bishop
#Last updated January 26, 2023

#### load packages ####
library(tidyverse)
library(janitor)
library(gt)

#### load data summaries ####
source("R_scripts/02_summarize_data.R")
summary_metrics <- gsub("_", " ", summary_metrics)

#### Table 2 ####
#calculate frequency for each  management category recommended nationally
nat_mgmt <- resilience_df %>% 
  group_by(ManagementCategory) %>% 
  summarize(n = n())

#split the main dataframe by region
mgmt_reg_list <- resilience_df %>% 
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
mgmt_labs <- resilience_df %>% 
  distinct(ManagementCategory) %>% 
  arrange(ManagementCategory) #matches order from the nat and reg summaries

#combine row names, and regional and national frequencies into one table
mgmt_table <- bind_cols(mgmt_labs, reg_mgmt, Total = nat_mgmt$n) %>% 
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
  opt_table_font(font = "Calibri") %>% 
  tab_options(
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
                           rows = 9)); mgmt_table 

#gtsave(mgmt_table, "outputs/mgmt_table.png", expand = 10)

#### S2 National Summary ####
nat_mean_2 <- as.data.frame(apply(resilience_ntiles, 2, meansd))
names(nat_mean_2) <- "Avg_Resilience_Score"
nat_mean_2$Metrics <- summary_metrics

national_table <- nat_mean_2 %>% 
  gt(rowname_col = "Metrics") %>% 
  cols_label(Avg_Resilience_Score = "Average Resilience Score") %>% 
  cols_align(
    align = "center",
    columns = "Avg_Resilience_Score") %>% 
  opt_table_font(font = "Calibri") %>% 
  tab_options(
    table.font.color = "black",
    table.border.top.style = "none",
    table.border.bottom.style = "solid",
    table.border.bottom.color = "black",
    table.border.bottom.width = px(3),
    column_labels.border.bottom.color = "black",
    column_labels.border.bottom.width = px(3),
    data_row.padding = px(10)) %>% 
  opt_row_striping() %>% 
  tab_row_group(label = "Total", 
                rows = 17) %>% 
  tab_row_group(label = "Metric Categories", 
                rows = c(14:16)) %>% 
    tab_row_group(label = "Metrics", 
                  rows = c(1:13)) ; national_table

#gtsave(national_table, "outputs/national_table.png", expand = 10)

#### S2 Regional Summary ####
S1_reg_sum <- t(reg_mean_sd) %>% 
  row_to_names(row_number = 1) %>% 
  as.data.frame() %>% 
  mutate(Metrics = summary_metrics)

regional_table <- S1_reg_sum %>% 
  gt(rowname_col = "Metrics") %>% 
  cols_align(
    align = "center",
    columns = !Metrics) %>%
  opt_table_font(font = "Calibri") %>% 
  tab_options(
    table.font.color = "black",
    table.border.top.style = "none",
    table.border.bottom.style = "solid",
    table.border.bottom.color = "black",
    table.border.bottom.width = px(3),
    column_labels.border.bottom.color = "black",
    column_labels.border.bottom.width = px(3),
    data_row.padding = px(10)) %>% 
  opt_row_striping() %>% 
  tab_row_group(label = "Total", 
                rows = 17) %>% 
  tab_row_group(label = "Metric Categories", 
                rows = c(14:16)) %>% 
  tab_row_group(label = "Metrics", 
                rows = c(1:13)) ; regional_table

#gtsave(regional_table, "outputs/regional_table.png", expand = 10)

#### S2 State Summary ####
#recalculate mean.sd using state abbreviations
state_mean_ab<- aggregate(x = resilience_ntiles,
                       by = list(resilience_df$HUC_STATE_ABBR),
                       FUN = meansd)
names(state_mean_ab) <- c("State", summary_metrics)

S1_state_sum <- t(state_mean_ab) %>% 
  row_to_names(row_number = 1) %>% 
  as.data.frame() %>% 
  mutate(Metrics = summary_metrics)

state_table <- S1_state_sum %>% 
  gt(rowname_col = "Metrics") %>% 
  cols_align(
    align = "center",
    columns = !Metrics) %>%
  opt_table_font(font = "Calibri") %>% 
  tab_options(
    table.font.color = "black",
    table.border.top.style = "none",
    table.border.bottom.style = "solid",
    table.border.bottom.color = "black",
    table.border.bottom.width = px(3),
    column_labels.border.bottom.color = "black",
    column_labels.border.bottom.width = px(3),
    data_row.padding = px(10)) %>% 
  opt_row_striping() %>% 
  tab_row_group(label = "Total", 
                rows = 17) %>% 
  tab_row_group(label = "Metric Categories", 
                rows = c(14:16)) %>% 
  tab_row_group(label = "Metrics", 
                rows = c(1:13)); state_table

gtsave(state_table, "outputs/state_table.png", expand = 10)

#### S2 Reserve Summary ####
S1_reserve_sum <- t(reserve_mean[1:18]) %>% 
  row_to_names(row_number = 1) %>% 
  as.data.frame() %>% 
  mutate(Metrics = summary_metrics)

reserve_table <- S1_reserve_sum %>% 
  gt(rowname_col = "Metrics") %>% 
  cols_align(
    align = "center",
    columns = !Metrics) %>%
  opt_table_font(font = "Calibri") %>% 
  tab_options(
    table.font.color = "black",
    table.border.top.style = "none",
    table.border.bottom.style = "solid",
    table.border.bottom.color = "black",
    table.border.bottom.width = px(3),
    column_labels.border.bottom.color = "black",
    column_labels.border.bottom.width = px(3),
    data_row.padding = px(10)) %>% 
  opt_row_striping() %>% 
  tab_row_group(label = "Total", 
                rows = 17) %>% 
  tab_row_group(label = "Metric Categories", 
                rows = c(14:16)) %>% 
  tab_row_group(label = "Metrics", 
                rows = c(1:13)) ; reserve_table

#gtsave(reserve_table, "outputs/reserve_table.png", expand = 10, vwidth = 2000, vheight = 1000)
