# By default, set operators in R-base work on vectors. If tidyverse/dplyr are
# loaded, they also work on data frames
# 
# You can take intersections of vectors using intersection(), returning
# the elements common to both sets
# 
# You can take the union of vectors using union(), returning the elements
# that are in either set.
# 
# The set difference between a first and second argument can be obtained
# with setdiff(). This function is not symmetric
# 
# The function set_equal() tells us if two sets are the same, regardless of 
# the order of the elements.
# 

## Code
# intersect vectors or data frames
intersect(1:10, 6:15)
intersect(c("a","b","c"), c("b","c","d"))
tab1 <- tab[1:5,]
tab2 <- tab[3:7,]
intersect(tab1, tab2)

# perform a union of vectors or data frames
union(1:10, 6:15)
union(c("a","b","c"), c("b","c","d"))
tab1 <- tab[1:5,]
tab2 <- tab[3:7,]
union(tab1, tab2)

# set difference of vectors or data frames
setdiff(1:10, 6:15)
setdiff(6:15, 1:10)
tab1 <- tab[1:5,]
tab2 <- tab[3:7,]
setdiff(tab1, tab2)

# setequal determines whether sets have the same elements, regardless of order
setequal(1:5, 1:6)
setequal(1:5, 5:1)
setequal(tab1, tab2)
