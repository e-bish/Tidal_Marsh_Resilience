# Tidal_Marsh_Resilience
A repo to store files related to Stevens et al. (submitted)

## Folder structure
**data** - a .csv file containing raw metric data calculated using methods detailed here [https://www.fisheries.noaa.gov/inport/item/62985]
these data can also be downloaded as a geodatabase here [https://coast.noaa.gov/digitalcoast/data/marshresilience.html]

**excel** - an .xlsx file containing sheets that step through the metric scoring process

**python** - python scripts that step through the metric scoring process 

**R_scripts** - R scripts that step through the metric scoring process and analysis for Stevens et al. 

- 01_calculate_ntiles.R takes the .csv file containing raw metric data in the data folder and calculates percentile ranks for each metric and each metric category. The output of this file is resilience.df.csv which is saved in the outputs folder.

- 02_summarize_data.R takes resilience.df.csv and summarizes data nationally within the coastal contiguous US, regionally, by state, by National Estuarine Research Reserve, and within the Gulf Islands National Seashore.

- 03_data_tables.R takes resilience.df.csv and creates Table 2 in Stevens et al. as well as tables in S2. Summary results for each spatial scale of application to US marshes

- marsh_functions.R contains custum functions used in calculating metric ranks and summarizing data. 

**output** - outputs from the R scripts that score metrics and generate figures for Stevens et al. 


