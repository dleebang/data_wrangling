# A regular expression (regex) is a way to describe a specific pattern of characters
# of text. A set of rules has been designed to do this specifically and efficiently.
# 
# stringr functions can take a regex as a pattern
# 
# str_detect() indicates whether a pattern is present in a string
# 
# The main difference between a regex and a regular string is that a regex
# can include special characters 
# 
# The | symbol inside a regex means "or".
# 
# Use "\\d" to represent digits. The backslash is used to distinguish it from
# the character "d". In R, you must use two backslashes for digits in regular
# expressions because you need to scape the backslash
# 
# str_view() highliths the first occurrence of a pattern, and the str_view_all()
# function highlights all occurrences of the pattern.
# 

##Code:
# load stringr through tidyverse
install.packages("htmlwidgets")
library(htmlwidgets)
library(tidyverse)

# detect whether a comma is present
pattern <- ","
str_detect(murders_raw$total, pattern) 

# show the subset of strings including "cm"
str_subset(reported_heights$height, "cm")

# use the "or" symbol inside a regex (|)
yes <- c("180 cm", "70 inches")
no <- c("180", "70''")
s <- c(yes, no)
str_detect(s, "cm") | str_detect(s, "inches")
str_detect(s, "cm|inches")

# highlight the first occurrence of a pattern
str_view(s, pattern)

# highlight all instances of a pattern
str_view_all(s, pattern)
