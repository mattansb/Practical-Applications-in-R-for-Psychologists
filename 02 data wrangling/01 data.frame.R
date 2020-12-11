
# Data frames -------------------------------------------------------------

# data frames are the most common way to store and work with DATA. If you're
# familiar with excel or SPSS (O`_`O), this should feel natural.
#
# In data frames, each column is a vector of some type, with (ideally) each
# vector represents a "variable", and each row represents some "observation".


# we can make a data frame with the function `data.frame()`
school_grades <- data.frame(
  names = c("Dana", "Avi", "Michal", "Asaf", "Jody", "Beth", "Moshe"),
  id = c(305850916, 381345273, 203912400, 229889795,
         304786643, 317171280, 326876070),
  sex = factor(c("F", "M", "F", "M", "F", "F", "M"),
               labels = c("female", "male")),
  math.grades = c(93, 30, NA, 88, 100, 67, 79),
  english.grades = c(100, 45, 90, 77, 88, 90, 66)
)
school_grades


# Some useful function to explore data frames:
str(school_grades)          # see data structure
head(school_grades, n = 3)  # get first few rows - useful when printing very long data frames
tail(school_grades, n = 3)  # get last few rows
ncol(school_grades)         # how many columns?
nrow(school_grades)         # how many rows?
View(school_grades)         # view it in R's viewer.



## extract & replace with [row, column]
school_grades[1, ]  # first row
school_grades[, 1]  # first column
school_grades[3, 5] # 3rd row, 5th column

# What will this do?
school_grades[c(1, 2, 3, 1, 1, 1), ]


# many ways to do the same thing...
school_grades[4, 5]
school_grades[4, english.grades]
school_grades$english.grades[4]
# school_grades[["english.grades"]][4]
# school_grades[, 5][4]
# school_grades[, "english.grades"][4]




# change and add variables
school_grades[c(2, 3, 6), 2] <- NA
school_grades$pass.english <- school_grades$english.grades >= 56
school_grades$english.grades_bonus <- school_grades$english.grades + 10
school_grades$math.grades_z <- scale(school_grades$math.grades)
school_grades



mean(school_grades$english.grades)
sd(school_grades$english.grades)





# What do these do?
school_grades[school_grades$sex == "female", c("names", "math.grades", "math.grades_z")]

school_grades[school_grades$pass.english, c("names", "english.grades")]

mean(school_grades$math.grades[school_grades$pass.english])



school_grades_clean <- na.omit(school_grades)
school_grades_clean











# The ***tidyverse***  ----------------------------------------------------

# The tidyverse is an opinionated collection of R packages designed for data
# [analysis]. All packages share an underlying design philosophy, grammar, and
# data structures - "TIDY DATA"!

## What is tidy data?
# 1. Each variable forms one column.
# 2. Each observation forms one row.




# install.packages(c("tidyverse", "haven))
library(haven) # for importing and exporting 'SPSS' file :(
library(tidyverse)
# You only need to install packages once, but you need to load them (with
# `library`) every time you open R.








# Importing data ----------------------------------------------------------


# Typically, we won't build our data frame in R - we will import data into R,
# and then manipulate it to make it compatible with our needs - modeling,
# plotting, summary tables, etc (we will learn all of these there upcoming
# weeks!)




# load a data frame
data_raw <- read.csv("data/deaf_numer.csv")

# for SPSS files
data_raw <- read_spss("data/deaf_numer.sav")


# see also the `readxl` pkg for excel files.


str(data_raw)
glimpse(data_raw) # better!


# emotional_1back:
# sID      - subject number
# nFingers - Number of stimulated fingers
# trial    - experimental trial
# block    - experimental block
# acc      - accuracy: 1 correct, 0 error
# rt       - reaction time






# Manipulating Data -------------------------------------------------------


# `dplyr` has some very useful functions for manipulating your data.
# The first argument in ALL of these functions is a data frame (e.g., data_raw)


## select columns
data_clean <- select(data_raw,
                     sID, nFingers, rt)
head(data_clean)


## filter -- selects rows:
data_clean <- filter(data_clean,
                     rt < 2500)
nrow(data_clean)
nrow(data_raw)


## mutate -- makes a new variable, or change an existing one
data_clean <- mutate(data_clean,
                     sqrt_rt = sqrt(rt), # new
                     rt = rt / 1000)     # change RT from ms to seconds
head(data_clean)


