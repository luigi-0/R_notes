# importing data with readr
library(tidyverse)
setwd("~/Documents/R-Projects/R-for_data_science/dyplyr_intro")
# here's a sampling of some of readr's functions

# read_csv()

# read_csv2() -- reads semicolon-seperated files

# read_tsv() -- read tab delim files

# read_delim() -- you specify the delim

# read_fwf() -- read fixed-width files
  # read_fwf(data, fwf_widths(args)) -- you specify the fields by widths
  # read_fwf(data, fwf_positions(args)) -- you specify the positions of the columns

# read_table() -- columns delim by white space

# look into webreadr if you get a chance

# syntax is similar for all the functions, so you learn one you learn them all
heights <- read_csv('heights.csv')

# skipping rows in order to start reading where the data starts
read_csv('the first line has info about the data
         the second line still has more metadata in it
         x, y, z
         1, 2, 3', skip = 2)

# you can also specify lines by specifying comment strings
read_csv('# something about how this data is probably interesting
         x, y, z
         1, 2, 3', comment = '#')

# sometimes people hate you, and don't include column headings
read_csv('1,2,3 \n4,5,6', col_names = FALSE)

# sometimes people really hate you, and give you useless column names
read_csv('1,2,3\n4,5,6',col_names = c('ricky','bobby','shake&bake'))

# years of debate has not fixed how people denote missing values
read_csv('a, b, c\n1,2,.', na = '.')

# readr has a parse_*() function that takes in a character vector and returns
# a logical, integer, or date vector
# this is pretty useful when dealing with dates--fred dates for example

# let's go over some parsers

# returns a real number from the string
parse_double('1.23')

# returns a number from the string by ignoring the non-numeric chars
parse_number('$100')
parse_number('10%')
parse_number('the shirt costs $12.95 my dude')

# R uses factors to represent categorical variables that are countable and finite
fruit <- c('apple', 'banana')
parse_factor(c('apple', 'banana', 'legalize ranch'), levels = fruit)

# you can also parse strings that contain encoded dates--ISO8601 (fred)
parse_date('2010-12-01')
parse_date('2018/03/12')

# you can also parse date-time, or specify your own formats if people secretly want you to die

# year: %Y(4 digits) or %y(2-digits; 00-69 -> 2000-2069, 70-99 -> 1970-1999)
# month: %m (2-digits) or %b ('jan', 'Sep') or %B ('January', 'Octoboer')
# day: %d (2-digits) or %e (optional leading space)
# I'll skip the time and non-digit formats, because even though I look like a 
# burnt chicken nugget I still love myself

# some date parsing examples
parse_date('01/02/15', '%m/%d/%y')
parse_date('01/02/15', '%d/%m/%y')
parse_date('01/02/15', '%y/%m/%d')

# readr uses the first 1000 rows and some 'heuristic' to guess what's in the column
# guess_parser() returns a guess and parse_guess() uses the guess to parse the column
guess_parser('2010-10-01')
guess_parser('15:01')
guess_parser(c('TRUE', 'FALSE'))
guess_parser(c('1', '2','8'))
guess_parser(c('12,687,874'))             

str(parse_guess('2010-10-01'))

# every parse_xyz() function has a corresponding col_xyz() function
# use parse_xyz() to when the data is in R already
# use col_xyz() when you tell readr HOW to read in the data

# let's look at a file someone might send you to ruin your day, but as always
# you find a way and persevere
challenge <- read_csv(readr_example('challenge.csv'))

# readr isn't parsing rows 1001-2000 correctly. let's look at the problems
problems(challenge)

# I'll copy and paste the column specifications from the console and modify 
# the original import by specifying the column types manually
challenge <- read_csv(
  readr_example('challenge.csv'),
  col_types = cols(
    x = col_double(),
    y = col_date()
  ))

# writing files using readr 
# write_csv(challenge, 'challenge.csv')
# write_excel_csv()
# write_rds() -- R's custom binary format
# the feather package also has a binary file format that supposedly works well everywhere

# other packages to consider
  # haven - SPSS, Stata, SAS
  # readxl - excel
  # DBI - must have RDB backend and allows you to query and return a data frame
