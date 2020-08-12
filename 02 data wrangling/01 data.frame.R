
# Data frames -------------------------------------------------------------

# data frames are the most common way to store and work with DATA. If you're
# familiar with excel or SPSS (O`_`O), this should feel natural.
#
# In data frames, each column is a vector of some type, with (ideally) each
# vector represents a "variable", and each row represents some "observation".


# we can make a data frame with the function `data.frame()`
school_grades <- data.frame(
  names = c("Dana", "Avi", "Michal", "Asaf", "Jody", "Ben", "Moshe"),
  id = c(305850916, 381345273, 203912400, 229889795, 304786643, 317171280,
         326876070),
  sex = factor(c("M", "F", "M", "F", "M", "F", "M")),
  math.grades = c(93, 30, 84, 88, 100, 67, 79),
  english.grades = c(100, 45, 90, 77, 88, 90, 66)
)
school_grades


# Some useful function to explore data frames:
str(school_grades)     # see data structure
head(school_grades)    # get first few rows - useful when printing very long data frames
tail(school_grades)    # get last few rows
ncol(school_grades)    # how many columns?
nrow(school_grades)    # how many rows?
View(school_grades)    # view it in R's viewer.
summary(school_grades) # more on this next lesson...
# Should id number have a "mean"?



## extract & replace with [row, column]
school_grades[1,]   # first row
school_grades[, 1]  # first column
school_grades[3, 5] # 3rd row, 5th column



# many ways to do the same thing...
school_grades[4, 5]
school_grades[4, english.grades]
school_grades$english.grades[4]
# school_grades[["english.grades"]][4]
# school_grades[, 5][4]
# school_grades[, "english.grades"][4]





school_grades[c(2, 3, 6), 2] <- NA
school_grades$pass.english <- school_grades$english.grades >= 56
school_grades$english.grades_bonus <- school_grades$english.grades + 10
school_grades$math.grades_z <- scale(school_grades$math.grades)
school_grades



mean(school_grades$english.grades)
sd(school_grades$english.grades)





# What do these do?
school_grades[school_grades$sex=="F", c("names", "math.grades", "math.grades_z")]

school_grades[school_grades$pass.english, c("names", "english.grades")]

mean(school_grades$math.grades[school_grades$pass.english])
# next time we'll see a better, clearer way to do this...



school_grades_clean <- na.omit(school_grades)
school_grades_clean











# The ***tidyverse***  ----------------------------------------------------

# The tidyverse is an opinionated collection of R packages designed for data
# [analysis]. All packages share an underlying design philosophy, grammar, and
# data structures - "TIDY DATA"!

## What is tidy data?
# 1. Each variable forms one column.
# 2. Each observation forms one row.




# install.packages("tidyverse")
library(tidyverse)

# You only need to install packages once, but you need to load them (with
# `library()`) every time you open R.








# Importing data ----------------------------------------------------------


# Typically, we won't build our data frame in R - we will import data into R,
# and then manipulate it to make it compatible with our needs - modeling,
# plotting, summary tables, etc (we will learn all of these there upcoming
# weeks!)




# load a data frame
data_raw <- read.csv("emotional_2back.csv")

# read_csv is often better, but doesn't always like Hebrew....
data_raw <- read_csv("emotional_2back.csv")

# for SPSS files
data_raw <- haven::read_spss("emotional_2back.sav")

# see also the `readxl` pkg for excel files.


str(data_raw)
glimpse(data_raw) # better!


# emotional_1back:
# Subject  - subject number
# Group    - 1 = low social anxiety, 2 = high social anxiety
# Block    - experimental block
# Trial    - experimental trial
# Emotion  - Condition 1: pos, neg, neu (type of emotion)
# SameDiff - Condition 2: same, different (same or different to previous trial?)
# Gender   - Condition 3: male, female (what gendered face?)
# ACC      - accuracy: 1 correct, 0 error
# RT       - reaction time






# Manipulating Data -------------------------------------------------------


# `dplyr` has some very useful functions for manipulating your data. The first
# argument in all these functions is a data frame (e.g., data_raw)


# select columns
data_clean <- select(data_raw,
                     Subject, Group:Trial, Emotion, RT)



# filter -- selects rows:
data_clean <- filter(data_clean,
                     RT < 4000)



# mutate -- makes a new variable, or change an existin one
data_clean <- mutate(data_clean,
                     sqrtRT = sqrt(RT), # new
                     RT = RT / 1000)    # change


# group_by -- group data by some variable.
# Useful for use in combination with mutate
data_clean <- group_by(data_clean,
                       Emotion)
group_keys(data_clean) # see what is grouped by


