library(dplyr)
library(parameters) # for kurtosis & skewness
library(summarytools) # for dfSummary

e2b_data <- read.csv("emotional_2back_fixed.csv")

glimpse(e2b_data)


# Describe variables ------------------------------------------------------

# This gives a quick and dirty summary of the passed variables:
(quick_sum <- dfSummary(e2b_data))
view(quick_sum) # small "v"!

# You can also specify your own statistics / measures manually:
e2b_data %>%
  summarise(mean(RT),
            # how is this different than the previous entry?
            mean(RT[ACC == 1]),
            # you can also name results
            mACC = mean(ACC),
            median(RT),
            kurtosis(RT), skewness(RT),
            min(RT),
            max(RT))

# By Group ----------------------------------------------------------------

e2b_data %>%
  group_by(Gender) %>%
  summarise(mean(RT),
            mean(RT[ACC == 1]),
            mACC = mean(ACC),
            median(RT),
            kurtosis(RT), skewness(RT),
            min(RT),
            max(RT),
            RT_range = range(RT))


data_summed_by_subject <- e2b_data %>%
  group_by(Subject, Emotion, SameDiff) %>%
  summarise(mRT = mean(RT[ACC == 1]),
            mACC = mean(ACC)) %>%
  ungroup()

head(data_summed_by_subject)
# This data frame is basically ready for a rm-ANOVA!
# (see next semester...)

# unfortunately we lost some columns (gender, groups) - but we can add them
# back in:
# 1. Make df with data we want to add:
subject_data <- e2b_data %>%
  select(Subject, Group, Gender) %>%
  distinct()

head(subject_data)

# 2. Joint them:
data_summed_by_subject <- e2b_data %>%
  group_by(Subject, Emotion, SameDiff) %>%
  summarise(mRT = mean(RT[ACC == 1]),
            mACC = mean(ACC)) %>%
  ungroup() %>%
  full_join(subject_data, by = "Subject")

head(data_summed_by_subject)

# We can now also summarise THIS summarised data further!
data_summed_by_subject %>%
  group_by(Gender, Group, Emotion, SameDiff) %>%
  summarise(mRT_M = mean(mRT),
            mRT_S = sd(mRT))


# counting subjects in each group
e2b_data %>%
  group_by(Gender, Group) %>%
  summarise(N = n_distinct(Subject))


# Reliability and sum scores ----------------------------------------------

df_NPAS <- readRDS("NPAS-data_clean.Rds")
glimpse(df_NPAS)

df_NPAS %>%
  select(Q1:Q26) %>%
  psych::alpha()

df_NPAS_with_score <- df_NPAS %>%
  # always use `rowSums` in a NEW call to mutate!
  mutate(Nerdy = rowSums(select(., Q1:Q26))) %>%
  select(-(Q1:Q26))
head(df_NPAS_with_score)


# *** ggplot2 *** ---------------------------------------------------------

library(ggplot2) # already attached as part of the tidyverse

ggplot(df_NPAS_with_score, mapping = aes(x = Nerdy)) +
  geom_histogram()

ggplot(df_NPAS_with_score, aes(x = Nerdy)) +
  geom_density()

ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage)) +
  geom_point()

ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage, color = gender)) +
  geom_point()

ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage, color = gender)) +
  geom_point() +
  geom_smooth()

ggplot(df_NPAS_with_score, aes(x = ASD, y = Nerdy, color = urban)) +
  geom_boxplot()

ggplot(df_NPAS_with_score, aes(x = ASD, y = Nerdy, color = urban)) +
  geom_boxplot() +
  facet_grid( ~ married)

ggplot(df_NPAS_with_score, aes(x = ASD, y = Nerdy, color = urban)) +
  geom_point() +
  facet_grid(gender ~ married)

# and many many more...
# https://ggplot2-book.org/

rnorm(1)
rnorm(10)
rnorm(1000) %>% hist()
rnorm(1000, mean = 100, sd = 15) %>% hist()
runif(1000) %>% hist()
rexp(1000) %>% hist()
rchisq(1000, df = 12) %>% hist()

qnorm(.05) # input is probability
pnorm(-1.96) # input is random variable value
qt(.95,df = 12)

ggplot(mapping = aes(x = 0)) +
  geom_density() +
  stat_function(fun = dnorm, color = "red") +
  geom_rug() +
  xlim(-5,5)

# Learn how to better visualize your data:
# https://serialmentor.com/dataviz/visualizing-amounts.html

# Exercise ----------------------------------------------------------------

# 1. Summarize the data in `df_NPAS_with_score` by describing the
#    variable `Nerdy` - mean, sd, and at least 2 other measures you
#    can think of.
# 2. Repeat (1) but for EACH gender and ASD group.
# 3. Using ggplot, try and answer the following question:
#    a. What is the relationship between sexual orientation (`orientation`)
#       and nerdiness (`Nerdy`). see `?geom_smooth`
#    b. Does it vary by ASD? education? Both?

