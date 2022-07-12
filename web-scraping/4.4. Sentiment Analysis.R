# In sentiment analysis, we assign a word to onr or more sentiment. Although
# this approach will miss context dependent sentiments, such as sarcasm, when
# performed on large number of words, summaries can provide insights.
# 
# The first step is to assign sentiment to each word. 
# 

sentiments

# There are several lexicons in the tidytext package that give different sentiments
# For example, the bnig lexicon divides words into positive and negative

get_sentiments("bing")

# The afinn lexicon assigns a score btw -5 and 5, with -5 most negative and
# 5 the most positive

get_sentiments("afinn")

# The loughran and nrc lexicons provide several different sentiments

get_sentiments("loughran") %>% count(sentiment)
get_sentiments("nrc") %>% count(sentiment)

# we will use the nrc lexicon
nrc <- get_sentiments("nrc") %>%
  select(word, sentiment)


# We can combine tweet words and sentiments using inner_join(), which will
# only keep words associated with a sentiment. 
# 10 random words extracted from the tweets
tweet_words %>% inner_join(nrc, by = "word") %>% 
  select(source, word, sentiment) %>% sample_n(10)


# we will count and compare the frequencies of each sentiment that appears
# for each device
sentiment_counts <- tweet_words %>%
  left_join(nrc, by = "word") %>%
  count(source, sentiment) %>%
  spread(source, n) %>%
  mutate(sentiment = replace_na(sentiment, replace = "none"))
sentiment_counts


# because more words were used on the android and on the iphone:
tweet_words %>% group_by(source) %>% summarize(n = n())


# for each sentiment we can compute th odds of being in the device:
# proportion of words with sentiment vs. proportion of words w/o and then
# compute the odds ratio comparing the two devices. 
sentiment_counts %>%
  mutate(Android = Android / (sum(Android) - Android) , 
         iPhone = iPhone / (sum(iPhone) - iPhone), 
         or = Android/iPhone) %>%
  arrange(desc(or))

# the largest three sentiments are disgust, anger and negative. But 
# are they statistically significant? How does it compare if we just
# assign sentiments at random?
# To answer that question we can compute, for each sentiment, and odds ratio
# and confidence interval

# Form a two-by-two table and the odds ratio
library(broom)
log_or <- sentiment_counts %>%
  mutate( log_or = log( (Android / (sum(Android) - Android)) / (iPhone / (sum(iPhone) - iPhone))),
          se = sqrt( 1/Android + 1/(sum(Android) - Android) + 1/iPhone + 1/(sum(iPhone) - iPhone)),
          conf.low = qnorm(1 - 0.975, log_or, se),
          conf.high = qnorm(0.975, log_or, se)) %>%
  arrange(desc(log_or))

log_or

# A graphical visualization shows some sentiments that are clearly overrepresented:
log_or %>%
  mutate(sentiment = reorder(sentiment, log_or)) %>%
  ggplot(aes(x = sentiment, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point(aes(sentiment, log_or)) +
  ylab("Log odds ratio for association between Android and sentiment") +
  coord_flip() 

# we see that disgust, anger, negative, sadness and fear sentiments are
# associated with the Android in a way that is hard to explain by chance alone.
# Words not associated with a sentiment were strongly associated with the
# iPhone source.

# if we are interest in exploring which specific words are driving these
# differences, we can go back to our androi_iphone_or object:
android_iphone_or %>% inner_join(nrc) %>%
  filter(sentiment == "disgust" & Android + iPhone > 10) %>%
  arrange(desc(or))

# we can visualize graphically:
android_iphone_or %>% inner_join(nrc, by = "word") %>%
  mutate(sentiment = factor(sentiment, levels = log_or$sentiment)) %>%
  mutate(log_or = log(or)) %>%
  filter(Android + iPhone > 10 & abs(log_or)>1) %>%
  mutate(word = reorder(word, log_or)) %>%
  ggplot(aes(word, log_or, fill = log_or < 0)) +
  facet_wrap(~sentiment, scales = "free_x", nrow = 2) + 
  geom_bar(stat="identity", show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 