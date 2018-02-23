# Example 1

library(coda)
library(dplyr)
library(tidyr)
library(ggplot2)

data(line,package = "coda")
d = as_data_frame(line$line1)

d %>% 
  mutate(iter = 1:n()) %>%
  gather(param, value, -iter) %>%
  ggplot(aes(x=iter, y=value, color=param)) +
    geom_line() +
    facet_wrap(~param, ncol=1)
  
# Example 2

library(purrr)
library(dplyr)
library(stringr)
library(repurrrsive)

sw_people

map_chr(sw_people, function(x) x$name)
map_chr(sw_people, ~ .x$name)
map_chr(sw_people, ~ .$name)

data_frame(
  name = map_chr(sw_people, "name"),
  height = map_chr(sw_people, "height") %>% as.double(),
  mass = map_chr(sw_people, "mass") %>% str_replace(",","") %>% as.double(),
  starships = map(sw_people, "starships")
)

## Count values == to unknown
sum(map_chr(sw_people, "mass") == "unknown")

## Count NAs
sum(is.na( map_chr(sw_people, "mass") %>% as.double() ))

## Count NAs after fixing commas
sum(is.na( map_chr(sw_people, "mass") %>% str_replace(",","") %>% as.double() ))