# group_by -- group data by some variable.
data_clean <- group_by(data_clean,
                       nFingers)
# This doesn't actually change the data in any way, it just lets other functions
# know that they should act on the data according to the groups.
group_keys(data_clean) # see what is grouped by


# For example, mutate():
data_clean <- mutate(data_clean,
                     rt_z = scale(rt))
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
# `dplyr` itself has some useful functions that can be used in `mutate()`
# functions (https://dplyr.tidyverse.org/reference/index.html#section-vector-functions),
# but a real powerhouse is the `sjmisc` package - see examples: http://strengejacke.de/sjmisc-cheatsheet.pdf.



## Piping with %>% ("and then") -------------------------------------------


# The aim of the pipe (%>%) is to make code more human readable.

# For example this:
sqrt(mean(c(1,2,3,4,NA), na.rm = TRUE))
# is not very readable - it is read from in -> out...


# even this (which does the same thing), isn't really readable - why are we
# reading from the inside out??? And not from left to right??
sqrt(
  mean(
    c(1,2,3,4,NA),
    na.rm = TRUE
  )
)


# But using the pipe...
c(1,2,3,4,NA) %>%
  mean(na.rm = TRUE) %>%
  sqrt()
# amazing!


# The pipe tells R: "When you're done with the stuff on the LEFT, pass the
# result to next thing on the RIGHT...".
# When reading code aloud we will say "and then".


# The pipe will always* "send" the results from the left, into the FIRST
# argument of the function on the right.
# ...unless we explicitly tell it otherwise, with the dot (`.`).
# For example:
TRUE %>%
  mean(c(1,2,3,4,NA), na.rm = .) %>%
  sqrt()



# The pipe really shines when used with functions that share the tidyverse
# philosophy. For example, because the `dplyr` function all take a *data frame*
# as the FIRST argument, and also all RETURN a data frame, we can PIPE `dplyr`
# functions:
data_clean_piped <- data_raw %>%
  select(sID, nFingers, rt) %>%
  filter(rt < 2500) %>%
  mutate(sqrt_rt = sqrt(rt),
         rt = rt / 1000) %>%
  group_by(nFingers) %>%
  mutate(rt_z = scale(rt)) %>%
  ungroup()

# This pipe does all the things we did above:
all.equal(data_clean, data_clean_piped)



# Export data -------------------------------------------------------------


# save to a `.csv` file
write.csv(data_clean_piped, file = "data_clean.csv") # read.csv() into object


# save to a `.sav` file
write_sav(data_clean_piped, path = "data_clean.sav")
# BUT WHY??????????? NOOOOOOOOOO


# save to a `.rds` file
saveRDS(data_clean_piped, file = "data_clean.Rds")
# load using readRDS() into object.
same_data <- readRDS("data_clean.Rds")
# why would you want to do this? (e.g., factors...)

# not only data frames:
xlist <- list(a = 1, b = list(b1 = c(1, 2, 3), bx = "a"))
saveRDS(xlist, file = "some list I made.Rds")









# we can also save multiple objects into `.rdata` files (Don't!!):
save(data_clean_piped, xlist, file = "selected_objects.rdata")
# Or the whole current environment (Don't!!!!)
save.image(file = "all_objects.rdata")
#
# load using load() into environment




# Exercise ----------------------------------------------------------------



data_raw <- read.csv("data/deaf_numer.csv")
# (Try to do the following with dplyr functions.)
# 1. Create a Group variable: (the RA forgot to do it...)
#        - For Subject <= 15, Group should be 1,
#        - For Subject >  15, Group should be 2.
#    TIP: use `ifelse()`
#    (see `02 control_and_functions.R` from last lesson)
# 2. remove the first, practice block (Where block == 1)
# 3. remove trials following an error
#    TIP: use `lag()`
# 4. remove error trials (where ACC == 0)
# 5. remove RTs that fall beyond +/- 2 SD from *each participant's*
#    mean in *each* of the "finger" conditions.
# 6. create the variable `vib_strength`, randomly sampled from
#    `c(soft = 0.3, strong = 1.0)`

# 7. Try doing steps 1--6 with the pipe (you can copy your solution and just
#   adjust it to work with the pipe.

# 8. Save that data to:
#        - an Rds file
#        - a csv file

# 9. Rewrite this ugly code using the pipe (%>%):
diff(range(sample(head(iris[[1]], n = 10), size = 5, replace = TRUE)))
