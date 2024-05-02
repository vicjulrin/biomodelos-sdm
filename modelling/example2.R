# https://biomodelos.github.io/tallerNatGeo/working-example-2.html

library(maps)
library(dplyr)
library(ggplot2)
library(sf)
library(terra)

dir_work<- this.path::this.path() %>% dirname()
setwd(dir_work)

dataSp <- read.csv("example/Occurrences/single_species_2.csv")

source("R/fit_biomodelos.R")
fit_biomodelos(
  occ = dataSp, col_sp = "acceptedNameUsage", col_lat = "decimalLatitude",
  col_lon = "decimalLongitude", clim_vars = "worldclim", dir_clim = "example/Data/env_vars/",
  dir_other = "example/Data/env_vars/other/", method_M = "points_MCP_buffer", dist_MOV = 74,
  proj_models = "M-M", remove_distance = 10, remove_method = "sqkm",
  fc_small_sample = c("l", "q", "lq"), beta_small_sample = c(1, 1.5, 2)
)


models <- list.files("Bucco.noanamae/ensembles/current/MAXENT/", full.names = T)[3] |>
  rast() |>
  crop(col)
