# writing funciton and looping R
library(tidyverse)


# create some function

# {} will contain the body of the function
# () will contain the arguments of the function
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# call and use the function you just made
rescale01(c(0, 5, 10))

# conditional execution in R
# if (condition) {run this code} else{run this code}
# also using return() to explicitly return a value
has_name <- function(x) {
  if (x == 1) {
    print(1*5)
  } else if (x == 4) {
    return('chicken')
  } else {
    print(10)
  }
}

has_name(4)

# R is a little weird with how it uses its environment to work through funcitons

# if I ran this in python it would throw a traceback because y is not defined within
# the funciton and it is not specified as an argument
# but in R if I specify it outside the body of the function f() will work
f <- function(x) {
  x + y
}
y <- 15
f(10)

# looping over columns in a df
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# suppose you wanted to compute the median for each column

# here's one way
median(df$a)
median(df$b)
median(df$c)
median(df$d)

# but when you see that much repeated code you know that block is ripe for a loop
# the following loop is in base R and consists of 3 parts: output, sequence, and body

# initialize the vector for the loop
output <- vector("double", ncol(df))
# create the loop; seq_along() 
for (i in seq_along(df)) {
  output[[i]] <- median(df[[i]])
}
output

# with this setup you are looping over the numerical index of the columns, so
# seq_along() will create an iterator for the for loop according to how many 
# columns are in the dataframe

# remember, there's 3 ways to grab columns from a dataframe
  # [] will extract a sublist, and the result will always be a list
  # [[]] will grab a single item from a list--or column in a df
  # $ allows you to grab a named element from a list--or column from a df

# we are using [[]] for all loops to ensure it's clear we're only looping thru on column
# at a time

# modifying an existing object using loops, my dude
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
} 

# you can loop over an object in three ways
  # loop over the element: for (x in xs)
  # loop over the names: for (nm in names(xs))
    # this allows you to access the names with x[[nm]]
  # looping over numeric indexes: for (i in seq_along())

# the while loop in R
flip <- function() sample(c('T', 'H'), 1)

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == 'H') {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips

# purrr gives you some built-in looping funcitons
# map(): makes a list
# map_lgl(): makes a logical vector
# map_int(): makes an integer vector
# map_dbl(): makes a double vector
# map_chr(): makes a character vector

map_dbl(df, mean)

# when map_() fails nothing gets displayed, but there's a workaround
safe_log <- safely(log)
str(safe_log(10))

str(safe_log('a'))

# you can also use possibly() and quietly()

# you can also map over multiple objects in parallel
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)

map2(mu, sigma, rnorm, n = 5) %>% str()

# you can use pmap() to loop over a listn of arguments 

# there's more in purrr, but I'll skip it