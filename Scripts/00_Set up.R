#install
#install.packages("devtools")
#devtools::install_github("USAID-OHA-SI/glamr")

#load the package
library(glamr)
library(tidyverse)
library(here)
library(glitr)
library(gisr)
library(extrafontdb)
library(scales)

## LIST TYPES OF STYLES INCLUDED WITH PACKAGE
ls("package:glamr")

#Check whats under the hood of a function
# Let's check where we are in our directory
here()

# This will setup up the default folders
folder_setup()






# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: 
install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2021-05-04')
tuesdata <- tidytuesdayR::tt_load(2021, week = 19)

water <- tuesdata$water

water <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-04/water.csv')



# Explore data

glimpse(water)

water %>% distinct(country_name)
#made up of 35
water %>% distinct(status_id)
#  y, u , n        
water %>% distinct(status)


