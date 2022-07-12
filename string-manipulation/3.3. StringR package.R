# The main tasks of string processing tasks are detecting, locating, extracting
# and replacing elements of strings
# 
# The stringr package from the tidyverse includes a variety of string 
# processing functions that begin with "str_" and take the string as the 
# first argument, which makes them compatible with the pipe.
# 

## Code: 
# murders_raw defined in web scraping video

# direct conversion to numeric fails because of commas
murders_raw$population[1:3]
as.numeric(murders_raw$population[1:3])

library(tidyverse)    # includes stringr