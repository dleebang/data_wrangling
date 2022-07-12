# Use the str_detect() function to determine whether a string contains a 
# certain pattern.
# 
# Use the str_replace_all() function to replace all instances of one pattern with
# another pattern. To remove a pattern, replace with the empty string ("").
# 
# The parse_number() function removes punctuation from strings and converts
# them to numeric.
# 
# mutate_at() performs the same transformation 
# 
# 

##Code:
# murders_raw was defined in the web scraping section

# detect whether there are commas
commas <- function(x) any(str_detect(x, ","))
murders_raw %>% summarize_all(list(commas))

# replace commas with the empty string and convert to numeric
test_1 <- str_replace_all(murders_raw$population, ",", "")
test_1 <- as.numeric(test_1)

# parse_number also removes commas and converts to numeric
test_2 <- parse_number(murders_raw$population)
identical(test_1, test_2)

murders_new <- murders_raw %>% mutate_at(2:3, as.numeric)
murders_new %>% head
