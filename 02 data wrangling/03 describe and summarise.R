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
# - `summarize` is like `mutate`, but it summarizes data into a single row.
deaf_numer |>
  summarize(
    mean(rt),
    # how is this different than the previous entry?
    mean(rt[acc == 1]),
    # you can also name results
    mACC = mean(acc),
    RT_md = median(rt, na.rm = T),
    RT_kurt = kurtosis(rt), # a measure of the peakedness of the data distribution
    RT_skew = skewness(rt) # a measure of symmetry
  )

## (See Appendix 01 for even more options.)
## (See Appendix 02 for computing scale scores and their reliabilities.)

# By Group ----------------------------------------------------------------

# We might want to summarize separately for different groups.
# We just add `group_by()` (and `ungroup()`!).

head(deaf_numer)

deaf_numer |>
  group_by(Group) |>
  summarize(
    mACC = mean(acc),
    maxRT = max(rt, na.rm = TRUE)
  ) |>
  ungroup()


# This is useful for prepping data with repeated measures (e.g., computerized
# cognitive tasks):
deaf_numer_subjsumm <- deaf_numer |>
  group_by(sID, nFingers) |> # for each of...
  summarize(mRT = mean(rt[acc == 1]), mACC = mean(acc)) |>
  ungroup()

head(deaf_numer_subjsumm, n = 12)
# This data frame is basically ready for a rm-ANOVA!
# (which we will meet near the end of the semester.)

# unfortunately we lost some columns (sex, age, Group) -
# but we can add them back in:
deaf_numer_subjsumm <- deaf_numer |>
  group_by(sID, nFingers) |> # for each of...
  summarize(mRT = mean(rt[acc == 1]), mACC = mean(acc)) |>
  ungroup() |>
  full_join(deaf_numer_sinfo, by = "sID") # JOIN!

head(deaf_numer_subjsumm, n = 12)


# We can now also summarize THIS summarized data further!
deaf_numer_subjsumm |>
  group_by(Group, nFingers) |>
  summarize(mRT_M = mean(mRT), mRT_S = sd(mRT)) |>
  ungroup()


# counting subjects in each group
deaf_numer_subjsumm |>
  group_by(sex, Group) |>
  summarize(N = n_distinct(sID)) |> # `n_distinct` counts unique values
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
