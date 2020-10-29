
# Reliability and sum / mean scores ---------------------------------------

library(dplyr)

NPAS <- read.csv("data/NPAS.csv") # data from https://osf.io/5njdx/
glimpse(NPAS)

# Use `psych::alpha` to compute Cronbach's Alpha:
NPAS %>%
  select(NPAS_1:NPAS_26) %>%
  psych::alpha()


# Use `across` to compute sum / mean scores
NPAS_with_score <- NPAS %>%
  mutate(
    # Raw Sum/Mean scores
    Nerd_sum_raw = across(NPAS_1:NPAS_26) %>% rowSums(na.rm = TRUE),
    Nerd_mean_raw = across(NPAS_1:NPAS_26) %>% rowMeans(na.rm = TRUE), # better for missing data
    # Standardized Sum/Mean scores
    Nerd_sum_std = across(NPAS_1:NPAS_26, .fns = scale) %>% rowSums(na.rm = TRUE),
    Nerd_mean_std = across(NPAS_1:NPAS_26, .fns = scale) %>% rowMeans(na.rm = TRUE), # better for missing data
  ) %>%
  select(-(NPAS_1:NPAS_26))

head(NPAS_with_score)

# For more reliability measures see the `psych` and `irr` packages.
