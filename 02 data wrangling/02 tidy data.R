library(tidyverse)


data_raw <- read.csv("data/deaf_numer.csv")

data_clean <- data_raw %>%
  select(sID, nFingers, rt) %>%
  filter(rt < 2500)


# Join data frames --------------------------------------------------------



# Sometimes our data is split across more than one data frame. Sometimes examples:
# - Data from different sessions is stored in different files
# - Dyad data is split (mother data in one file, baby in another).
# - Data from different questionnaires / tasks is stored in separate files.

# For example, we have:
# 1. A file with performance on some task.
head(data_clean)
# 2. A file with demographic info for each subject.
subject_info <- read.csv("data/deaf_numer_sinfo.csv")
head(subject_info)


# We can easily JOIN these data according to some key - the subject.
data_clean_joined <- data_clean %>%
  full_join(subject_info, by = "sID")
head(data_clean_joined, n = 12)






# Long and Wide data ------------------------------------------------------


# Most modeling functions in R take a data frame that is tidy. Unfortunately,
# this is not true for other unmentionable statistical programs...

emotionalWM <- readxl::read_excel("data/Zhang2018_emotionalWM.xlsx")
# data from https://doi.org/10.3389%2Ffnbeh.2018.00065
head(emotionalWM)
# Is this data tidy? (No. Why not?)



# To make this data tidy, we need to make it LONG (it is now WIDE).
# We can do this with `pivot_longer()`:

emotionalWM_long <- emotionalWM %>%
  pivot_longer(
    cols = positive_average:negative_O2,
    names_to = "condition",
    values_to = "mV"
  )
head(emotionalWM_long)
# Is this data tidy?




emotionalWM_long <- emotionalWM %>%
  pivot_longer(
    cols = positive_average:negative_O2,
    names_sep = "_",
    names_to = "emotion", "area",
    values_to = "mV"
  )
head(emotionalWM_long)
# Is THIS data tidy?





# Sometimes we might want to take long form data and make it wide.
# We can do this with `pivot_wider()`
emotionalWM_wide_again <- emotionalWM_long %>%
  pivot_wider(
    names_from = c("emotion", "area"),
    values_from = "mV"
  )
head(emotionalWM_wide_again)


