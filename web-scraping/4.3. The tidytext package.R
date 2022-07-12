# Continue from the previous script and case study on trump's tweets

# Now we will study how the tweets from Android and iPhone differ
# 
# To do this we will use the tidytext package. It help us convert free form text
# into a tidy table. 
# 
# 
library(tidytext)
library(textdata)

# The main function needed to convert text into a tidy table is 
# unnest_tokens(). A token refers to the units that we are considering
# to be a data point. Most common tokens will be words, but they can also be
# single chars, ngrams, sentences, lines or a pattern defind by a regex.
# The function will take a vector of strings and extract the tokens so 
# that each one gets a row in the new table. 

# An example:
example <- data_frame(line = c(1, 2, 3, 4),
                      text = c("Roses are red,", "Violets are blue,", "Sugar is sweet,", "And so are you."))
example
example %>% unnest_tokens(word, text)

# Now take a look at an example with a tweet number 3008
i <- 3008
campaign_tweets$text[i]
campaign_tweets[i,] %>% 
  unnest_tokens(word, text) %>%
  select(word)

#the function tries to convert tokens into words and strips chars important
#to twitter such as # and @. A token in twitter is not the same as in regular
#English. For this reason, instead of using a default token, words, we define
#a regex that captures twitter chars. 

# define a pattern that starts with @, # or neither, and is followed by any
# combination of letters or digits
pattern <- "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"

#now use unnest_tokens with the regex option and extract hashtags and mentions
campaign_tweets[i,] %>% 
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  select(word)

#remove links to pictures
campaign_tweets[i,] %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  select(word)

#now we are ready to extract the words for all our tweets
tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) 

#examine the most commonly used words
tweet_words %>% 
  count(word) %>%
  arrange(desc(n)) %>% 
  head(20)

#top words are not informative. The tidytext pckg has database of these
#commonly used words, which are referred to as stop words

#filter out rows representing stop words
tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word)

#we end up with a much more informative set of top 10 tweeted words
tweet_words %>% 
  count(word) %>%
  top_n(10, n) %>%
  mutate(word = reorder(word, n)) %>%
  arrange(desc(n))

#some resulting words reveals a couple of unwanted characteristics in our
#tokens. Some of our tokens are just numbers (years for example). We want
#to remove these and use the regex ^\\d+$. Second, some of our tokens
#come from a quote and they star with '. We want to remove it and when it's
#at the start of a word, so we will use str_replace(). 
tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word &
           !str_detect(word, "^\\d+$")) %>%
  mutate(word = str_replace(word, "^'", ""))

#now we can start exploring the use of Android and iPhone
#for each word we want to know if it is more likely to come from an Android
#tweet or an iPhone tweet. We previously introduced the ODDS RATION, a summary
#statistic useful for quantifying these differences. For each device and a given
#word, let's call it y, We compute the odds or the ratio between the proportion of 
#words that are y and not y and compute the ratio of those odds. We will have
#many proportions that are 0, so we use the 0.5 correction.

android_iphone_or <- tweet_words %>%
  count(word, source) %>%
  spread(source, n, fill = 0) %>%
  mutate(or = (Android + 0.5) / (sum(Android) - Android + 0.5) / 
           ( (iPhone + 0.5) / (sum(iPhone) - iPhone + 0.5)))

android_iphone_or %>% arrange(desc(or)) %>% head
android_iphone_or %>% arrange(or) %>% head

#given that several of these words are overall low frequency words, we can
#impose a filter based on the total frequency like this
android_iphone_or %>% filter(Android+iPhone > 100) %>%
  arrange(desc(or)) %>% head

android_iphone_or %>% filter(Android+iPhone > 100) %>%
  arrange(or) %>% head

#we already see somewhat of a pttern in the types of words that are being 
#tweeted more in one device versus the other. But we are intested in the
#tone rather than in specific words. Now we will examing sentiment analysis
#such as anger, fear, joy and surprise in the use of those words.