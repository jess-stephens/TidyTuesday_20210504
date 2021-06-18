#Analytic Question 3
#Quality of products 
#Status/status_id by installer/install_year/water_tech 



water_source<- water %>% 
  #make "value" variable
  mutate(value=1) %>% 
  #summarize by country to get values by country
  group_by(water_source) %>%  
  summarize(value=sum(value))
#dataset only has 2 variables, country and value

#1st iteration of plot, basic bar
water_source %>% 
  ggplot(aes(x =value, y =water_source)) +
  geom_col()
#order by value
water_source %>% 
  ggplot(aes(x =value, y =reorder(water_source,value))) +
  geom_col()

#10 NA - what are theses?
#couldnt figure out how to just filter to review this data - how do filter on NA?
#water_na<-water %>% filter(country_name==is.na(water_source))




water_source2<- water %>% 
  #make "value" variable
  mutate(value=1) %>% 
  #drop NA
  drop_na()%>% 
  #summarize by country to get values by country
  group_by(water_source, water_tech, status_id) %>% 
  summarize(value=sum(value))
#dataset only has 3 variables, country, value and status_id


# add color for status_id
water_source2 %>% 
  ggplot(aes(x =value, y =reorder(water_source,value), fill=status_id)) +
  geom_col() +
  si_style()
#whats going on with the order? 

# try facet for status_id
water_source2 %>% 
  ggplot(aes(x =value, y =reorder(water_source,value))) +
  geom_col() +
  si_style_nolines() + 
  facet_wrap(~water_source) 

#try to reorder in facet -- not working
#https://juliasilge.com/blog/reorder-within/
install.packages("tidytext")
library(tidytext)

water_source2 %>% 
  ggplot(aes(x =value, y =reorder_within(water_source,value, status_id))) +
  geom_col() +
  si_style() + 
  facet_wrap(~status_id, scale ="free_y") +
  scale_y_reordered()
