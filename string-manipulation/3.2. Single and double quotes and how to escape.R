# Define a string by surrounding text with either single quotes or double quotes
# 
# To include a single quote inside a string, use double quotes on the outside.
# To include a double quote inside a string, use single quotes on the outside.
# 
# The cat() function displays a string as it is represented inside R.
# 
# TO include a double quote inside of a string surrounded by double quotes, use the
# backslash (\) to escape the double quote. Escape a single quote to include it
# inside of a string defined by single quotes.
# 

## Code
s <- "Hello!"    # double quotes define a string
s <- 'Hello!'    # single quotes define a string
s <- `Hello`    # backquotes do not

s <- "10""    # error - unclosed quotes " 
s <- '10"'    # correct

# cat shows what the string actually looks like inside R
cat(s)

s <- "5'"
cat(s)

# to include both single and double quotes in string, escape with \
s <- '5'10"'    # error
s <- "5'10""    # error

s <- '5\'10"'    # correct
cat(s)

s <- "5'10\""  # correct
cat(s)
