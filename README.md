# Tidal_Marsh_Resilience
A repo to store files related to [Stevens et al. 2023](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0293177)

Stevens, R. A., Shull, S., Carter, J., Bishop, E., Herold, N., Riley, C. A., & Wasson, K. (2023). Marsh migration and beyond: A scalable framework to assess tidal wetland resilience and support strategic management. Plos one, 18(11), e0293177.

## Abstract
Tidal wetlands are critical but highly threatened ecosystems that provide vital services. Efficient stewardship of tidal wetlands requires robust comparative assessments of different marshes to understand their resilience to stressors, particularly in the face of relative sea level rise. Existing assessment frameworks aim to address tidal marsh resilience, but many are either too localized or too general, and few directly translate resilience evaluations to recommendations for management strategies. In response to the deficiencies in existing frameworks, we identified a set of metrics that influence overall marsh resilience that can be assessed at any spatial scale. We then developed a new comprehensive assessment framework to rank relative marsh resilience using these metrics, which are nested within three categories. We represent resilience as the sum of results across the three metric categories: current condition, adaptive capacity, and vulnerability. Users of this framework can add scores from each category to generate a total resilience score to compare across marshes or take the score from each category and refer to recommended management actions we developed based on expert elicitation for each combination of category results. We then applied the framework across the contiguous United States using publicly available data, and summarized results at multiple spatial scales, from regions to coastal states to National Estuarine Research Reserves to finer scale marsh units, to demonstrate the framework’s value across these scales. Our national analysis allowed for comparison of tidal marsh resilience across geographies, which is valuable for determining where to prioritize management actions for desired future marsh conditions. In combination, the assessment framework and recommended management actions function as a broadly applicable decision-support tool that will enable resource managers to evaluate tidal marshes and select appropriate strategies for conservation, restoration, and other stewardship goals.

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


