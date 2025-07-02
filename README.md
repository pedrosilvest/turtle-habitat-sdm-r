# Global Habitat Suitability Model for the Green Sea Turtle (*Chelonia mydas*)

![Turtle Header Image](https://images.unsplash.com/photo-1543826315-99f5446419b4?q=80&w=1740&auto=format&fit=crop)
*Photo by [Jakob Owens](https://unsplash.com/@jakobowens1) on Unsplash*


This repository contains the R code and analysis for a Species Distribution Model (SDM) predicting the global habitat suitability for the endangered green sea turtle. By integrating species occurrence data from the Global Biodiversity Information Facility (GBIF) with marine environmental data from Bio-Oracle, this project identifies key environmental drivers and maps potential habitats worldwide.

This analysis was developed as a personal project for learning and demonstrating skills in spatial analysis, data science, and ecological modeling in R.

### Key Features:
-   **Data Cleaning:** Rigorous filtering of GBIF occurrence records.
-   **Environmental Data Integration:** Assembling a comprehensive stack of 12 relevant marine predictors from Bio-Oracle.
-   **Robust Modeling:** Using a Generalized Linear Model (GLM) for prediction.
-   **Model Validation:** Implementing a train-test split (70/30) to ensure an unbiased performance evaluation, achieving an **AUC of 0.97**.

---

## 📊 Full Report and Results

For a complete walkthrough of the methodology, data sources, results, interpretation, and future directions, please view the full, detailed HTML report hosted on GitHub Pages:

**[➡️ View the Full Project Report Here](https://your-username.github.io/turtle-habitat-sdm-r/report.html)** 
*(Note: Replace `your-username` with your GitHub username)*

---

## 📈 Key Results

The model successfully identifies warm, shallow coastal waters in tropical and subtropical regions as prime habitats, aligning closely with known turtle congregation areas in the Caribbean, the Coral Triangle, and the Great Barrier Reef.

![Final Prediction Map](images/predicted_habitat.png)
*Figure: The final predicted habitat suitability map. Warmer colors (yellow) indicate higher suitability, while blue dots represent the GBIF occurrence points used in the analysis.*

---

## 🚀 How to Run This Analysis

### Dependencies
You will need R and the following packages. You can install them using `install.packages("package_name")`.
```R
library(tidyverse)
library(sf)
library(geodata)
library(raster)
library(dismo)
library(rJava)
library(terra)
library(pROC)


You will also need a working Java installation for the rJava package.

Execution Steps

Clone the Repository:

Generated bash
git clone https://github.com/your-username/turtle-habitat-sdm-r.git
cd turtle-habitat-sdm-r
IGNORE_WHEN_COPYING_START
content_copy
download
Use code with caution.
Bash
IGNORE_WHEN_COPYING_END

Add Data:

Place your GBIF occurrence data (occurrence.txt) in a /data subfolder.

Place your Bio-Oracle environmental NetCDF (.nc) files in a /data/environmental_layers subfolder.

Update Script:

Open the sdm_analysis.R script.

Update the file paths at the top of the script to point to your data locations.

Run the Script:

Execute the script in your R environment to perform the analysis and generate the plots.

Repository Structure

.
├── images/
│   ├── predicted_habitat.png
│   └── mean_sst_salinity_depth.png
├── sdm_analysis.R
├── report.html
└── README.md
