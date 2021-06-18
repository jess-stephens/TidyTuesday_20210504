#Analytic Questions 2
#Map of where the status or status_id needs to be fixeds  


# Grand father of all Spatial Data Packages: https://cran.r-project.org/web/packages/sp/vignettes/intro_sp.pdf
install.packages("sp")
# Simple Feature for R. An improve version of sp: https://r-spatial.github.io/sf/
install.packages("sf")
# Spatial Data manipulation: https://rspatial.org/raster/index.html#
install.packages("raster")
# Good resource for vector and raster data: http://www.naturalearthdata.com/
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
# SI Packages for Mapping and Spatial Analytics: https://github.com/USAID-OHA-SI/gisr
devtools::install_github("USAID-OHA-SI/gisr")

install.packages("rgdal")

library(rgdal)




library(glamr)
library(raster)
# Setup folder
glamr::folder_setup(folder_list = list("GIS"))
# Download Admins boundaries
## National Boundaries
adm0 <- getData("GADM", country = "UGA", level = 0, download = TRUE, path = "GIS")
adm0
## Regions / province
adm1 <- getData("GADM", country ="UGA", level = 1, download = TRUE, path = "GIS")
adm1



# Let's extract geodata from rnaturaleath - data is in the memory

install.packages("rgeos")
library(rgeos)
library(rnaturalearth)
# Download Admins boundaries
## National Boundaries
civ0 <- ne_countries(country = "Uganda", scale = "medium", returnclass = "sf")
civ0
## Regions / province
civ1 <- ne_states(country = "Uganda", returnclass = "sf")
civ1



# Can you download geodata with `gisr` paackage?
library(gisr)
# from rnaturalearth
get_admin0(countries = "Togo")
get_admin0(countries = "Uganda")

get_admin1(countries = "Ghana")
# from raster package
get_adm_boundaries(country_code = "UGA", geo_path = "GIS")


# 
# Let's read geodata from local file
# 
# Downlaod shapefiles from [GADM] (https://gadm.org/download_country_v3.html)


here
library(sf)
country <- read_sf("GIS/gadm36_UGA_shp/gadm36_UGA_0.shp")
country



## Spatial Data Visualization

#There are multiple ways to visualize geodata: `plot` or `ggplot` or `gisr`

library(tidyverse)
library(sf)
library(gisr)
# plotting sp data
plot(adm0, main = "Uganda")
# transform sp to sf
cntry <- st_as_sf(adm0)
cntry
regions <- st_as_sf(adm1)
regions
# Transform geodata with dplyr
regions <- regions %>% 
  dplyr::select(name = NAME_1)
regions
# Visualize sf data with ggplot
ggplot(data = regions) +
  geom_sf(aes(fill = name), show.legend = F)
# Change default style and remove theme
ggplot(data = regions) +
  geom_sf(aes(fill = name), color = "white", size = .5, show.legend = FALSE) +
  labs(title = "Uganda - Regional sub-divisions") +
  theme_void()
# Cartographic?
ggplot() +
  geom_sf(data = cntry, fill = NA, color = glitr::grey70k, size = 1) +
  geom_sf(data = regions, fill = NA, color = glitr::grey50k, size = .3, linetype = "dotted") +
  geom_sf(data = cntry, fill = NA, color = glitr::grey30k, size = .3, show.legend = FALSE) +
  labs(title = "Uganda - Regional sub-divisions") +
  si_style_map()


#Try to Add water geo data

#http://zevross.com/blog/2014/07/16/mapping-in-r-using-the-ggplot2-package/

proj4string(cntry)#doesn't work, check prj file for D_WGS_1984

water_uga<-water %>% 
  filter(country_name=="Uganda")



class(water_uga)
## example [1] "data.frame"
# water_uga [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame" 
coordinates(water_uga)<-~lon_deg+lat_deg
class(water_uga)
## [1] "SpatialPointsDataFrame"
## attr(,"package")
## [1] "sp"

# does it have a projection/coordinate system assigned?
proj4string(water_uga) # nope
## [1] NA

###FOLLOWING DIDNT WORK
# we know that the coordinate system is NAD83 so we can manually
# tell R what the coordinate system is
# proj4string(water_uga)<-CRS("+proj=GCS_WGS_1984 +datum=D_WGS_1984")
# proj4string(water_uga)<-CRS("+proj=longlat +datum=D_WGS_1984")
# 
# # now we can use the spTransform function to project. We will project
# # the mapdata and for coordinate reference system (CRS) we will
# # assign the projection from counties
# water_uga<-spTransform(water_uga, CRSobj(proj4string(cntry)))
# 
# # double check that they match
# identical(proj4string(water_uga),proj4string(cntry))
# ## example: [1] TRUE


