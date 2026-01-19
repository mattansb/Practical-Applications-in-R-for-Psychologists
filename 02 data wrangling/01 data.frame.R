# Data frames -------------------------------------------------------------

# data frames are the most common way to store and work with DATA. If you're
# familiar with excel or SPSS (O`_`O), this should feel natural.
#
# In data frames, each column is a vector of some type, with (ideally) each
# vector represents a "variable", and each row represents some "observation".

# we can make a data frame with the function `data.frame()`
school_grades <- data.frame(
  names = c("Dana", "Avi", "Michal", "Asaf", "Jody", "Beth", "Moshe"),
  id = c(
    305850916,
    381345273,
    203912400,
    229889795,
    304786643,
    317171280,
    326876070
  ),
  sex = factor(c("F", "M", "F", "M", "F", "F", "M"), labels = c("F", "M")),
  math.grades = c(93, 30, NA, 88, 100, 67, 79),
  english.grades = c(100, 45, 90, 77, 88, 90, 66)
)
school_grades


# Some useful function to explore data frames:
str(school_grades) # see data structure
head(school_grades, n = 3) # get first few rows (useful when printing long dfs)
tail(school_grades, n = 3) # get last few rows
ncol(school_grades) # how many columns?
nrow(school_grades) # how many rows?
View(school_grades) # view it in R's viewer.


## extract & replace with [row, column]
school_grades[1, ] # first row
school_grades[, 1] # first column
school_grades[3, 5] # 3rd row, 5th column

# What will this do?
school_grades[c(1, 2, 3, 1, 1, 1), ]


# many ways to do the same thing...
school_grades[4, 5]
school_grades[4, "english.grades"]
school_grades$english.grades[4]
# school_grades[["english.grades"]][4]
# school_grades[, 5][4]
# school_grades[, "english.grades"][4]

# change and add variables
school_grades[c(2, 3, 6), 2] <- NA
school_grades$pass.english <- school_grades$english.grades >= 56 # is....?
school_grades$english.grades_bonus <- school_grades$english.grades + 10
# The scale() function centers and standardized (divide by the SD)
school_grades$math.grades_z <- scale(school_grades$math.grades)
school_grades


mean(school_grades$english.grades)
sd(school_grades$english.grades)

# How can we calculate the mean/SD only for those who passed the exam?

#mean(school_grades$english.grades[c(1, 3:7)])
#mean(school_grades$english.grades[school_grades$pass.english == T])

# What do these do?
school_grades[
  school_grades$sex == "F",
  c("names", "math.grades", "math.grades_z")
]

school_grades[
  school_grades$pass.english,
  c("names", "english.grades")
]
# notice: pass.english is logical!!

mean(school_grades$math.grades[school_grades$pass.english], na.rm = T)


school_grades_clean <- na.omit(school_grades) # Don't actually ever do this!!
school_grades_clean


# The ***tidyverse***  ----------------------------------------------------

#install.packages("tidyverse")
library(tidyverse)
# You only need to install packages once, but you need to load them (with
# `library`) every time you open R.

# The tidyverse is an opinionated collection of R packages designed for data
# [analysis]. All packages share an underlying design philosophy, grammar, and
# data structures - "TIDY DATA"!

## What is tidy data?
# 1. Each variable forms one column.
# 2. Each observation forms one row.

# Importing data ----------------------------------------------------------

# Typically, we won't build our data frame in R - we will import data into R,
# and then manipulate it to make it compatible with our needs - modeling,
# plotting, summary tables, etc (we will learn all of these there upcoming
# weeks!)

# load a data frame
data_raw <- read.csv("data/deaf_numer.csv")
#data_raw <- read.csv("deaf_numer.csv")

# see also the `readxl` pkg for excel files.

## How does R know where the file is? ------------------

# There are several methods for letting R know where your files are:
# 1. Using an RStudio project - when in a project, R searches within the project
#   folder.
# 2. Setting the folder R will look in (called the working directory) manually:
getwd() # Where is R looking now?
setwd("PUT HERE YOUR DESIRED PATH") # set it to something specific

#   (You might find the `here` package to be useful too.)
# 3. Giving the full file path:
data_raw <- read.csv("PUT HERE YOUR DESIRED PATH")

# You can use `choose.files()` or `choose.dir()` to interactively get the full
# path to a file or folder.
# which is the same as
fname <- file.choose() # Get the full path to the file
data_raw <- read.csv(fname, header = TRUE) # read the file in that path


