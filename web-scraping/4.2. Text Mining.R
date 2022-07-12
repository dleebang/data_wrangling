# The tidytext package helps us convert free form text into a tidy table
# 
# Use unnest_tokens() to extract individual words and other meaningful chunks
# of text
# 
# Sentiment analysis assigns emotions or a positive/negative score to tokens.
# You can extract sentiments using get_sentiments(). Common lexicons for sentiment
# analysis are "bing", "affin", "nrc", and "loughran".
# 
#

## Case study: Trump Tweets
## Code
library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidyr)
library(scales)
set.seed(1)

# we can extract data directly from tweeter using the rtweet package
# but in this case, data is already compiled at https://www.thetrumparchive.com/
url <- 'https://drive.google.com/file/d/16wm-2NTKohhcA26w-kaWfhLIGwl_oX95/view'

trump_tweets <- map(2009:2017, ~sprintf(url, .x)) %>%
  map_df(jsonlite::fromJSON, simplifyDataFrame = TRUE) %>%
  filter(!is_retweet & !str_detect(text, '^"')) %>%
  mutate(created_at = parse_date_time(created_at, orders = "a b! d! H!:M!:S! z!* Y!", tz="EST"))

#result of the code above already in dslabs pckg
library(dslabs)
data("trump_tweets")

head(trump_tweets)

names(trump_tweets)

#you can call a help file to see details of each variable
?trump_tweets 

#tweets are represented by text variable
trump_tweets %>% select(text) %>% head 

#source tells us the device used to composed and upload each tweet
trump_tweets %>% count(source) %>% arrange(desc(n)) 

#use extract to remove the twitter part of the source and filter out retweets
trump_tweets %>% 
  extract(source, "source", "Twitter for (.*)") %>%
  count(source) 

#define tweets btw Trump announcement of his campaign and election day
campaign_tweets <- trump_tweets %>% 
  extract(source, "source", "Twitter for (.*)") %>%
  filter(source %in% c("Android", "iPhone") &
           created_at >= ymd("2015-06-17") & 
           created_at < ymd("2016-11-08")) %>%
  filter(!is_retweet) %>%
  arrange(created_at)

#use data visualization to explore the possibility that two diff groups
#were tweeting from these devices. for each tweet, we will extract hour in the
#east coast (EST), and then compute proportion of tweets tweeted at each
#hour for each device
ds_theme_set()
campaign_tweets %>%
  mutate(hour = hour(with_tz(created_at, "EST"))) %>%
  count(source, hour) %>%
  group_by(source) %>%
  mutate(percent = n / sum(n)) %>%
  ungroup %>%
  ggplot(aes(hour, percent, color = source)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Hour of day (EST)",
       y = "% of tweets",
       color = "")
