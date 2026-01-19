# Reliability and sum / mean scores ---------------------------------------

library(dplyr)
library(datawizard) # for standardize()

# data from
# https://www.kaggle.com/lucasgreenwell/nerdy-personality-attributes-scale-responses
NPAS <- read.csv("data/NPAS data.csv") |>
  mutate(across(starts_with("Q"), .fns = as.numeric)) # what does this do?

glimpse(NPAS)

# Use `psych::alpha` to compute Cronbach's Alpha:
NPAS |>
  select(Q1:Q26) |>
  psych::alpha()

# A little helper function to be used in `mutate()`
pick_and_sum <- function(..., mean = FALSE, na.rm = FALSE) {
  if (mean) {
    pick(...) |>
      rowMeans(na.rm = na.rm)
  } else {
    pick(...) |>
      rowSums(na.rm = na.rm)
  }
}


# Use `across` to compute sum / mean scores
NPAS_with_score <- NPAS |>
  mutate(
    # Raw Sum/Mean scores
    Nerd_sum_raw = pick(Q1:Q26) |> rowSums(na.rm = TRUE),

    # better for missing data to use the mean
    Nerd_mean_raw = pick(Q1:Q26) |> rowMeans(na.rm = TRUE),

    # Standardized Sum/Mean scores
    Nerd_sum_std = across(Q1:Q26, standardize) |> rowMeans(na.rm = TRUE),
    Nerd_mean_std = across(Q1:Q26, standardize) |> rowSums(na.rm = TRUE)
  ) |>
  select(-(Q1:Q26)) # what does this do?

head(NPAS_with_score)

# For more reliability measures see the `psych` and `irr` packages.
