library(dplyr)
library(nycflights13)

# Demo 1
#
# How many flights
# to Los Angeles (LAX) 
# did each of the legacy carriers (AA, UA, DL or US) 
# have in May 
# from JFK,
# and what was their average duration?
  
flights %>%
  filter(dest == "LAX") %>%
  filter(carrier %in% c("AA","UA","DL","US")) %>%
  filter(month == 5) %>%
  filter(origin == "JFK") %>%
  group_by(carrier,origin) %>%
  summarize(n = n(), avg_dur = mean(air_time, na.rm=TRUE))


# Demo 2
# 
# What was the shortest flight out of each airport in terms of distance? In terms of duration?

flights %>%
  select(origin, dest, air_time, distance) %>%
  group_by(origin) %>%
  arrange(air_time) %>%
  summarize(dest = dest[1], air_time = air_time[1])
  
flights %>%
  select(origin, dest, air_time, distance) %>%
  group_by(origin) %>%
  arrange(air_time) %>%
  slice(1:2)

flights %>%
  select(origin, dest, air_time, distance) %>%
  group_by(origin) %>%
  filter(air_time == min(air_time, na.rm=TRUE))
  
flights %>%
  select(origin, dest, air_time, distance) %>%
  group_by(origin) %>%
  top_n(-1, air_time)
