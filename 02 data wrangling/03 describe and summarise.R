library(dplyr)
library(parameters) # for kurtosis & skewness
library(summarytools) # for dfSummary

e2b_data <- read.csv("emotional_2back.csv") %>%
  mutate(Group = ifelse(Subject <= 30, 1, 2) %>% factor(),
         Subject = factor(Subject),
         Emotion = factor(Emotion),
         SameDiff = factor(SameDiff),
         Gender = factor(SameDiff))

glimpse(e2b_data)


# Describe variables ------------------------------------------------------

summary(e2b_data)

# This gives a quick and dirty summary of the passed variables:
(quick_sum <- dfSummary(e2b_data))
view(quick_sum) # lowercase "v"!




# For numeric variables, you can use `describe_distribution()` from the
# `parameters` package:
e2b_data %>%
  select(ACC, RT) %>%
  describe_distribution()




# You can also specify your own statistics / measures manually using `summarize`
# - the `summarise` is like `mutate`, but it summarieses data into a single row.
e2b_data %>%
  summarise(
    mean(RT),
    # how is this different than the previous entry?
    mean(RT[ACC == 1]),
    # you can also name results
    mACC = mean(ACC),
    RT_md = median(RT),
    RT_kurt = kurtosis(RT),
    RT_skew = skewness(RT)
  )


## (See Appendix 01 for even more options.)
## (See Appendix 02 for computing scale scores and their reliabilities.)


# By Group ----------------------------------------------------------------


# We might want to summarise separately for different groups.
# We just add `group_by()` (and `ungroup()`!).


e2b_data %>%
  group_by(Gender) %>%
  summarise(
    mACC = mean(ACC),
    maxRT = max(RT, na.rm = TRUE)
  ) %>%
  ungroup()





# This is useful for prepping data with repeated measures (e.g., computerized
# cognitive tasks):
e2b_subj_data <- e2b_data %>%
  group_by(Subject, Emotion, SameDiff) %>% # for each of...
  summarise(mRT = mean(RT[ACC == 1]),
            mACC = mean(ACC)) %>%
  ungroup()

head(e2b_subj_data, n = 12)
# This data frame is basically ready for a rm-ANOVA!
# (which we will meet near the end of the semester.)


# unfortunately we lost some columns (gender, groups) -
# but we can add them back in:
#
# 1. Make a data.frame with data we want to add:
subject_data <- e2b_data %>%
  select(Subject, Group, Gender) %>%
  distinct() # keep only unique rows!

head(subject_data)

# 2. Joint them:
e2b_subj_data <- e2b_data %>%
  group_by(Subject, Emotion, SameDiff) %>%
  summarise(mRT = mean(RT[ACC == 1]),
            mACC = mean(ACC)) %>%
  ungroup() %>%
  full_join(subject_data, by = "Subject") # JOIN!

head(e2b_subj_data)





# We can now also summarise THIS summarised data further!
e2b_subj_data %>%
  group_by(Gender, Group, Emotion, SameDiff) %>%
  summarise(mRT_M = mean(mRT),
            mRT_S = sd(mRT))





# counting subjects in each group
e2b_data %>%
  group_by(Gender, Group) %>%
  summarise(N = n_distinct(Subject)) # `n_distinct` counts unique values



# NOTE: Not all functions respect the `group_by` action - tidyverse functions
# do, and some others from other packages, but don't assume that all functions
# do! For example:
e2b_data %>%
  group_by(Gender, Group) %>%
  nrow()

e2b_data %>%
  group_by(Gender, Group) %>%
  summary()
# Here `nrow()` and `summary()` didn't react to `group_by(Gender, Group)`!!!








# Exercise ----------------------------------------------------------------

df_NPAS <- readRDS("NPAS-data_clean.Rds")
glimpse(df_NPAS)

# 1. Summarize the data in `df_NPAS` by describing the variable `Knowlage` -
#   mean, sd, and at least 2 other measures you can think of.
# 2. Repeat (1) but for EACH gender AND EACH ASD group.
# 3. The examples in "Describe variables" section support `group_by()` - try
#   them grouped by `Gender`.

