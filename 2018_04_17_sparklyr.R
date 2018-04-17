library(sparklyr)
library(dplyr)
library(dbplyr)
library(stringr)

#spark_install()
#spark_available_versions()

sc = spark_connect(master = "local[4]", spark_home = "/data/spark/spark-2.2.1-bin-hadoop2.7/")

# Using readr
#system.time({green = readr::read_csv("/data/nyc-taxi-data/nyc_taxi_2017/green_tripdata_2017-01.csv")})
#system.time({yellow = readr::read_csv("/data/nyc-taxi-data/nyc_taxi_2017/yellow_tripdata_2017-01.csv")})

system.time({green = spark_read_csv(sc, "green", path = "/data/nyc-taxi-data/nyc_taxi_2017/green_tripdata_2017-01.csv")})
system.time({yellow = spark_read_csv(sc, "yellow", path = "/data/nyc-taxi-data/nyc_taxi_2017/yellow_tripdata_2017-01.csv")})

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
      avg_dist = mean(trip_distance),
      avg_time = mean(trip_time),
      avg_fare = mean(fare_amount),
      avg_tip_perc = mean(tip_amount / fare_amount)
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
  tidyr::gather(var, value, starts_with("avg")) %>%
  mutate(wday = factor(wday, levels = c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))) %>%
  ggplot(aes(color = type, x=hour, y=value)) +
    geom_line(size=1.5) +
    facet_grid(var~wday, scale="free_y") +
    scale_color_manual(values=c('green','yellow')) +
    labs(y="")

  
