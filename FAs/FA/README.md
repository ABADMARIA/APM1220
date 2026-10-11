# APM1220 FA5 – Principal Component Analysis

**Name:** Maria Abad  
**Assessment:** APM1220 Formative Assessment 5 – PCA of the World Happiness Report 2021

## Dataset
World Happiness Report 2021 (Helliwell, Layard, Sachs, De Neve, Aknin & Wang, 2021), https://worldhappiness.report/.
The CSV (`world-happiness-report-2021.csv`, 149 countries) was obtained from the Kaggle mirror `ajaypalsinghlo/world-happiness-report-2021`.

## Analysis
PCA on the correlation matrix (standardized variables) of seven variables: Ladder score, Logged GDP per capita, Social support, Healthy life expectancy, Freedom to make life choices, Generosity, Perceptions of corruption.
Two components have eigenvalues > 1 (3.914 and 1.289) and explain 74.3% of the variance. PC1 (55.9%) is an overall prosperity/well-being dimension; PC2 (18.4%) contrasts generosity and freedom with perceived corruption.

## Files
- `APM1220_FA5_PCA.pdf` – full report (tables, graphs, code, interpretation)
- `PCA_analysis.R` – R script for all parts
- `PCA_analysis.py` – equivalent Python script (used to generate the reported figures)
- `world-happiness-report-2021.csv` – dataset
- `scree_plot.png`, `biplot.png`, `correlation_heatmap.png` – figures

Run: place the CSV in the working directory and run `source("PCA_analysis.R")` in R/RStudio.
