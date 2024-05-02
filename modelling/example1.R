# https://biomodelos.github.io/tallerNatGeo/working-example-1.html

library(maps)
library(dplyr)
library(ggplot2)
library(sf)
library(terra)
library(tools)
library("spThin")
library(raster)


dir_work<- this.path::this.path() %>% dirname()

setwd(dir_work)

dataSp <- read.csv("example/Occurrences/single_species_1.csv")

env_r <- list.files("example/Data/env_vars/worldclim/current/", recursive = T, full.names = T) |> 
  rast()
plot(env_r)

source("setup.R")
source("R/fit_biomodelos.R")

closeAllConnections()

library("ENMeval")


# pkgbuild::check_build_tools(debug = TRUE)
#     devtools::install_github("marlonecobos/kuenm")

# java jdk directory al path variables de entorno como JAVA_HOME


Sys.which("make")

install.packages("devtools")
install.packages("pkgbuild")

pkgbuild::check_build_tools(debug = TRUE)
Sys.which("make")



install.packages("devtools")

remotes::install_github("marlonecobos/kuenm")


devtools::install_github("marlonecobos/kuenm")




fit_biomodelos(
  occ = dataSp, col_sp = "species", col_lat = "lat",
  col_lon = "lon", clim_vars = "worldclim", dir_clim = "example/Data/env_vars/",
  dir_other = "example/Data/env_vars/other/", method_M = "points_buffer", dist_MOV = 74,
  proj_models = "M-M", remove_distance = 10, remove_method = "spthin"
)









