
# Reliability and sum / mean scores ---------------------------------------

library(dplyr)

# data from https://www.kaggle.com/lucasgreenwell/nerdy-personality-attributes-scale-responses
NPAS <- read.csv("data/NPAS data.csv") |>
  mutate(
    across(starts_with("Q"), .fns = as.numeric) # what does this do?
  )

glimpse(NPAS)

# Use `psych::alpha` to compute Cronbach's Alpha:
NPAS |>
  select(Q1:Q26) |>
  psych::alpha()

# A little helper function to be used in `mutate()`
across_sum <- function(..., mean = FALSE, na.rm = FALSE) {
  if (mean) {
    across(...) |>
      rowMeans(na.rm = na.rm)
  } else {
    across(...) |>
      rowSums(na.rm = na.rm)
  }
}


# Use `across` to compute sum / mean scores
NPAS_with_score <- NPAS |>
  mutate(
    # Raw Sum/Mean scores
    Nerd_sum_raw = across_sum(Q1:Q26, na.rm = TRUE),
    Nerd_mean_raw = across_sum(Q1:Q26, mean = TRUE, na.rm = TRUE), # better for missing data
    # Standardized Sum/Mean scores
    Nerd_sum_std = across_sum(Q1:Q26, .fns = scale, na.rm = TRUE),
    Nerd_mean_std = across_sum(Q1:Q26, .fns = scale, mean = TRUE, na.rm = TRUE), # better for missing data
  ) |>
  select(-(Q1:Q26)) # what does this do?

head(NPAS_with_score)



# For more reliability measures see the `psych` and `irr` packages.
