# The most common tasks in string processing include:
# 
#   -extracting numbers from strings
#   -removing unwanted characters from text
#   -finding and replacing characters
#   -extracting specific parts of strings
#   -converting free from text to more uniform formats
#   -splitting strings into multiple values
#   
#
# The stringr pckg in the tidyverse contains string processing functions
#

## Code:
# read in raw murders data from Wikipedia
library(tidyverse)
library(rvest)
url <- "https://en.wikipedia.org/w/index.php?title=Gun_violence_in_the_United_States_by_state&direction=prev&oldid=810166167"
murders_raw <- read_html(url) %>% 
  html_nodes("table") %>% 
  html_table() %>%
  .[[1]] %>%
  setNames(c("state", "population", "total", "murder_rate"))

# inspect data and column classes
head(murders_raw)
class(murders_raw$population)
class(murders_raw$total)