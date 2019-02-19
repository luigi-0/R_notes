# parsing strings with stringr
# I'll probably stick with Python's syntax, but learning is learning

library(tidyverse)
library(readr)

str_length(c('ricky bobby', "I'm a peacock! You gotta let me fly!", NA))

# combining strings
str_c('x','y')

str_c('the','car','go')

str_c('what','the', sep=', ')

# dealing with NA when combining strings
x <- c('abc', NA)

str_c('|-', x, '-|')

str_c('|-', str_replace_na(x), '-|')

name <- 'Gary'
time_of_day <- 'morning'
birthday <- FALSE

str_c(
  'Good ', time_of_day, ' ', name,
  if(birthday) ' and HAPPY BIRTHDAY',
  '.'
)

# collapsing a vector into a single string
str_c(c('x', 'y', 'z'), collapse = ', ')

# subsetting strings
x <- c('Apple', 'Banana', 'Pear')
str_sub(x, 1, 3)

str_sub(x, -3, -1)

str_sub('a', 1, 5)

# using assignment to change values of a string
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

# using regular expressions with stringr

x <- c('apple', 'banana', 'pear')

# match an exact string
str_view(x, 'an')

# match any character using '.' except \n

# match a 3 character long string where a is the middle character
str_view(x, '.a.')

# if '.' is reserved in regex for matching any character, how would you match '.'?
# you would need to \ to escape the regex, but \ is used as an escape character in strings
# think \t or \n or \s

# let's get around this issue by using the regex '\\.' to search for '.'
dot <- '\\.'
writeLines(dot)

str_view(c('abc', 'a.c', 'bef'), 'a\\.c')

x <- 'a\\b'
writeLines(x)
str_view(x,'\\\\')

# using anchors so regex search at the start or end of a string
# ^ start
# $ end

x <- c('apple', 'banana', 'pear')

# match any string that starts with an a
str_view(x, '^a')

# match any string that ends with an a
str_view(x, 'a$')

# to force a regex to match a full string use ^ and $
x <- c('apple pie', 'apple', 'apple cake')
str_view(x, 'apple')
str_view(x, '^apple$')

# other useful regex operators; remember, you'll need to escape \ so you'll type \\d for ex
# \d : matches any digit
# \s : matches any whitespace
# [abc] : matches a, b, or c
# [^abc] : matches anything except a, b, or c

# the 'or' operator | for regex, and using () to help you see the regex
str_view(c('grey', 'gray'), 'gr(e|a)y')

# repetition: how many times a pattern matches
# ? : 0 or 1
# + : 1 or more
# * : 0 or more

x <- '1888 is the longest year in Roman numerals: MDCCCLXXXVIII'
str_view(x, 'CC?')
str_view(x, 'CC+')
str_view(x, 'C[LX]+')

# specifying the number of matches precisely:
  # {n} : exactly n
  # {n,} : n or more 
  # {,m} : at most m
  # {n,m} : between n and m

str_view(x, 'C{2}')

str_view(x, 'C{2,}')

str_view(x, 'C{2,3}')

# these mathces are greedy by default, but can be restricted with '?'
# using '?' will return the shortest possible matching string
str_view(x, 'C{2,3}?')

str_view(x, 'C[LX]+?')

# although '()' can help you break-down complex expressions, '()' can be used to "define groups
# that you can refer to with backpreferences"

# this will find fruits that have a repeated PAIR of letters
str_view(fruit, '(..)\\1', match = TRUE)

# now we'll cover some stringr functions that use regex to parse strings
  # determine which strings match a pattern
  # find the positions of matches
  # extract the content of matches
  # replace matches with new values
  # split a string based on a match

# detecting matches

# this will return a logical vector
x <- c('apple', 'banana', 'pear')
str_detect(x, 'e')

# since str_detect() will return a logical vector containing 1's and 0's you can
# create some useful counts

# how many words start with t?
sum(str_detect(words, '^t'))

# what proportion of common words end with a vowel?
mean(str_detect(words, '[aeiou]$'))

# sometimes its easier to use multiple str_detect() calls with logical operators instead
# of trying to come up with one really complex regex

# find all words that don't contain any vowels: the first method looks pretty easy to get
no_vowel_1 <- !str_detect(words, '[aeiou]')
no_vowel_2 <- str_detect(words, '^[^aeiou]+$')
identical(no_vowel_1, no_vowel_2)

# let's use str_detect() to grab strings that match a regex

# find all words that end with 'x'

# with logical subsetting -- option 1
words[str_detect(words, 'x$')]

# with the handy str_subset() -- option 2
str_subset(words, 'x$')

# let's move on to a more realistic use of regex by parsing a column in a dataframe
df <- tibble(
  word = words,
  i = seq_along(word)
)

df %>% 
  filter(str_detect(words, 'x$'))

# what if you wanted a count of how many times a regex matched?
x <- c('apple', 'banana', 'pear')
str_count(x, 'a')

# you could also calculate some simple statistics with str_count()
mean(str_count(words, '[aeiou]'))

# lets fill up a dataframe with a simple counts as we parse our character column
df %>% 
  mutate(
    vowels = str_count(word, '[aeiou]'),
    consonants = str_count(word, '[^aeiou]')
  )

# note that matches never overlap
str_count('abababa', 'aba')
str_view_all('abababa', 'aba')

# extract matches
length(sentences)

head(sentences)

# suppose you wanted to find all the sentences that contain a color in them

# let's create a character vector, and then turn it into a regex so we can search for colors
colors <- c(
  'red', 'orange', 'yellow', 'green', 'blue', 'purple'
)

# turn the vector into a regex
color_match <- str_c(colors, collapse = '|')
color_match

# now we can extract; note that str() grabs only the first match
has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

# let's extract more than one match
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(more, color_match)

# this will return a list
str_extract_all(more, color_match)

# grouped matches

# find a sequence of at least one character that isn't a space
noun <- '(a|the) ([^ ]+)'

has_noun <- sentences %>% 
  str_subset(noun) %>% 
  head(10)

has_noun %>% 
  str_extract(noun)

# returns a matrix: one column for complete match and one column for each group
has_noun %>% 
  str_match(noun)

# if working with tibbles, then use ::extract
# if you want all the matches us str_match_all()
tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c('article', 'noun'), '(a|the) ([^ ]+)',
    remove = FALSE
  )

# replacing matches
x <- c('apple', 'pear', 'banana')
str_replace(x, '[aeiou]', '-')
str_replace_all(x, '[aeiou]', '-')

# you can also supply a named vector
x <- c('1 house', '2 cars', '3 people')
str_replace_all(x, c('1' = 'one', '2' = 'two', '3' = 'three'))

# replacing using backreferences
sentences %>% 
  str_replace('([^ ]+) ([^ ]+) ([^ ]+)', '\\1 \\3 \\2') %>% 
  head(5)

# splitting

# str_split return a list, but you can also use simplify = TRUE to get a mx
sentences %>% 
  head(5) %>% 
  str_split(" ")

'a|b|c|d' %>% 
  str_split('\\|') %>% 
  .[[1]]

# this is pretty neat
x <- 'This is a scentence. This is another attempt to be a better data scientist'
str_view_all(x, boundary('word'))

str_split(x, ' ')[[1]]

str_split(x, boundary('word'))[[1]]

# str_locate() finds regex for you

# you've actually been using the regex() all along, and like any function it has options
str_view(fruit, 'nana')
# what is actually going into the interpreter
str_view(fruit, regex('nana'))

# I'll skip the options it has, but its useful to know you that's what we've actually been using

