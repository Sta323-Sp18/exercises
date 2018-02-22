library(rvest)
library(magrittr)
library(stringr)
library(tibble)

url = "https://www.rottentomatoes.com/"

page = read_html(url)

fix_gross = function(x) {
  x %>%
    str_trim() %>%
    str_replace("M$","") %>%
    str_replace("^\\$","") %>%
    as.double() %>%
    {. * 1e6}
}

fix_tmeter = function(x) {
  x %>%
    str_replace("%$","") %>%
    as.double() %>%
    {. / 100}
}

fix_rating = function(x) {
  x %>%
    str_replace("tiny", "") %>%
    str_replace("icon", "") %>%
    str_trim() %>%
    str_replace("_", " ") %>%
    tools::toTitleCase()
}

d = data_frame(
  title = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_text(),
  gross = page %>% html_nodes("#Top-Box-Office .right a") %>% html_text() %>% fix_gross(),
  tmeter = page %>% html_nodes("#Top-Box-Office .tMeterScore") %>% html_text() %>% fix_tmeter(),
  rating = page %>% html_nodes("#Top-Box-Office .icon") %>% html_attr("class") %>% fix_rating(),
  url = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_attr("href") %>% paste0(url, .)
)

library(purrr)

movie_page = map_dfr(
  d$url,
  function(url) {
    page = read_html(url)
    
    data_frame(
      mpaa = page %>% html_nodes(".clearfix:nth-child(1) .meta-value") %>% html_text() %>% str_replace(" *\\(.*\\)",""),
      director = page %>% html_nodes(".clearfix:nth-child(3) a") %>% html_text() %>% list()
    )
  }
)

dplyr::bind_cols(d, movie_page)





