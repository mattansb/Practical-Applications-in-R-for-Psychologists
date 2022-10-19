
library(dplyr)
library(parameters) # for kurtosis & skewness

e2b_data <- read.csv("data/emotional_2back.csv") |>
  mutate(Group = ifelse(Subject <= 30, 1, 2) |> factor(),
         Subject = factor(Subject),
         Emotion = factor(Emotion),
         SameDiff = factor(SameDiff),
         Gender = factor(SameDiff))

glimpse(e2b_data)


# You can also summarise ACROSS several variables, with `across()`.
#
# We need to define what kind of summarise we want - these can be functions,
# names of functions, or a lambda function.
suff_i_wanna_know <- list(
  # a function
  mean = mean,
  # name of a function
  sd = "sd",
  # a lambda
  mean_no_na = \(x) mean(x, na.rm = TRUE), # *
  # Some more functions
  kurt = kurtosis,
  skew = skewness
)

# [*] This \(x) mean "this is a function that takes an "x" argument. It is a
# short-hand for writing function(x).



# Use the `across()` function:
e2b_data |>
  summarise(across(.cols = c(RT, ACC),
                   .fns = suff_i_wanna_know))

# other ways to select variables.
e2b_data |>
  summarise(across(.cols = c(Subject,Group), nlevels),
            across(.cols = c(RT, ACC),
                   .fns = suff_i_wanna_know))


# Read more about using `across()`:
# https://dplyr.tidyverse.org/articles/colwise.html
