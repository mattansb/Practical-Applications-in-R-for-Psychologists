library(tidyverse)

data_raw <- read.csv("emotional_2back.csv")

data_clean <- data_raw %>%
  select(Subject, Group:Trial, Emotion, RT) %>%
  filter(RT < 4000) %>%
  mutate(sqrtRT = sqrt(RT),
         RT = RT / 1000) %>%
  group_by(Emotion) %>%
  mutate(RT_z = scale(RT)) %>%
  ungroup()


# Join data frames --------------------------------------------------------



# Sometimes our data is split across more than one data frame. Sometimes examples:
# - Data from different sessions is stored in different files
# - Dyad data is split (mother data in one file, baby in another).
# - Data from different questionnaires / tasks is stored in separate files.

# For example, we have:
# 1. A file with performance on some task.
head(data_clean)
# 2. A file with demographic info for each subject.
subject_info <- read.csv("emotional_2back_sub_data.csv")
head(subject_info)


# We can easily JOIN these data according to some key - the subject.
data_clean_joined <- data_clean %>%
  full_join(subject_info, by = "Subject")
head(data_clean_joined)






# Long and Wide data ------------------------------------------------------


# Most modeling functions in R take a data frame that is tidy. Unfortunately,
# this is not true for other unmentionable statistical programs...


data_wide <- read.csv("WIDE_data.csv")
head(data_wide)
# Is this data tidy? (No. Why not?)



# To make this data tidy, we need to make it LONG (it is now WIDE).
# We can do this with `pivot_longer()`:

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
    names_sep = "_",
    names_to = "Emotion", "SameDiff",
    values_to = "mRT"
  )
head(data_long_tidy)
# Is THIS data tidy?





# Sometimes we might want to take long form data and make it wide.
# We can do this with `pivot_wider()`
data_wide_again <- data_long_tidy %>%
  pivot_wider(
    names_from = c("Emotion","SameDiff"),
    values_from = "mRT"
  )
head(data_wide_again)


