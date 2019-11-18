
# Prep data:
# 1. Rewrite this ugly code using the pipe (%>%):
# diff(range(sample(head(iris$Sepal.Length, n = 10), size = 5, replace = TRUE)))
iris$Sepal.Length %>%
  head(n = 10) %>%
  sample(size = 5, replace = TRUE) %>%
  range() %>%
  diff()


# Using the following data:
library(tidyverse)
data_raw <- read_csv("emotional_2back.csv")

data_new <- data_raw %>%
# 2. recode the Group variable: Subject<=30 Group=1, Subject>30 Group=2.
#    (the RA forgot to do it...)
#    TIP: use `ifelse`
#    (see last `control_and_functions.R` from last lesson)
  mutate(Group = ifelse(Subject<=30, 1, 2)) %>%
# 3. remove the first, practice block (1)
  filter(Block != 1) %>%
# 4. remove trials following an error
#    TIP: use `lag`
  filter(lag(ACC)!=0) %>%
# 5. remove error trials (codded as ACC is 0)
  filter(ACC!=0) %>%
# 6. remove RTs that fall beyond +/- 2 SD from *each participant's* average
#    in *each* (emotion-by-gender) condition
  group_by(Subject) %>%
  filter(abs(scale(RT)) < 2) %>%
  ungroup() %>%
# 7. create the variable `delay_minutes`, randomly sampled from
#    c(short = 5, long = 60)
  mutate(delay_minutes = sample(c(short = 5, long = 60), size = n(), replace = TRUE))
# 8. Save that data to an Rds file AND a csv file

write.csv(data_new, "data_new.csv")



