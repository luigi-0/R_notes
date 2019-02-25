# dealing with factors using forcats
library(tidyverse)
library(forcats)

# factors are used to deal with categorical variables-- sex, color, car make, ect.
# works similar to seaborn/pandas

# the main distinction here is that the two main parent types--numeric and character--are too
# broad when talking about data analysis, so you subgroup them-- integer, double, character, factor

# this character vector would actually be more useful to you as a factor
# for example, you can actually alphabetically sort factors
x1 <- c('Dec', 'Apr', 'Jan', 'Mar')
x2 <- c('Dec', 'Apr', 'Jam', 'Mar')
# let's turn it into a factor
month_levels <- c(
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
)

y1 <- factor(x1, levels = month_levels)
y1
sort(y1)

# using the specified levels to handle NA's
y2 <- factor(x2, levels = month_levels)
y2

factor(x1)

# when factors are stored as a tibble you can see their levels
gss_cat %>% 
  count(race)

# this is the main reason to convert your categorical vectors into factors
ggplot(gss_cat, aes(race)) +
  geom_bar()

# forcing ggplot2 to display NAs
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

# two main operations when dealing with factors are: sorting and changing values of levels

# modifying a factor to get a better read on the data
relig <- gss_cat %>% 
  group_by(relig) %>% 
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

# this plot isn't too revealing
ggplot(relig, aes(tvhours, relig)) + geom_point()

# let's sort the factors according to tvhours
ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

# a cleaner way to create the previous plot
relig %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(relig, aes(tvhours, relig) +
  geom_point()

# another plot
rincome <- gss_cat %>% 
  group_by(rincome) %>% 
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(
  rincome, 
  aes(age, fct_reorder(rincome, age))) +
    geom_point()

# reordering so colors line up with the legend
# typo in the book: supposed to count first and then group
by_age <- gss_cat %>% 
  filter(!is.na(age)) %>%
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, color = marital)) +
  geom_line(na.rm = TRUE)

ggplot(
  by_age, 
  aes(age, prop, color = fct_reorder2(marital, age, prop))
) +
  geom_line() +
  labs(color = 'marital')

# bar plots wtih factor modifications
gss_cat %>% 
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>% 
           ggplot(aes(marital)) +
           geom_bar()

# modifying factor levels allows you clean up your plots and make them look juuust right
gss_cat %>% count(partyid)

# let's expand and standardize the levels
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
    'Republican, strong'    = 'Strong republican',
    'Republican, weak'      = 'Not str republican',
    'Independent, near rep' = 'Ind,near rep',
    'Independent, near dem' = 'Ind,near dem',
    'Democrat, weak'        = 'Not str democrat',
    'Democrat, strong'      = 'Strong democrat'
)) %>% 
  count(partyid)

# grouping old levels
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
                              'Republican, strong'    = 'Strong republican',
                              'Republican, weak'      = 'Not str republican',
                              'Independent, near rep' = 'Ind,near rep',
                              'Independent, near dem' = 'Ind,near dem',
                              'Democrat, weak'        = 'Not str democrat',
                              'Democrat, strong'      = 'Strong democrat',
                              'Other'                 = 'No answer',
                              'Other'                 = "Don't know",
                              'Other'                 = 'Other party'
  )) %>% 
  count(partyid)

# collapsing levels using fct_collapse()
gss_cat %>% 
  mutate(partyid = fct_collapse(partyid,
    other = c('No answer', "Don't know", 'Other party'),
    rep = c('Strong republican', 'Not str republican'),
    ind = c('Ind,near rep', 'Independent', 'Ind,near dem'),
    dem = c('Not str democrat', 'Strong democrat')
)) %>% 
  count(partyid)

# lumping with the lumper yo!

# default behavior to is lump into two piles
gss_cat %>% 
  mutate(relig = fct_lump(relig)) %>% 
  count(relig)

# specifying how many lovely lumps you want
gss_cat %>% 
  mutate(relig = fct_lump(relig, n = 10)) %>% 
  count(relig, sort = TRUE) %>% 
  print(n = Inf)