data_clean <- mutate(data_clean,
                     RT_z = scale(RT))

# ALWAYS ungroup when you're done with grouping!
data_clean <- ungroup(data_clean)
group_keys(data_clean)



View(data_clean)


# for even more functions, see the dplyr cheatsheet:
# https://www.rstudio.com/resources/cheatsheets/
# However, for very large data-sets (say, more than 1,000,000 rows) you might
# want to consider the `data.table` or `dtplyr` packages (not covered here).






# Piping with %>% ("and then") --------------------------------------------


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


# The pipe will always* "send" the results from the left, into the
# FIRST argument of the function on the right.
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
  select(Subject, Group:Trial, Emotion, RT) %>%
  filter(RT < 4000) %>%
  mutate(sqrtRT = sqrt(RT),
         RT = RT / 1000) %>%
  group_by(Emotion) %>%
  mutate(RT_z = scale(RT)) %>%
  ungroup()

# This pipe does all the things we did above:
all.equal(data_clean, data_clean_piped)











# Tidying Data ------------------------------------------------------------






## Join data frames

# Sometimes our data is split across more than one data frame. Sometimes examples:
# - Data from different sessions is stored in different files
# - Dyad data is split (mother data in one file, baby in another).
# - Data from different questionnaires / tasks is stored in separate files.

# For example, we have:
# 1. A file with performance on some task.
head(data_clean_piped)
# 2. A file with demographic info for each subject.
subject_info <- read.csv("emotional_2back_sub_data.csv")
head(subject_info)


# We can easily JOIN these data according to some key - the subject.
data_clean_joined <- data_clean %>%
  full_join(subject_info, by = "Subject")
head(data_clean_joined)







## Long and Wide data


# Most modeling functions in R take a data frame that is tidy. Unfortunately,
# this is not true for other unmentionable statistical programs...


data_wide <- read.csv("WIDE_data.csv")
head(data_wide)
# Is this data tidy? (No. Why not?)



# To make this data tidy, we need to make it LONG (it is now WIDE).
# We can do this with `pivot_longer()`:

data_long <- data_wide %>%
  pivot_longer(
    cols = neg_diff:pos_same,
    names_to = "condition",
    values_to = "mRT"
  )
head(data_long)
# Is this data tidy?




data_long_tidy <- data_wide %>%
  pivot_longer(
    neg_diff:pos_same,
    names_to = "Emotion", "SameDiff",
    names_sep = "_",
    values_to = "mRT"
  )
head(data_long_tidy)
# Is THIS data tidy?





# Sometimes we might want to take long form data and make it wide.
# We can do this with `pivot_wider()`
data_wide_again <- data_long_tidy %>%
  pivot_wider(
    names_from = c("Emotion","SameDiff"),
    values_from = "mRT"
  )
head(data_wide_again)





# Export data -------------------------------------------------------------


# save to a `.csv` file
write.csv(data_long, file = "data_long.csv") # read.csv() into object


# save to a `.sav` file
# haven::write_sav(data_long, path = "data_long.sav")
# BUT WHY??????????? NOOOOOOOOOO


# save to a `.rds` file (not only data frames)
saveRDS(data_long, file = "data_long.Rds")
# load using readRDS() into object.
#
# why would you want to do this? (e.g., factors...)





# we can also save multiple objects into `.rdata` files (Don't!):
save(data_long, data_wide_again, file = "selected_objects.rdata")
# Or the whole current environment (Don't!!)
save.image(file = "all_objects.rdata")
#
# load using load() into environment




# Exercise ----------------------------------------------------------------


# Prep data:
# 1. Rewrite this ugly code using the pipe (%>%):
diff(range(sample(head(iris[[1]], n = 10), size = 5, replace = TRUE)))



data_raw <- read_csv("emotional_2back.csv")
# (Try to do the following with dplyr functions.)
# (Try to do it all with the pipe!)
# 2. Fix the Group variable: (the RA forgot to do it...)
#        - For Subject<=30, Group=1,
#        - For Subject>30,  Group=2.
#    TIP: use `ifelse()`
#    (see `control_and_functions.R` from last lesson)
# 3. remove the first, practice block (Where Block==1)
# 4. remove trials following an error
#    TIP: use `lag()`
# 5. remove error trials (where ACC==0)
# 6. remove RTs that fall beyond +/- 2 SD from *each participant's*
#    mean in *each* of the emotion-by-gender conditions.
# 7. create the variable `delay_minutes`, randomly sampled from
#    `c(short = 5, long = 60)`
# 8. Save that data to:
#        - an Rds file
#        - a csv file




