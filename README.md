# Global Habitat Suitability Model for the Green Sea Turtle (*Chelonia mydas*)

## Full Report

<div align="center">

  <a href="https://pedrosilvest.github.io/turtle-habitat-sdm-r/results.html" target="_blank" style="text-decoration: none;">
    <p style="display: inline-block; background-color: #2d72d9; color: white; font-size: 1.2rem; font-weight: bold; padding: 12px 24px; border-radius: 8px; margin: 20px 0;">
      🚀 View the Full Project Report
    </p>
  </a>

  <br>
  <sub>*Hosted via GitHub Pages*</sub>

  <br><br>

  <img src="https://i.pinimg.com/originals/79/05/05/790505ac915716df8c2dc4d4eb42d553.gif" width="400"/>

</div>

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

## Key Results

The model highlights **warm, shallow coastal waters** in tropical and subtropical regions as prime habitats—aligning with known sea turtle hotspots such as:

- The Caribbean  
- The Coral Triangle  
- The Great Barrier Reef  

<div align="center">
  <img src="https://i.imgur.com/BLjLHTd.png" alt="Final Prediction Map" width="600"/>
  <br>
  <sub>*Figure: Predicted habitat suitability. Yellow = high suitability; blue dots = GBIF occurrence points.*</sub>
</div>

---

## Running the Analysis

### Dependencies
Ensure R is installed and run:
```r
install.packages(c(
  "tidyverse", "sf", "geodata", "raster", 
  "dismo", "rJava", "terra", "pROC"
))
