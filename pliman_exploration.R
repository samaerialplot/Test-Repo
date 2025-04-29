if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("EBImage")

install.packages("stars")
install.packages("rgdal")
install.packages("pliman")
library(sf)
library(terra)

library(mapview)
library(raster)
library(rgdal)




library(pliman)
url <- "20241008_FETT_BOTH_10BAND_v5-COMPOSITE_UTM33N.tif"
url2 <- "20250218_BOOT_RANCH7_10BAND-COMPOSITE.tif"
url3 <- "20250217_FETTERSALMONDS_10BAND-COMPOSITE.tif"
mosaic <- mosaic_input(url3)
mosaic2 <- mosaic_input(url2)
# Reproject to UTM Zone 11N (EPSG:32611) or your region’s appropriate zone
mosaic_proj <- mosaic_project(mosaic,  "EPSG:32633")

terra::writeRaster(mosaic2_proj, "20250218_BOOT_RANCH7_10BAND-COMPOSITE_utm33.tif", overwrite = TRUE)


res <- mosaic_analyze(mosaic, r = 3, g = 2, b = 1,
                      segment_individuals = TRUE,
                      segment_index =  "(G-B)/(G+B-R)",  #(G-B)/(G+B-R)
                      # segment_pick = T,
                      filter = 10,
                      lower_noise = 0.1,
                      nrow = 10,
                      ncol = 10,
                      map_individuals = T,
                      downsample = 6,
                      watershed = T,
                      max_pixels = 1000000)
res$map_indiv


# this worked for url3
res <- mosaic_analyze(mosaic, r = 1, g = 3, b = 1,
                      segment_individuals = TRUE,
                      segment_index =  "(R+G+B)/((G/B)*(R-B+256))",
                      # segment_pick = T,
                      filter = 20,
                      lower_noise = 0.1,
                      nrow = 1,
                      map_individuals = T,
                      downsample = 2,
                      watershed = F)
res$map_indiv

shapefile_export(res$shapefile, filename = "your_shapefile.shp")

# Extract just the polygons (skip the RasterBrick)
polygons_only <- res$map_indiv@object[2:3]

# Combine them into one sf object
indiv_sf <- st_sf(geometry = do.call(c, polygons_only))

# Now export to shapefile
shapefile_export(indiv_sf, filename = "map_indiv_almond.shp")







########## Pliman shiny ###############################

install.packages("pak")
pak::pkg_install("NEPEM-UFSC/pliman")
pak::pkg_install("NEPEM-UFSC/plimanshiny")

devtools::install_github("NEPEM-UFSC/plimanshiny")
install.packages("plimanshiny")
install.packages("DT")


library(plimanshiny)
run_app()
#this is a test change for github test