# ggplot can't deal with a SpatialPointsDataFrame so we can convert back to a data.frame
water_uga<-data.frame(water_uga)

# we're not dealing with lat/long but with x/y
# this is not necessary but for clarity change variable names
names(water_uga)[names(water_uga)=="lon_deg"]<-"x"
names(water_uga)[names(water_uga)=="lat_deg"]<-"y"

# now create the map
ggplot() +geom_polygon(data=cntry, aes(x=long, y=lat, group=group))+  
  geom_point(data=water_uga, aes(x=x, y=y), color="red")




ggplot() +
  geom_sf(data = cntry, fill = NA, color = glitr::grey70k, size = 1) +
  geom_sf(data = regions, fill = NA, color = glitr::grey50k, size = .3, linetype = "dotted") +
  geom_sf(data = cntry, fill = NA, color = glitr::grey30k, size = .3, show.legend = FALSE) +
  labs(title = "Uganda - Regional sub-divisions") +
  si_style_map() 
+
geom_point(data=water_uga, aes(x=x, y=y), color="red")






#ERROR INSTALLING PACKAGE

## Spatial Data Visualization with gisr
# 
# install.packages("rnaturalearthhires", repos = "http://packages.ropensci.org", type = "source")
# 
# gisr::terrain_map(countries = list("Uganda"), terr_path = "../../../GEODATA/RASTER")
# gisr::terrain_map(countries = list("Uganda"), terr_path = "../../../GEODATA/RASTER", mask = TRUE)
# gisr::terrain_map(countries = list("Uganda"), terr_path = "../../../GEODATA/RASTER", add_neighbors = TRUE)
# gisr::admins_map(countries = list("Uganda"), add_neighbors = TRUE)

## Spatial Data Visualization + PEPVAR OVC Results
# 
# Now let's try to integrate the spatial dimension of PEPFAR OVC Results
# 
# Background: 
# 
# The CAC received a request for mapping support from PEDs/OVC.
# The request came in a bit late and the output was supposed to be for the MOZ Deep Dive. 
# 
# [lastmile Repo](https://github.com/USAID-OHA-SI/lastmile)
# 
# 1) FY20 Q2 - OVC_HIVSTAT_POS Results

# 
# library(tidyverse)
# library(sf)
# library(gisr)
# library(glitr)
# library(patchwork)
# library(here)
# # Vars
# country = "Ugandabique"
# file_psnu_txt <- "MER_Structured_Datasets_PSNU_IM_FY18-20_20200626_v2_1_Mozambique"
# file_districts <- "Mozambique_PROD_5_District_DistrictLsib_2020_Feb.shp"
# # Data
# ## Geo - Moz PSNUs Boundaries
# moz_districts <- list.files(
#         path = here("../../GEODATA", "PEPFAR"),
#         pattern = file_districts,
#         recursive = TRUE,
#         full.names = TRUE
#     ) %>%
#     unlist() %>%
#     first() %>%
#     read_sf()
# moz_districts %>% glimpse()
# ## Get admin1 geodata
# moz1 <- gisr::get_admin1(country)
# moz1 %>% glimpse()
#     
# 
# 
# ## Generate a map 
# pos_m <- gisr::terrain_map(countries = country, 
#                            terr_path = "../../../GEODATA/RASTER", 
#                            mask = TRUE) +
#     ggplot2::geom_sf(data = df, aes(fill = cumulative), lwd = .1, color = grey10k) +
#     ggplot2::geom_sf(data = moz1, fill = NA, linetype = "dotted") +
#     ggplot2::geom_sf_text(data = moz1, aes(label = name), color = grey80k, size = 3) +
#     ggplot2::scale_fill_viridis_c(direction = -1, na.value = grey30k) +
#     ggplot2::coord_sf() +
#     gisr::si_style_map() +
#     ggplot2::theme(
#         legend.position =  c(.9, .2),
#         legend.direction = "vertical",
#         legend.key.width = ggplot2::unit(.5, "cm"),
#         legend.key.height = ggplot2::unit(1, "cm")
#     )
# 
# 
# 
