# Analytic Questions 1
# What country has the most watersources(total) 
# Proportion (status_id/water_source_clean)  



water_country<- water %>% 
  #make "value" variable
  mutate(value=1) %>% 
  #summarize by country to get values by country
  group_by(country_name) %>% 
  summarize(value=sum(value))
#dataset only has 2 variables, country and value

#1st iteration of plot, basic bar
water_country %>% 
  ggplot(aes(x =value, y =country_name)) +
  geom_col()
#order by value
water_country %>% 
  ggplot(aes(x =value, y =reorder(country_name,value))) +
  geom_col()

#10 NA - what are theses?
#couldnt figure out how to just filter to review this data - how do filter on NA?
water_na<-water %>% filter(country_name==is.na(country_name))




water_country2<- water %>% 
  #make "value" variable
  mutate(value=1) %>% 
  #drop NA
  drop_na(country_name)%>% 
  #summarize by country to get values by country
  group_by(country_name, status_id) %>% 
  summarize(value=sum(value))
#dataset only has 3 variables, country, value and status_id

# add color for status_id
water_country2 %>% 
  ggplot(aes(x =value, y =reorder(country_name,value), fill=status_id)) +
  geom_col() +
  si_style()
#whats going on with the order? 

# try facet for status_id
water_country2 %>% 
  ggplot(aes(x =value, y =reorder(country_name,value))) +
  geom_col() +
  si_style_nolines() + 
  facet_wrap(~status_id) 

#try to reorder in facet -- not working
#https://juliasilge.com/blog/reorder-within/
install.packages("tidytext")
library(tidytext)

water_country2 %>% 
  ggplot(aes(x =value, y =reorder_within(country_name,value, status_id))) +
  geom_col() +
  si_style() + 
  facet_wrap(~status_id, scale ="free_y") +
  scale_y_reordered()


# can patchwork in plots with larger values and plots with smaller values  

# ## Combine bars and map + title
# (pos_m + pos_bar) +
#   patchwork::plot_layout(widths = c(1,1)) +
#   patchwork::plot_annotation(
#     title = paste0(toupper(country), " - OVC_HIVSTAT_POS Results"),
#     subtitle = "Districts hightlighted in grey not part of the PSNUs",
#     caption = paste0("OHA/SIEI - DATIM 2020 PSNU x IMs Data, procuded on ", Sys.Date())
#   )
