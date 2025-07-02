# Load essential libraries
library(tidyverse)  # Data wrangling
library(sf)         # Spatial vector data
library(geodata)    # Environmental data (WorldClim)
library(raster)     # Raster operations (older)
library(dismo)      # Species distribution modeling (MaxEnt)
library(rJava)      # Java support (required for MaxEnt)
library(dplyr)

.jinit()
#install.packages("rJava", type = "source")

# ========== Load and clean GBIF occurrence data ==========
gbif_data <- read.table("/Users/pedrosilvestre/Desktop/species destribution modeling/0013395-250426092105405/occurrence.txt",
                        header = TRUE, sep = "\t", quote = "", stringsAsFactors = FALSE, fill = TRUE)


colnames(gbif_data)
glimpse(gbif_data)

# Filter valid coordinates and clean data
cleaned_data <- gbif_data %>%
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude)) %>%
  filter(decimalLatitude != 0 & decimalLongitude != 0) %>%
  filter(basisOfRecord %in% c("HUMAN_OBSERVATION", "OBSERVATION")) %>%
  distinct(decimalLatitude, decimalLongitude, .keep_all = TRUE)

# Convert to spatial format
points_sf <- st_as_sf(cleaned_data, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
#plot(st_geometry(points_sf), pch = 20, main = "Chelonia mydas Occurrences")

# ========== Environmental Data from WorldClim ==========
bio <- worldclim_global(var = "bio", res = 10, path = "data/")
bio_crop <- crop(bio, extent(points_sf) + 10)
bio_crop_raster <- raster::stack(bio_crop)

# Format points for modeling
occ_points <- cleaned_data %>% dplyr::select(decimalLongitude, decimalLatitude)

# small subset test maxent
#occ_small <- occ_points[1:50, ]
#maxent_model <- maxent(x = bio_crop_raster[[1]], p = occ_small)

# Clean presence points (ensure env values exist)
env_vals <- terra::extract(bio_crop, occ_points)
occ_points_clean <- occ_points[complete.cases(env_vals), ]

# MaxEnt run
maxent_model <- dismo::maxent(x = bio_crop_raster, p = occ_points_clean)
prediction <- raster::predict(bio_crop_raster, maxent_model)
plot(prediction, main = "Habitat Suitability for Chelonia mydas")
points(occ_points_clean, pch = 0, col = "blue")

# ========== Bio-Oracle Data: SST and Salinity ==========
library(biooracler)
library(terra)

# SST
dataset_id <- "tas_baseline_2000_2020_depthsurf"
variables <- c("tas_mean")
constraints <- list(time = c("2000-01-01T00:00:00Z", "2010-01-01T00:00:00Z"),
                    latitude = c(-40, 40),
                    longitude = c(-179.9, 179.9))
sst_mean <- download_layers(dataset_id, variables, constraints)

# Salinity
dataset_id_sal <- "so_baseline_2000_2019_depthsurf"
variables_sal <- c("so_mean")
salinity_mean <- download_layers(dataset_id_sal, variables_sal, constraints)


# ========== Additional Variables from Bio-Oracle NetCDF ==========
data_dir <- "/Users/pedrosilvestre/Desktop/species destribution modeling/"

# Load layers
temp_layer <- rast(file.path(data_dir, "thetao_baseline_2000_2019_depthsurf_74ff_39fa_9adc_U1746345739954.nc"))[[1]]
depth_layer <- rast(file.path(data_dir, "terrain_characteristics_6d78_4f59_9e1f_U1746345111304.nc"))[[1]]
chl_mean <- rast(file.path(data_dir, "chl_baseline_2000_2018_depthsurf_91d8_fb73_4955_U1746345356224.nc"))[[1]]
chl_max <- rast(file.path(data_dir, "chl_baseline_2000_2018_depthsurf_ee42_5b54_ed3a_U1746345483324.nc"))[[1]]
chl_range <- rast(file.path(data_dir, "chl_baseline_2000_2018_depthsurf_9b24_2b30_a110_U1746345893063.nc"))[[1]]
sal_layer <- rast(file.path(data_dir, "so_baseline_2000_2019_depthsurf_49ed_5fc4_602c_U1746345608381.nc"))[[1]]
ph_layer <- rast(file.path(data_dir, "ph_baseline_2000_2018_depthsurf_e6dc_c436_6a90_U1746346118499.nc"))[[1]]
nit_layer <- rast(file.path(data_dir, "no3_baseline_2000_2018_depthsurf_1e7f_655b_1964_U1746346035408.nc"))[[1]]
iron_layer <- rast(file.path(data_dir, "dfe_baseline_2000_2018_depthsurf_292d_e59b_b2bf_U1746346326914.nc"))[[1]]
sil_layer <- rast(file.path(data_dir, "si_baseline_2000_2018_depthsurf_02c4_4b83_645a_U1746346368965.nc"))[[1]]
phosp_layer <- rast(file.path(data_dir, "po4_baseline_2000_2018_depthsurf_2403_b208_4867_U1746346435688.nc"))[[1]]
air_layer <- rast(file.path(data_dir, "tas_baseline_2000_2020_depthsurf_2877_5344_a699_U1746346173529.nc"))[[1]]

# Align layers to a reference (temp)
align_layer <- function(target, reference) {
  target_crop <- crop(target, reference)
  resample(target_crop, reference)
}
ref <- temp_layer

env_stack <- c(
  temp_layer,
  align_layer(depth_layer, ref),
  align_layer(chl_mean, ref),
  align_layer(chl_max, ref),
  align_layer(chl_range, ref),
  align_layer(sal_layer, ref),
  align_layer(ph_layer, ref),
  align_layer(nit_layer, ref),
  align_layer(iron_layer, ref),
  align_layer(sil_layer, ref),
  align_layer(phosp_layer, ref),
  align_layer(air_layer, ref)
)
names(env_stack) <- c("temp", "depth", "chl_mean", "chl_max", "chl_range",
                      "salinity", "pH", "nitrate", "iron", "silicate", "phosphate", "air_temp")



png("/Users/pedrosilvestre/Desktop/species destribution modeling/github/plot/mean_sst_salinity_depth.png")  # taller to fit 3 plots

par(mfrow = c(3, 1))  # 3 rows, 1 column layout

plot(sst_mean[[1]], main = "Mean Sea Surface Temperature (2000–2010)")
plot(salinity_mean[[1]], main = "Mean Sea Surface Salinity (2000–2010)")
plot(env_stack[["depth"]], main = "Depth")

dev.off()





# ========== Modeling: GLM ==========
points_vect <- vect(points_sf)
pres_vals <- terra::extract(env_stack, points_vect)
pres_vals$presence <- 1

set.seed(42)
bg_points <- spatSample(env_stack, size = 10000, method = "random", na.rm = TRUE, as.points = TRUE)
bg_vals <- terra::extract(env_stack, bg_points)
bg_vals$presence <- 0

model_df <- na.omit(rbind(pres_vals, bg_vals))

# Fit logistic regression
glm_model <- glm(presence ~ ., data = model_df[, -1], family = binomial)
summary(glm_model)

# Predict and plot
prediction <- predict(env_stack, glm_model, type = "response")


png("/Users/pedrosilvestre/Desktop/species destribution modeling/github/plot/predicted_habitat.png", width=800, height=800)

par(mfrow= c(2,1))
plot(prediction, main = "Predicted Habitat Suitability for Chelonia mydas")

plot(prediction, main = "With Chelonia mydas gbif occurences")
points(points_sf, col = "blue", pch = 20)

dev.off()

# train and test
set.seed(42)
train_idx <- sample(seq_len(nrow(model_df)), size = 0.7 * nrow(model_df))

train_data <- model_df[train_idx, ]
test_data <- model_df[-train_idx, ]

# Fit model on training data
glm_model <- glm(presence ~ ., data = train_data[, -1], family = binomial)
summary(glm_model)

# Predict on test data
test_preds <- predict(glm_model, newdata = test_data[, -1], type = "response")

# Evaluate (for example, calculate AUC)
library(pROC)
roc_obj <- roc(test_data$presence, test_preds)
auc(roc_obj) 
# 0.9707 




