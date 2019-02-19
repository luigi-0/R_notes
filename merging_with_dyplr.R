# relational data using dyplr
library(tidyverse)
library(nycflights13)

# dyplr's 4 main join functions are
# inner_join()
# left_join()
# right_join()
# full_join()
# by = '' is the key linking the datasets
  # can also use c('x' = 'y') to join datasets when keys are different names

# the following 4 datasets are all related via keys
airlines

airports

planes

weather

# mutating joins
# creating a narrower dataset
flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = 'carrier')
