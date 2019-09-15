
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

# extract & replace
MemoryExp[1, ]
MemoryExp[, 1]
MemoryExp[3, 5]

MemoryExp[4, 5] # many ways to do the same thing...
MemoryExp[4, "Hit"]
MemoryExp$Hit[4]
MemoryExp[["Hit"]][4]
MemoryExp[, 5][4]
MemoryExp[, "Hit"][4]

MemoryExp[c(1,2,3), 5]
MemoryExp[c(1,2,3), 5] <- NA
MemoryExp[c(1,2,3), 5]

# new variable
MemoryExp$noise <- rnorm(nrow(MemoryExp))

mean(MemoryExp$Hit[MemoryExp$Delay == "Short"])
# we'll see next time a better, cleaner way to do this...

MemoryExp_clean <- na.omit(MemoryExp)
MemoryExp_clean_long_only <- MemoryExp_clean[MemoryExp_clean$Delay == "Long", ]

MemoryExp_clean$Hit_z <- scale(MemoryExp_clean$Hit)
mean(MemoryExp_clean$Hit_z)
sd(MemoryExp_clean$Hit_z)


# The ***tidyverse***  ----------------------------------------------------

library(tidyverse)

# Import data -------------------------------------------------------------


data_raw <- read.csv("emotional_2back.csv")   # data frame
data_raw <- read_csv("emotional_2back.csv")   # tibble - but doesn't like hebrew....

str(data_raw)
glimpse(data_raw)

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



# Tidy Data & the Pipe ----------------------------------------------------
# What is tidy data?


# `dplyr` has some very useful functions:
# the first argument in all these functions is the object name (e.g., data_raw)
# for even more functions, see the dplyr cheatsheet:
# https://www.rstudio.com/resources/cheatsheets/

# select clumuns
data_clean <- select(data_raw, Subject, Group, Block, Emotion, RT)

# filter -- selects rows:
data_clean <- filter(data_clean, RT < 4000)

# mutate -- makes a new variable, or change existing ones
data_clean <- mutate(data_clean,
                     logRT = log10(RT),
                     RT = RT / 1000)

# group_by -- group data by row value. Useful for use in combination with mutate
data_clean <- group_by(data_clean, Emotion)
data_clean <- mutate(data_clean, RT_z = scale(RT))
data_clean <- ungroup(data_clean)

View(data_clean)

# Piping with %>% (and then...)

exp(mean(c(1,2,3,4,NA), na.rm = TRUE))
c(1,2,3,4,NA) %>% mean(na.rm = TRUE) %>% exp()
TRUE %>% mean(c(1,2,3,4,NA), na.rm = .) %>% exp()

# pipe with dplyr:

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

# Outliers ----------------------------------------------------------------

# drop?
data_no_OL <- data_clean_joined %>%
  mutate(RT_z_ol_2sd = abs(RT_z) > 2) %>%
  filter(!RT_z_ol_2sd)

data_no_OL <- data_clean_joined %>%
  mutate(RT_z_ol_2sd = ifelse(abs(RT_z) > 2,NA,RT_z)) %>%
  drop_na(RT_z_ol_2sd)

# "fix"
data_winzorize_OL <- data_clean_joined %>%
  mutate(RT_clean = case_when(
    RT_z >  2 ~ max(RT_z[RT_z <= 2]),
    RT_z < -2 ~ min(RT_z[RT_z >= 2]),
    TRUE      ~ RT_z
  ))

hist(data_winzorize_OL$RT_z)
hist(data_winzorize_OL$RT_clean)


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

# Export data -------------------------------------------------------------

# save
write.csv(data_long, file = "data_long.csv") # read.csv() into object
saveRDS(data_long,"data_long.Rds") # readRDS() into object (why do this?)

save(data_long,data_wide_again,file = "selected_objects.rdata") # load() into environment
save.image(file = "all_objects.rdata") # load() into environment


# Exercise ----------------------------------------------------------------


# Prep data:
data_raw <- read_csv("emotional_2back.csv")
# 1. recode the Group variable: Subject<=30 Group=1, Subject>30 Group=2.
#    (the RA forgot to do it...)
#    TIP: use `ifelse`
# 2. remove block=1 (practice block)
# 3. remove error trials
# 4. remove trials following an error
#    TIP: use `lag`
# 5. remove RTs that fall beyond +/- 2 SD from each participant's average
#    in each (emotion*gender) condition
# 6. create the variable `delay_minutes`, randomly sampled from
#    c(short = 5, long = 60)
# 7. Save that data to an Rds file AND a csv file




