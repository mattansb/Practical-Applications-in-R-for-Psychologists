library(dplyr)
library(parameters) # for kurtosis & skewness
library(summarytools) # for dfSummary

e2b_data <- readr::read_csv("emotional_2back_fixed.csv")

glimpse(e2b_data)


# Describe variables ------------------------------------------------------

summary(e2b_data)

# This gives a quick and dirty summary of the passed variables:
(quick_sum <- dfSummary(e2b_data))
view(quick_sum) # small "v"!


# You can also specify your own statistics / measures manually using
# `summarise` - the `summarise` is like `mutate`, but it summarises
# data into a single row.
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





# You can also summarise ACROSS several variables.
#
# We need to define what we want - these can be functions,
# names of functions, or a lambda.
things_I_want <- list(
  # a function
  mean = mean,
  # name of a function
  sd = "sd",
  # a lambda
  mean_no_na = ~ mean(.x, na.rm = TRUE),
  # Some more functions
  md = median,
  min = min,
  max = max,
  kurt = kurtosis,
  skew = skewness
)

# Use the `across` function:
e2b_data %>%
  summarise(across(.cols = c(RT, ACC),
                   .fns = things_I_want))



# By Group ----------------------------------------------------------------

# We might want to summarise seperatly for different groups.
# We just add `group_by` (and `ungroup`!)
e2b_data %>%
  group_by(Gender) %>%
  summarise(
    mACC = mean(ACC),
    maxRT = max(RT, na.rm = TRUE)
  ) %>%
  ungroup()





# This is useful for prepping data with repeated measures (e.g.,
# computerized cognitive tasks):
e2b_subj_data <- e2b_data %>%
  group_by(Subject, Emotion, SameDiff) %>% # for each of...
  summarise(mRT = mean(RT[ACC == 1]),
            mACC = mean(ACC)) %>%
  ungroup()

head(e2b_subj_data, n = 12)
# This data frame is basically ready for a rm-ANOVA!
# (see next semester...)


# unfortunately we lost some columns (gender, groups) - but we can
# add them
# back in:
# 1. Make df with data we want to add:
subject_data <- e2b_data %>%
  select(Subject, Group, Gender) %>%
  distinct() # keep only unique rows

head(subject_data)

# 2. Joint them:
e2b_subj_data <- e2b_data %>%
  group_by(Subject, Emotion, SameDiff) %>%
  summarise(mRT = mean(RT[ACC == 1]),
            mACC = mean(ACC)) %>%
  ungroup() %>%
  full_join(subject_data, by = "Subject")

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








# Reliability and sum / mean scores ---------------------------------------



df_NPAS <- readRDS("NPAS-data_clean.Rds")
glimpse(df_NPAS)

# Use `psych::alpha` to compute reliability
df_NPAS %>%
  select(Q1:Q26) %>%
  psych::alpha()


# Use `across` to compute sum / mean scores
df_NPAS_with_score <- df_NPAS %>%
  mutate(
    Nerdy1 = rowSums(across(Q1:Q26)),
    Nerdy2 = rowMeans(across(Q1:Q26)) # better for missing data
  ) %>%
  select(-(Q1:Q26))

head(df_NPAS_with_score)







# Exercise ----------------------------------------------------------------

# 1. Summarize the data in `df_NPAS_with_score` by describing the
#    variable `Nerdy2` - mean, sd, and at least 2 other measures you
#    can think of.
# 2. Repeat (1) but for EACH gender AND EACH ASD group.

