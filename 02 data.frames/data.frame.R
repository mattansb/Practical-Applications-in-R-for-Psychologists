
# Data frames -------------------------------------------------------------

df <- data.frame(x = letters[5:18],
                 y = rnorm(14),
                 z = 3)
df

# but usually...
MemoryExp <- read.csv("MemoryExp.csv")
MemoryExp <- read.csv(file.choose())
MemoryExp
str(MemoryExp)
head(MemoryExp)
tail(MemoryExp)
ncol(MemoryExp)
nrow(MemoryExp)
View(MemoryExp)
summary(MemoryExp) # more on this next lesson...
# Should subject number have a "mean"?

# extract & replace with [row, column]
MemoryExp[1, ] # first row
MemoryExp[, 1] # first column
MemoryExp[3, 5]

MemoryExp[4, 5] # many ways to do the same thing...
MemoryExp[4, Hit]
MemoryExp$Hit[4]
# MemoryExp[["Hit"]][4]
# MemoryExp[, 5][4]
# MemoryExp[, "Hit"][4]

MemoryExp[c(1,2,3), ]
MemoryExp[c(1,2,3), 5] <- NA
MemoryExp[c(1,2,3), ]

# new variable
MemoryExp$noise <- rnorm(n = nrow(MemoryExp))

MemoryExp$Hit_z <- scale(MemoryExp$Hit) # z score
mean(MemoryExp$Hit_z)
sd(MemoryExp$Hit_z)

mean(MemoryExp$Hit[MemoryExp$Delay == "Short"]) # what does this do?
# next time we'll see a better, clearer way to do this...

MemoryExp_clean <- na.omit(MemoryExp)
MemoryExp_clean_long_only <- MemoryExp_clean[MemoryExp_clean$Delay == "Long", ]

# The ***tidyverse***  ----------------------------------------------------

library(tidyverse)
library(haven) # for read_spss & write_sav

# Import data -------------------------------------------------------------


data_raw <- read.csv("emotional_2back.csv", stringsAsFactors = TRUE)   # data frame
data_raw <- read_csv("emotional_2back.csv")   # but doesn't always like hebrew....
# data_raw <- read_spss("emotional_2back.sav") # for SPSS files
# see also the readxl pkg for excel files.

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



# Tidying Data & the Pipe -------------------------------------------------
# What is tidy data?


# `dplyr` has some very useful functions:
# the first argument in all these functions is the object name (e.g., data_raw)
# for even more functions, see the dplyr cheatsheet:
# https://www.rstudio.com/resources/cheatsheets/
# However, for very large data-sets (say, more than 1,000,000 rows) you
# might want to consider the `data.table` pkg (not covered here).

# select clumuns
data_clean <- select(data_raw,
                     Subject, Group, Block, Emotion, RT)


# filter -- selects rows:
data_clean <- filter(data_clean,
                     RT < 4000)


# mutate -- makes a new variable, or change existing ones
data_clean <- mutate(data_clean,
                     logRT = log10(RT),
                     RT = RT / 1000)


# group_by -- group data by some variable.
# Useful for use in combination with mutate
data_clean <- group_by(data_clean,
                       Emotion)
group_keys(data_clean) # see what is grouped by

data_clean <- mutate(data_clean,
                     RT_z = scale(RT))

data_clean <- ungroup(data_clean) # tip: ALWAYS ungroup when you're done with grouping!
group_keys(data_clean)



View(data_clean)





# Piping with %>% ("and then...")

exp(mean(c(1,2,3,4,NA), na.rm = TRUE)) # not readable


# better...
exp(
  mean(
    c(1,2,3,4,NA),
    na.rm = TRUE
  )
)


# best!
c(1,2,3,4,NA) %>%
  mean(na.rm = TRUE) %>%
  exp()


# if not piped to the first argument, we pipe to the `.`
TRUE %>%
  mean(c(1,2,3,4,NA), na.rm = .) %>%
  exp()




# pipe with dplyr (everything we did above):
data_clean_piped <- data_raw %>%
  select(Subject, Group, Block, Emotion, RT) %>%
  filter(RT < 4000) %>%
  mutate(logRT = log10(RT),
         RT = RT / 1000) %>%
  group_by(Emotion) %>%
  mutate(RT_z = scale(RT)) %>%
  ungroup()

all.equal(data_clean, data_clean_piped)


# Join --------------------------------------------------------------------

subject_info <- read.csv("emotional_2back_sub_data.csv")
head(subject_info)

data_clean_joined <- data_clean %>%
  full_join(subject_info, by = "Subject")
head(data_clean_joined)

# Long and Wide -----------------------------------------------------------

# https://tidyr.tidyverse.org/dev/articles/pivot.html

data_wide <- read.csv("WIDE_data.csv")
head(data_wide)

# Wide to Long
data_long <- data_wide %>%
  pivot_longer(
    neg_diff:pos_same,
    names_to = "condition",
    values_to = "mRT"
  )
head(data_long) # but not TIDY


data_long_tidy <- data_wide %>%
  pivot_longer(
    neg_diff:pos_same,
    names_to = "Emotion","SameDiff",
    names_sep = "_",
    values_to = "mRT"
  )
head(data_long_tidy)

# Long to Wide
data_wide_again <- data_long_tidy %>%
  unite(col = "condition",Emotion, SameDiff) %>%
  spread(key = condition, value = mRT)

data_wide_again <- data_long_tidy %>%
  pivot_wider(
    names_from = c("Emotion","SameDiff"),
    values_from = "mRT"
  )
head(data_wide_again)

# Outliers ----------------------------------------------------------------

# drop?
data_no_OL <- data_clean_joined %>%
  mutate(RT_z_ol_2sd = abs(RT_z) > 2) %>%
  filter(!RT_z_ol_2sd)

# or
data_no_OL <- data_clean_joined %>%
  filter(abs(RT_z) <= 2)

# "fix"
data_winzorize_OL <- data_clean_joined %>%
  mutate(RT_clean = case_when(RT_z >  2 ~ max(RT_z[RT_z <= 2]),
                              RT_z < -2 ~ min(RT_z[RT_z >= 2]),
                              TRUE      ~ RT_z))

hist(data_winzorize_OL$RT_z)
hist(data_winzorize_OL$RT_clean)


# Export data -------------------------------------------------------------

# save
write.csv(data_long, file = "data_long.csv") # read.csv() into object

# or write_sav? BUT WHY??????????? NOOOOOOOOOO

saveRDS(data_long, file = "data_long.Rds") # load using readRDS() into object (why do this?)

save(data_long, data_wide_again, file = "selected_objects.rdata") # load using load() into environment
save.image(file = "all_objects.rdata") # load using load() into environment


# Exercise ----------------------------------------------------------------


# Prep data:
# 1. Rewrite this ugly code using the pipe (%>%):
diff(range(sample(head(iris$Sepal.Length, n = 10), size = 5, replace = TRUE)))

# Using the following data:
data_raw <- read_csv("emotional_2back.csv")
# 2. recode the Group variable: Subject<=30 Group=1, Subject>30 Group=2.
#    (the RA forgot to do it...)
#    TIP: use `ifelse`
#    (see last `control_and_functions.R` from last lesson)
# 3. remove the first, practice block (1)
# 4. remove trials following an error
#    TIP: use `lag`
# 5. remove error trials (codded as ACC is 0)
# 6. remove RTs that fall beyond +/- 2 SD from *each participant's* average
#    in *each* (emotion-by-gender) condition
# 7. create the variable `delay_minutes`, randomly sampled from
#    c(short = 5, long = 60)
# 8. Save that data to an Rds file AND a csv file




