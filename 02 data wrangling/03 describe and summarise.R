library(dplyr)
library(datawizard) # for kurtosis & skewness
library(summarytools) # for dfSummary

deaf_numer_sinfo <- read.csv("data/deaf_numer_sinfo.csv")

deaf_numer <- read.csv("data/deaf_numer.csv") |>
  full_join(deaf_numer_sinfo, by = "sID")

glimpse(deaf_numer)


# Describe variables ------------------------------------------------------

summary(deaf_numer)

# This gives a quick and dirty summary of the passed variables:
(quick_sum <- dfSummary(deaf_numer))
view(quick_sum) # lowercase "v"!




# For numeric variables, you can use `describe_distribution()` from the
# `datawizard` package:
deaf_numer |>
  select(acc, rt) |>
  describe_distribution()



# You can also specify your own statistics / measures manually using `summarize`
# - the `summarise` is like `mutate`, but it summarises data into a single row.
deaf_numer |>
  summarise(
    mean(rt),
    # how is this different than the previous entry?
    mean(rt[acc == 1]),
    # you can also name results
    mACC = mean(acc),
    RT_md = median(rt),
    RT_kurt = kurtosis(rt),
    RT_skew = skewness(rt)
  )

# we can test the kurtosis or skewness with the summary function:
summary(skewness(deaf_numer$age), test = TRUE)
summary(kurtosis(deaf_numer$age), test = TRUE)
# We can see that in R some functions do different things depending on their
# input.



## (See Appendix 01 for even more options.)
## (See Appendix 02 for computing scale scores and their reliabilities.)


# By Group ----------------------------------------------------------------


# We might want to summarise separately for different groups.
# We just add `group_by()` (and `ungroup()`!).


deaf_numer |>
  group_by(Group) |>
  summarise(
    mACC = mean(acc),
    maxRT = max(rt, na.rm = TRUE)
  ) |>
  ungroup()





# This is useful for prepping data with repeated measures (e.g., computerized
# cognitive tasks):
deaf_numer_subjsumm <- deaf_numer |>
  group_by(sID, nFingers) |> # for each of...
  summarise(
    mRT = mean(rt[acc == 1]),
    mACC = mean(acc)
  ) |>
  ungroup()

head(deaf_numer_subjsumm, n = 12)
# This data frame is basically ready for a rm-ANOVA!
# (which we will meet near the end of the semester.)


# unfortunately we lost some columns (sex, age, Group) -
# but we can add them back in:
deaf_numer_subjsumm <- deaf_numer |>
  group_by(sID, nFingers) |> # for each of...
  summarise(
    mRT = mean(rt[acc == 1]),
    mACC = mean(acc)
  ) |>
  ungroup() |>
  full_join(deaf_numer_sinfo, by = "sID") # JOIN!

head(deaf_numer_subjsumm, n = 12)





# We can now also summarise THIS summarised data further!
deaf_numer_subjsumm |>
  group_by(Group, nFingers) |>
  summarise(
    mRT_M = mean(mRT),
    mRT_S = sd(mRT)
  ) |>
  ungroup()





# counting subjects in each group
deaf_numer_subjsumm |>
  group_by(sex, Group) |>
  summarise(
    N = n_distinct(sID) # `n_distinct` counts unique values
  ) |>
  ungroup()


# NOTE: Not all functions respect the `group_by` action - tidyverse functions
# do, and some others from other packages, but don't assume that all functions
# do! For example:
deaf_numer |>
  group_by(sex, Group) |>
  nrow()

deaf_numer |>
  group_by(sex, Group) |>
  summary()
# Here `nrow()` and `summary()` didn't react to `group_by(sex, Group)`!!!








# Exercise ----------------------------------------------------------------

df_NPAS <- read.csv("data/NPAS data.csv")
glimpse(df_NPAS)

# 1. Summarize the data in `df_NPAS` by describing the variable `familysize` -
#   mean, sd, and at least 2 other measures you can think of.
# 2. Repeat question 1 but for EACH gender AND EACH ASD group.
# 3. The examples in the "Describe variables" section support `group_by()` - try
#   them grouped by `sex`.