str(data_raw)
glimpse(data_raw) # better!
# glimpse () it's a little like str() applied to a data frame but it tries to
# show you as much data as possible.

# emotional_1back:
# sID      - subject number
# nFingers - Number of stimulated fingers
# trial    - experimental trial
# block    - experimental block
# acc      - accuracy: 1 correct, 0 error
# rt       - reaction time

# Manipulating Data -------------------------------------------------------

library(tidyverse)

# `dplyr` has some very useful functions for manipulating your data. The first
# argument in ALL of these functions is a data frame (e.g., data_raw)

## select columns
data_clean <- select(data_raw, sID, nFingers, rt)
head(data_clean)


## filter -- selects rows:
data_clean <- filter(data_clean, rt < 2500)
nrow(data_clean)
nrow(data_raw)


## mutate -- makes a new variable, or change an existing one
data_clean <- mutate(
  data_clean,
  sqrt_rt = sqrt(rt), # new
  rt = rt / 1000 # change RT from ms to seconds
)
head(data_clean)


# group_by -- group data by some variable.
data_clean <- group_by(data_clean, nFingers)
# This doesn't actually change the data in any way, it just lets other functions
# know that they should act on the data according to the groups.
group_keys(data_clean) # see what is grouped by


# For example, mutate():
data_clean <- mutate(data_clean, rt_mean = mean(rt))
# What did this do?

## ALWAYS ungroup when you're done with grouping!
data_clean <- ungroup(data_clean)
group_keys(data_clean)


View(data_clean)


# for even more functions, see the dplyr cheatsheet:
# https://www.rstudio.com/resources/cheatsheets/
# However, for very large data-sets (say, more than 1,000,000 rows) you might
# want to consider the `data.table` or `dtplyr` packages (not covered here).

# There are many packages that can help with manipulating, recoding and
# transforming data.
#
# `dplyr` itself has some useful functions that can be used inside `mutate()`
# functions (https://dplyr.tidyverse.org/reference/index.html#vector-functions),
# and another real powerhouse is the `sjmisc` package - see examples:
# http://strengejacke.de/sjmisc-cheatsheet.pdf.

## Piping with |> ("and then") -------------------------------------------

# The aim of the pipe (|>) is to make code more human readable.

# For example this:
sqrt(mean(c(1, 2, 3, 4, NA), na.rm = TRUE))
# is not very readable - it is read from in -> out...

# even this (which does the same thing), isn't really readable - why are we
# reading from the inside out??? And not from left to right??
sqrt(
  mean(
    c(1, 2, 3, 4, NA),
    na.rm = TRUE
  )
)


# But using the pipe...
c(1, 2, 3, 4, NA) |>
  mean(na.rm = TRUE) |>
  sqrt()
# amazing!

# The pipe tells R: "When you're done with the stuff on the LEFT, pass the
# result to next thing on the RIGHT...".
# When reading code aloud we will say "and then".

# The pipe will always* "send" the results from the left, into the FIRST unnamed
# argument of the function on the right.
# If we want to send to another argument, we can use the _ placeholder:
TRUE |>
  mean(c(1, 2, 3, 4, NA), na.rm = _) |>
  sqrt()


# The pipe really shines when used with functions that share the tidyverse
# philosophy. For example, because the `dplyr` function all take a *data frame*
# as the FIRST argument, and also all RETURN a data frame, we can PIPE `dplyr`
# functions:
data_clean_piped <- data_raw |>
  select(sID, nFingers, rt) |>
  filter(rt < 2500) |>
  mutate(sqrt_rt = sqrt(rt), rt = rt / 1000) |>
  group_by(nFingers) |>
  mutate(rt_mean = mean(rt)) |>
  ungroup()


all.equal(data_clean, data_clean_piped) # test if two objects are (nearly) equal

# Sometimes you will see this type of pipe %>% - it is sort of an older version
# of the |> pipe, and in 99% of cases they both do the same thing.

# Export data -------------------------------------------------------------

# save to a `.csv` file
write.csv(data_clean_piped, file = "data_clean.csv") # read.csv() into object

# save to an R data file
saveRDS(data_clean_piped, file = "data_clean.rds") # readRDS() into object
# This format is R-specific, but it preserves more information about the data
# (e.g., factor levels, date formats, etc).
