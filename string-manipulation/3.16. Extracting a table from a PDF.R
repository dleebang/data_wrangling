library(dslabs)
data("research_funding_rates")
research_funding_rates #data extract from a paper


## Code
#extracting data from PDF
install.packages("pdftools")
library("pdftools")
temp_file <- tempfile()
url <- "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
download.file(url, temp_file) #download file provided by the url in temp_file
txt <- pdf_text(temp_file)
file.remove(temp_file)

#examining the object txt gives a char vector with an entry for each page
txt

#keep only the page we want
raw_data_research_funding_rates <- txt[2]

#examine the object
raw_data_research_funding_rates %>% head

#we see that each line on the page (including table rows), is separated by
#\n (new line symbol)

#we can therefore create a list withe the \n as elements for separate:
tab <- str_split(raw_data_research_funding_rates, "\n")

#we started off with just one element in the string, we end up with a list
#with just one entry:
tab <- tab[[1]]

#examine the object, we see the column names is the third and fourth entries
tab %>% head

the_names_1 <- tab[3]
the_names_2 <- tab[5]

#we want to create one vector with one name for each column
#fisrt line:
the_names_1

#remove leading space and everything following the comma
#obtain elements by splitting using the space
#split only when there are 2 or more spaces to avoid splitting success rate
the_names_1 <- the_names_1 %>%
  str_trim() %>%
  str_replace_all(",\\s.", "") %>%
  str_split("\\s{2,}", simplify = TRUE)
the_names_1

#second line:
the_names_2

#trim leading space and then split by space
the_names_2 <- the_names_2 %>%
  str_trim() %>%
  str_split("\\s+", simplify = TRUE)
the_names_2

#Join these to generate one name for each column
tmp_names <- str_c(rep(the_names_1, each = 3), the_names_2[-1], sep = "_")

the_names <- c(the_names_2[1], tmp_names) %>%
  str_to_lower() %>%
  str_replace_all("\\s", "_")
the_names

#Now get the actual data, by examining the tab ojbect, we notice
#the information is in lines 6 through 14
tab
new_research_funding_rates <- tab[6:14] %>%
  str_trim %>%
  str_split("\\s{2,}", simplify = TRUE) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  setNames(the_names) %>%
  mutate_at(-1, parse_number)
new_research_funding_rates %>% head()