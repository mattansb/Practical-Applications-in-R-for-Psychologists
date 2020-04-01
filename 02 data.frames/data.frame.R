
# Data frames -------------------------------------------------------------

# data frames are the most common way to store data. If you're familiar
# with excel or SPSS (O`_`O), this should feel natural.
#
# In data frames, each column is a vector of some type.
# Ideally, each vector represents a "variable", and each row represents
# some "observation".


# we can mae a data frame with the function `data.frame()`
df <- data.frame(x = letters[5:18],
                 y = rnorm(14),
                 z = 3)
df

# But usually we will import some data
MemoryExp <- read.csv("MemoryExp.csv")
MemoryExp <- read.csv(file.choose()) # don't
MemoryExp



# some functions that work on data frames:
str(MemoryExp)
head(MemoryExp)
tail(MemoryExp)
ncol(MemoryExp)
nrow(MemoryExp)
View(MemoryExp)
summary(MemoryExp) # more on this next lesson...
# Should subject number have a "mean"?



## extract & replace with [row, column]
MemoryExp[1,] # first row
MemoryExp[, 1] # first column
MemoryExp[3, 5]

MemoryExp[4, 5] # many ways to do the same thing...
MemoryExp[4, Hit]
MemoryExp$Hit[4]
# MemoryExp[["Hit"]][4]
# MemoryExp[, 5][4]
# MemoryExp[, "Hit"][4]

MemoryExp[c(1, 2, 3),]
MemoryExp[c(1, 2, 3), 5] <- NA
MemoryExp[c(1, 2, 3),]




## Add a new variable
MemoryExp$noise <- rnorm(n = nrow(MemoryExp))
MemoryExp$Hit_z <- scale(MemoryExp$Hit) # z score
mean(MemoryExp$Hit_z)
sd(MemoryExp$Hit_z)



# what does this do?
mean(MemoryExp$Hit[MemoryExp$Delay == "Short"])
# next time we'll see a better, clearer way to do this...



MemoryExp_clean <- na.omit(MemoryExp)
MemoryExp_clean_long_only <-
  MemoryExp_clean[MemoryExp_clean$Delay == "Long",]




# The ***tidyverse***  ----------------------------------------------------

# The tidyverse is an opinionated collection of R packages designed for
# data [analysis]. All packages share an underlying design philosophy,
# grammar, and data structures.

library(tidyverse)
library(haven) # for `read_spss` & `write_sav`



# Import data -------------------------------------------------------------

# load a data frame
data_raw <- read.csv("emotional_2back.csv", stringsAsFactors = FALSE)

# read_csv is often better, but doesn't always like hebrew....
data_raw <- read_csv("emotional_2back.csv")
# data_raw <- read_spss("emotional_2back.sav") # for SPSS files
# see also the `readxl` pkg for excel files.


str(data_raw)
glimpse(data_raw) # better!


# emotional_1back:
# Subject  - subject number
# Group    - 1 = low social anxiety, 2 = high social anxiety
# Block    - experimental block
# Trial    - experimental trial
# Emotion  - pos, neg, neu
# ACC      - accuracy: 1 correct, 0 error
# RT       - reaction time
# SameDiff - correct response: same, different
# Gender   - male, female




# Manipulating and Tidying Data -------------------------------------------


## What is tidy data?
# 1. Each variable forms one column.
# 2. Each observation forms one row.


# `dplyr` has some very useful functions for manipulating your data.
# The first argument in all these functions is the data frame object
# (e.g., data_raw)


# select columns
data_clean <- select(data_raw,
                     Subject, Group:Trial, Emotion, RT)



# filter -- selects rows:
data_clean <- filter(data_clean,
                     RT < 4000)



# mutate -- makes a new variable, or change an existin one
data_clean <- mutate(data_clean,
                     logRT = log10(RT), # new
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
# However, for very large data-sets (say, more than 1,000,000 rows) you
# might want to consider the `data.table` pkg (not covered here).





# Piping with %>% ("and then...") -----------------------------------------

# The aim of the pipe (%>%) is to make code more readable.

# For example this:
exp(mean(c(1,2,3,4,NA), na.rm = TRUE))
# not readable


# even this, isn't really readable - why are we reading from the inside
# out??? And on from left to right?
exp(
  mean(
    c(1,2,3,4,NA),
    na.rm = TRUE
  )
)

# But using the pipe...
c(1,2,3,4,NA) %>%
  mean(na.rm = TRUE) %>%
  exp()
# amazing!


# The pipe tells R:
# "When you're done with the stuff on the left, do the stuff on the
# right...". When reading code aloud we will say "and then".


# The pipe will always* "send" the results from the left, into the
# first argument of the function on the right.

# * unless we explicitly tell it otherwise, with the dot (`.`).
# For example:
TRUE %>%
  mean(c(1,2,3,4,NA), na.rm = .) %>%
  exp()



# The pipe really shines when used with functions that share the
# tidyverse philosophy. For example, because the `dplyr` function all
# take a data frame as the first argument, and all reaturn a data frame,
# we can PIPE `dplyr` functions.
data_clean_piped <- data_raw %>%
  select(Subject, Group, Block, Emotion, RT) %>%
  filter(RT < 4000) %>%
  mutate(logRT = log10(RT),
         RT = RT / 1000) %>%
  group_by(Emotion) %>%
  mutate(RT_z = scale(RT)) %>%
  ungroup()

# This pipe does all the things we did above:
all.equal(data_clean, data_clean_piped)















# Join --------------------------------------------------------------------

# Sometimes our data is split across more than one data frame.
# For example, we have:
# 1. A file with performance on some task.
head(data_clean_piped)
# 2. A file with demographic info for each subject.
subject_info <- read.csv("emotional_2back_sub_data.csv")
head(subject_info)


# We can JOIN there data according to some key - the subject.
data_clean_joined <- data_clean %>%
  full_join(subject_info, by = "Subject")
head(data_clean_joined)






# Long and Wide -----------------------------------------------------------


# Most modelling fucntions in R take a data frame that is tidy.
# Unfortunately, this is not true for other unmentionable statistical
# programs...

data_wide <- read.csv("WIDE_data.csv")
head(data_wide)
# Is this data tidy? (No. Why not?)



# To make this data tidy, we need to make it LONG (it is now WIDE).


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
# write_sav(data_long, path = "data_long.sav")
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
# 2. recode the Group variable: (the RA forgot to do it...)
#        - For Subject<=30, Group=1,
#        - For Subject>30,  Group=2.
#    TIP: use `ifelse`
#    (see last `control_and_functions.R` from last lesson)
# 3. remove the first, practice block (Where Block=1)
# 4. remove trials following an error
#    TIP: use `lag`
# 5. remove error trials (where ACC=0)
# 6. remove RTs that fall beyond +/- 2 SD from *each participant's*
#    average in *each* (emotion-by-gender) condition.
# 7. create the variable `delay_minutes`, randomly sampled from
#    `c(short = 5, long = 60)`
# 8. Save that data to:
#        - an Rds file
#        - a csv file




