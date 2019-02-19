# intro tidy data; basically data that's clean and easy to analyze
library(tidyverse)

# this is tidy data
table1

# what if some of your columns contain values of variables instead of column name?
# sound familiar?
table4a

# let's gather those columns into a new pair of variables
table4a %>% 
  gather('1999', '2000', key = 'year', value = 'cases')

# what if your observations are scattered over multiple rows
table2

# let's use spread to clean this up
table2 %>% 
  spread(key = type, value = count)

# using seperate to split up columns

# notice how rate contains two set of values seperated by a '/'
table3

table3 %>% 
  # separate() will split up the data when it finds the first non-numeric character
  # you can specify which separator to look for by sep = '' if you want
  separate(rate, into = c('cases', 'population'))

# notice that cases and population are still character; we can fix that
table3 %>% 
  separate(rate, into = c('cases', 'population'), convert = TRUE)

# you can also separate integer values according to position
table3 %>% 
  separate(year, into = c('century', 'year'), sep = 2)

# using unite() to stitch together columns
table5

# let's stitch century and year together
table5 %>% 
  unite(year, century, year)

# well, there's an undersore that I don't want; get rid of it
table5 %>% 
  unite(year, century, year, sep = '')
