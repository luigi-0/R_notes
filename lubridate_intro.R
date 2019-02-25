# dates and times with lubridate
library(tidyverse)
library(lubridate)
library(nycflights13)

# today's date
today()

# date-time right now
now()

# getting dates from strings using lubridate
ymd('2017-01-31')

mdy('January 31st, 2017')

dmy('31-Jan-2017')

# these functions also work with integers
ymd(20170131)

# what if your date var is spread out across columns
flights %>% 
  select(year, month, day, hour, minute)

flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(
    departure = make_datetime(year, month, day, hour, minute)
  )

# let's grab the hour and minute from the time var using mod arithmetic
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %/% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(
      year, month, day, sched_dep_time
    ),
    sched_arr_time = make_datetime_100(
      year, month, day, sched_arr_time
    )
  ) %>% 
  select(origin, dest, ends_with('delay'), ends_with('time'))

flights_dt

# visualize  distribution of departure times
flights_dt %>% 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 86400) # there's 86400 seconds in 1 day

# what about a single day
flights_dt %>%
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 600) # 600 seconds = 10 minutes

# switching between date-time and a date
as_datetime(today())

as_date(now())

# converting time stored in Unix Epoch format
as_datetime(60 * 60 *10)

as_date(365 * 10 + 2)

# grabbing indiv components of a datetime
datetime <- ymd_hms('2016-07-08 12:43:56')

year(datetime)

month(datetime)

mday(datetime)

yday(datetime)

wday(datetime)

# can also display the label
month(datetime, label = TRUE)

wday(datetime, label = TRUE, abbr = FALSE)

flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()
