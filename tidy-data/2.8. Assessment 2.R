install.packages("Lahman")
library(Lahman)

Batting

top <- Batting %>% 
  filter(yearID == 2016) %>%
  arrange(desc(HR)) %>%    # arrange by descending HR count
  slice(1:10)    # take entries 1-10
top %>% as_tibble()

Master %>% as_tibble()


top_names <- top %>% left_join(Master) %>%
  select(playerID, nameFirst, nameLast, HR)


head(Salaries)

top_salary <- Salaries %>% filter(yearID == 2016) %>%
  right_join(top_names) %>%
  select(nameFirst, nameLast, teamID, HR, salary)

head(AwardsPlayers)

AwardsPlayers %>% filter(yearID == 2016) %>%
  right_join(top_names)

AwardsPlayers %>% filter(yearID == 2016) %>%
  left_join(top_names) %>% filter(is.na(HR)) %>% distinct(playerID)


