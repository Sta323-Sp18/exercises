library(httr)
library(glue)

library(jsonlite)
library(magrittr)
library(purrr)


## Google Maps Example - https://developers.google.com/maps/documentation/geocoding/intro

google_key = readLines("~/tmp_google_key")

readLines(glue("https://maps.googleapis.com/maps/api/geocode/xml?address=Duke+University&key={google_key}"))
readLines(glue("https://maps.googleapis.com/maps/api/geocode/json?address=Duke+University&key={google_key}")) %>% cat(sep="\n")

readLines(glue("https://maps.googleapis.com/maps/api/geocode/json?address=Durham&key={google_key}")) %>% cat(sep="\n")

readLines(glue("https://maps.googleapis.com/maps/api/geocode/json?address=Durham&region=gb&key={google_key}")) %>% cat(sep="\n")

readLines(glue("https://maps.googleapis.com/maps/api/geocode/json?address=Durham&region=gb"))


## restcountries.eu


us = fromJSON("https://restcountries.eu/rest/v2/name/united%20states", simplifyVector = FALSE)


### 1. How many countries are in this data set?

all = fromJSON("https://restcountries.eu/rest/v2/all?fields=name", simplifyVector = FALSE)
length(all)

### 2. Which countries are members of ASEAN (Association of Southeast Asian Nations)?

asean = fromJSON("https://restcountries.eu/rest/v2/regionalbloc/ASEAN?fields=name", simplifyVector = FALSE) 
unlist(asean)
map_chr(asean, "name")


### 3. What are all of the currencies used in the Americas?

am = fromJSON("https://restcountries.eu/rest/v2/region/Americas?fields=currencies", simplifyVector = FALSE) 

c(map_chr(am, list("currencies",1,"name")), map_chr(am, list("currencies",2,"name"), .default=NA)) %>% na.omit()




## Github API - https://developer.github.com/v3/

github_token = readLines("~/tmp_token")


### User Info

httr::GET("https://api.github.com/users/rundel") %>% httr::content(type="text") %>% cat(sep="\n")

httr::GET(glue("https://api.github.com/user?access_token={github_token}"))


### Repo



httr::POST(
  glue("https://api.github.com/orgs/Sta323-Sp18/repos?access_token={github_token}"),
  body = list(
    name = "Hello-World",
    description = "This is your first repository",
    homepage = "https://github.com",
    private = FALSE,
    has_issues = TRUE,
    has_projects = TRUE,
    has_wiki = TRUE,
    auto_init	= TRUE
  ),
  encode = "json"
)


httr::PATCH(
  glue("https://api.github.com/repos/Sta323-Sp18/Hello-World?access_token={github_token}"),
  body = list(
    name = "Hello-World",
    description = "This is the new description"
  ),
  encode = "json"
)



httr::DELETE(
  glue("https://api.github.com/repos/Sta323-Sp18/Hello-World?access_token={github_token}")
)


