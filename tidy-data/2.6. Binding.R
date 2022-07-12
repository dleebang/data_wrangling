# Unlike the join functions, the binding functions do not try to match
# by a variable, but rather just combine datasets
# 
# bind_cols() binds two objects by making them columns in a tibble.
# The R-base function cbind() binds columns but makes a data frame or 
# matrix instead
# 
# bind_rows() binds rows instead of columns. The R-base function is rbind()
# 

## Code

bind_cols(a = 1:3, b = 4:6)
tab1 <- tab[, 1:3]
tab2 <- tab[, 4:6]
tab3 <- tab[, 7:9]
new_tab <- bind_cols(tab1, tab2, tab3)
head(new_tab)

tab1 <- tab[1:2,]
tab2 <- tab[3:4,]
bind_rows(tab1, tab2)
