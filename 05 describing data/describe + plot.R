library(dplyr)
library(parameters) # for kurtosis & skewness
library(summarytools) # for dfSummary

data_raw <- read.csv("emotional_2back.csv")
data_with_Group <- data_raw %>%
  mutate(Group = ifelse(Subject <= 30, "A", "B"))

glimpse(data_with_Group)


# Describe variables ------------------------------------------------------

dfSummary(data_with_Group)

data_with_Group %>%
  summarise(mean(RT),
            mRT_correct = mean(RT[ACC==1]),
            mean(ACC),
            median(RT),
            kurtosis(RT), skewness(RT),
            min(RT),
            max(RT))

# By Group ----------------------------------------------------------------

data_with_Group %>%
  group_by(Gender) %>%
  summarise(mean(RT),
            mRT_correct = mean(RT[ACC==1]),
            mean(ACC),
            median(RT),
            kurtosis(RT), skewness(RT),
            min(RT))


data_summed_by_subject <- data_with_Group %>%
  group_by(Subject, Emotion, SameDiff) %>%
  summarise(mRT = mean(RT[ACC==1]),
            mACC = mean(ACC),
            RT_range = range(RT))

head(data_summed_by_subject)

data_with_Group %>%
  select(Subject,Group,Gender) %>%
  distinct() %>%
  full_join(data_summed_by_subject, by = "Subject") %>%
  group_by(Group,Gender,Emotion,SameDiff) %>%
  summarise(mean_RT = mean(mRT),
            sd_RT = sd(mRT))


# counting subjects
data_with_Group %>%
  group_by(Gender, Group) %>%
  summarise(N = n_distinct(Subject))


# Reliability and sum scores ----------------------------------------------

df_NPAS <- readRDS("NPAS-data_clean.Rds")

df_NPAS %>%
  select(Q1:Q26) %>%
  psych::alpha()

mutate_colsum <- function(.data, col_name = "sum", ..., .keep = TRUE){
  tmp <- select_at(.data, vars(...))
  if (isFALSE(.keep)) .data[,colnames(tmp)] <- NULL
  .data[[col_name]] <- rowSums(tmp)
  .data
}

df_NPAS_with_score <- df_NPAS %>%
  mutate_colsum("Nerdy", Q1:Q26, .keep = FALSE)
head(df_NPAS_with_score)

# GGPLOT2 -----------------------------------------------------------------

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

ggplot(df_NPAS_with_score,mapping = aes(x=ASD, y=Nerdy, color = urban)) +
  geom_boxplot()

ggplot(df_NPAS_with_score,mapping = aes(x=ASD, y=Nerdy, color = urban)) +
  geom_boxplot() +
  facet_grid(~gender)

ggplot(df_NPAS_with_score,mapping = aes(x=ASD, y=Nerdy, color = urban)) +
  geom_point() +
  facet_grid(gender~married)

# and many many more...
# https://ggplot2-book.org/

rnorm(1)
rnorm(10)
rnorm(1000) %>% hist()
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
#       and nerdiness (`Nerdy`).
#    b. Does it vary by ASD? education? Both?

