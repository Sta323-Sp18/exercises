library(sparklyr)
library(dplyr)
library(dbplyr)
library(stringr)
library(ggplot2)

#spark_install()
#spark_available_versions()

sc = spark_connect(master = "local[4]", spark_home = "/data/spark/spark-2.2.1-bin-hadoop2.7/")

# Using readr
#system.time({green = readr::read_csv("/data/nyc-taxi-data/nyc_taxi_2017/green_tripdata_2017-01.csv")})
#system.time({yellow = readr::read_csv("/data/nyc-taxi-data/nyc_taxi_2017/yellow_tripdata_2017-01.csv")})

green = spark_read_csv(sc, "green", path = "/data/nyc-taxi-data/nyc_taxi_2017/green_tripdata_2017-01.csv")
yellow = spark_read_csv(sc, "yellow", path = "/data/nyc-taxi-data/nyc_taxi_2017/yellow_tripdata_2017-01.csv")

fix_colnames = function(df) {
  colnames(df) %>%
    tolower() %>%
    str_replace("[lt]pep_","") %>%
    setNames(df, .)
}

green = fix_colnames(green)
yellow = fix_colnames(yellow)

# yellow %>% 
#   head(50) %>%
#   mutate(
#     dropoff_datetime = str_replace(dropoff_datetime, "\\d{4}-\\d{2}-\\d{2} ", "")
#   )
# 
# green %>% 
#   head(50) %>%
#   mutate(
#     dropoff_datetime = regexp_replace(dropoff_datetime, "[0-9]{4}-[0-9]{2}-[0-9]{2} ", "")
#   )


wday_hour_summary = function(df, label) {
  df %>%
    dplyr::select(pickup_datetime, dropoff_datetime, trip_distance, fare_amount, tip_amount) %>%
    mutate(
      hour = hour(pickup_datetime),
      trip_time = (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime))/60,
      wday = date_format(pickup_datetime, "E") 
    ) %>%
    group_by(hour, wday) %>%
    summarize(
      avg_dist = mean(trip_distance, na.rm=TRUE),
      avg_time = mean(trip_time, na.rm=TRUE),
      avg_fare = mean(fare_amount, na.rm=TRUE),
      avg_tip_perc = mean(tip_amount / fare_amount, na.rm=TRUE)
    ) %>%
    mutate(type = label) %>%
    collect()
}

green_wday = wday_hour_summary(green, "green")
yellow_wday = wday_hour_summary(yellow, "yellow")

bind_rows(
  green_wday,
  yellow_wday
) %>%
  ungroup() %>%
  tidyr::gather(quantity, value, starts_with("avg")) %>%
  mutate(wday = factor(wday, levels = c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))) %>%
  ggplot(aes(x=hour, y=value, color=type)) +
    geom_line(size=1.5) +
    facet_grid(quantity ~ wday, scales = "free_y") + 
    scale_color_manual(values=c("green","yellow"))

### Zones

zones = sf::st_read("/data/nyc-taxi-data/taxi_zones/")

plot(sf::st_geometry(zones))





## Reddit data

reddit = spark_read_json(sc, "reddit", "/data/reddit/RC_2017-10-smaller")

### Popular subreddits

reddit %>% 
  select(author, subreddit, body) %>%
  group_by(subreddit) %>%
  summarize(n = n()) %>%
  arrange(desc(n)) %>%
  head(50) %>%
  collect()

### Most posts

reddit %>% 
  select(author, subreddit, body) %>%
  group_by(author) %>%
  summarize(n = n()) %>%
  arrange(desc(n)) %>%
  head(50) %>%
  collect()

### When do people post

reddit %>% 
  select(author, subreddit, body, created_utc) %>% 
  mutate(hour = hour(from_unixtime(created_utc))) %>%
  count(hour) %>%
  arrange(hour) %>%
  collect() %>%
  plot(type='l')


### 

library(tidytext)

reddit %>% 
  select(author, subreddit, body) %>%
  head(10000) %>%
  collect() %>%
  mutate(text = str_split(body," ")) %>%
  tidyr::unnest() %>%
  mutate(
    text = tolower(text),
    text = str_replace_all(text, "[^a-z]", "")
  ) %>%
  count(text) %>% 
  arrange(desc(n)) %>%
  mutate(word = text) %>%
  anti_join(tidytext::get_stopwords())

reddit %>% 
  select(author, subreddit, body) %>%
  mutate(body = regexp_replace(body, "[^A-Za-z ]","")) %>%
  ft_tokenizer("body", "tokens") %>%
  ft_stop_words_remover("tokens", "word") %>%
  mutate(word = explode(word)) %>%
  count(word) %>%
  arrange(desc(n))


## Hamlet example

hamlet = spark_read_text(sc, "hamlet", "/data/Shakespeare/hamlet.txt")

hamlet %>% 
  mutate(line = regexp_replace(line, "[^A-Za-z ]","")) %>%
  ft_tokenizer("line", "tokens") %>%
  ft_stop_words_remover("tokens", "word") %>%
  mutate(word = explode(word)) %>%
  count(word) %>%
  arrange(desc(n))
  
 