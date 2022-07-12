dat <- gapminder %>% filter(region == "Middle Africa") %>% 
  mutate(country_short = recode(country, 
                                "Central African Republic" = "CAR", 
                                "Congo, Dem. Rep." = "DRC",
                                "Equatorial Guinea" = "Eq. Guinea"))

library(rvest)
library(tidyverse)
library(stringr)

url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
tab <- read_html(url) %>% html_nodes("table")
polls <- tab[[6]] %>% html_table(fill = TRUE)

polls <- polls %>% setNames(c("dates", "remain", "leave", 
                     "undecided", "lead", 
                     "samplesize", "pollster", 
                     "poll_type", "notes"))

polls %>% filter(str_detect(remain, "%$")) %>% nrow


head(polls)
  
as.numeric(str_replace(polls$remain, "%", ""))/100

parse_number(polls$remain)/100

str_replace(polls$undecided, "N/A", "0")

polls$dates

temp <- str_extract_all(polls$dates, "\\d+\\s[a-zA-Z]{3,5}")
end_date <- sapply(temp, function(x) x[length(x)]) # take last element (handles polls that cross month boundaries)
head(end_date)
