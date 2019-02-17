# dyplr notes
# dyplr is all about data transformation
# Main uses of dyplr:
# sorting: arrange()
# filtering obs by their values: filter()
# picking variables: select()
# generating new variables: mutate()
# creating summary statistics: summarize()
# grouping obs in a certain way: group_by()
# renaming variables: rename()
# and other data transforming tasks

library(nycflights13)
library(tidyverse)

flights

# select only flights on jan 1 
filter(flights, month == 1, day == 1)

# select flights on christmas and store the result
dec25 <- filter(flights, month == 12, day == 25)

# A note on numerical precision in R: both evaluate to FALSE because of finite
# arithmetic. Each number displayed is an approximation
sqrt(2) ^ 2 == 2
1/49 * 49 == 1

# To deal with this:
near(sqrt(2) ^ 2, 2)
near(1 / 49 * 49, 1)

# using boolean operations to select certain rows

# selecting flights from nov or dec
filter(flights, month == 11 | month == 12)

# can also filter in the following way
nov_dec <- filter(flights, month %in% c(11,12))

# you can also use is.na() to find missing values in your data frame
filter(flights, is.na(dep_delay))

# sorting using arrange() where ascending is the default order
arrange(flights, year, month, day)

# sorting by descending
arrange(flights, desc(arr_delay))

# looking at only a few variable at a time using select()
select(flights, year, month, day)

# selecting all columns between year and day variables 
select(flights, year:day)

# selecting all columns not between year:day variables
select(flights, -(year:day))

# some functions you can use with select to fine-tune you data analysis

# use starts_with() to select all columns starting with specific string
# ends_with() and contains() work the same way
# matches() uses regular expressions to match strings 
select(flights, starts_with(('y')))

# renaming
rename(flights, tail_num = tailnum)

# rearranging column positions
select(flights, time_hour, air_time, everything())

# generating new variables
flights_sml <- select(flights,
                       year:day,
                       ends_with('delay'),
                       distance,
                       air_time
                      )
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60,
       hours = air_time / 60,
       # notice how this will access columns you just created
       gain_per_hour = gain / hours
       )

# only keeping the columns you just created
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hour)

# grouped summaries
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

# using group_by() to create some more useful statistics
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

# using pipes to reduce code and variable names
# the shortcut for the pipe is cmd+shift+m

# by using the pipe we cut down three different dataframe names 
delays <- flights %>%
  group_by(dest) %>% 
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != 'HNL')

# removing missing values using na.rm = TRUE

# look at all these missing values created by using an aggregating function
flights %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))

# using na.rm to clean up the input before using summarize()
flights %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay, na.rm = TRUE))

# there's more than one way to deal with missing values
# another way is to just filter them out prior to computing anything
not_canceled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_canceled %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))

# use counts--n()-- or a count of nonmissing values--sum(!is.na(x))-- to make
# sure you're not making big conclusions based a few observations
delays <- not_canceled %>% 
  group_by(tailnum) %>% 
  summarize(
    delay = mean(arr_delay)
  )

# this plot will show you that there are some planes with avg delays of 300 min
ggplot(delays, mapping = aes(x=delay)) +
  geom_freqpoly(binwidth = 10)

# let's dig into this a bit more
delays <- not_canceled %>% 
  group_by(tailnum) %>% 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

# this plot will show you much more variation in delays
ggplot(delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

# there are a small number of outliers that are adding some noise to the 
# graph, let's focus more on the bulk of the flights with delays
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

# there are more summary functions you can use, but I'll skip them since
# the syntax is largely the same