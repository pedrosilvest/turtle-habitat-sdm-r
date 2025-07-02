# Global Habitat Suitability Model for the Green Sea Turtle (*Chelonia mydas*)

<img src="https://i.imgur.com/GCSZ8z1.jpeg" alt="Turtle Header Image" width="400"/>

<sub>*Photo from imgur*</sub>

---

This repository contains the R code and analysis for a Species Distribution Model (SDM) predicting global habitat suitability for the endangered green sea turtle.

By integrating species occurrence data from **GBIF** with marine environmental predictors from **Bio-Oracle**, this project identifies key ecological drivers and maps potential habitats worldwide.

Developed as a personal project, it demonstrates skills in **spatial analysis**, **data science**, and **ecological modeling** using R.

---

## Key Features

- **Data Cleaning:** Rigorous filtering of GBIF occurrence records  
- **Environmental Integration:** 12 marine environmental variables from Bio-Oracle  
- **Modeling:** Generalized Linear Model (GLM)  
- **Validation:** 70/30 train-test split with an AUC of **0.97**

---

## Full Report

**[View the Full Project Report](https://your-username.github.io/turtle-habitat-sdm-r/report.html)**  
<sub>*Replace `your-username` with your actual GitHub username*</sub>

---

## Key Results

The model highlights **warm, shallow coastal waters** in tropical and subtropical regions as prime habitats—aligning with known sea turtle hotspots such as:

- The Caribbean  
- The Coral Triangle  
- The Great Barrier Reef  

![Final Prediction Map](https://i.imgur.com/BLjLHTd.png)  
<sub>*Figure: Predicted habitat suitability. Yellow = high suitability; blue dots = GBIF occurrence points.*</sub>

---

## Running the Analysis

### Dependencies
Ensure R is installed and run:
```r
install.packages(c(
  "tidyverse", "sf", "geodata", "raster", 
  "dismo", "rJava", "terra", "pROC"
))
