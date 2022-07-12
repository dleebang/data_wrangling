library(rvest)
library(tidyverse)

url <- "https://web.archive.org/web/20181024132313/http://www.stevetheump.com/Payrolls.htm"

h <- read_html(url)

nodes <- h %>% html_nodes("table")

class(nodes)

html_text(nodes[[1]])

html_table(nodes[[20]])


##Question 1
tab1 <- html_table(nodes[[1]])
tab2 <- html_table(nodes[[2]])
tab3 <- html_table(nodes[[3]])
tab4 <- html_table(nodes[[4]])

sapply(nodes[1:4], html_table)

tab1
tab2
tab3
tab4


##Question 2
sapply(nodes[19:21], html_table)

html_table(nodes[[length(nodes)-2]])
html_table(nodes[[length(nodes)-1]])
html_table(nodes[[length(nodes)]])


##Question 3
tab_1 <- html_table(nodes[[10]])
tab_2 <- html_table(nodes[[19]])

tab_1 <- tab_1[-1,-1]
tab_2 <- tab_2[-1,]

tab_1 <- tab_1 %>% setNames(c("Team", "Payroll", "Average"))
tab_2 <- tab_2 %>% setNames(c("Team", "Payroll", "Average"))

joined_table <- full_join(tab_1, tab_2, by = "Team")
nrow(joined_table)


#Question 4
url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
h <- read_html(url)
tab <- h %>% html_nodes("table")
length(tab)

#Question 5
sapply(tab[1:10], html_table)
