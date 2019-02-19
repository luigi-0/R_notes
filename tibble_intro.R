# tibbles introduction
library(tidyverse)
# tibbles are data frames, but with updated behavior
# tibbles are easier to work with

# sometimes you have to revert back to dataframes to work with older functions

# two main differences: printing and subsetting
  # tibbles only print first 10 rows and display var type
  # can override this behavior and print more info
  # tibbles allow subsetting with less code

# if you're using the tidyverse package, then you're using tibbles

# forcing a data frame into a tibble
as_tibble(iris)

# creating tibble from individual vectors
tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)

# subsetting
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# grab column x using base R
df[['x']]
# grab only column x using tibble
df $ x

