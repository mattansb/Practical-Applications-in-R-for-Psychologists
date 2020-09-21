
# Reliability and sum / mean scores ---------------------------------------

library(dplyr)


df_NPAS <- readRDS("NPAS-data_clean.Rds")
glimpse(df_NPAS)

# Use `psych::alpha` to compute reliability
df_NPAS %>%
  select(Q1:Q26) %>%
  psych::alpha()


# Use `across` to compute sum / mean scores
df_NPAS_with_score <- df_NPAS %>%
  mutate(
    # Raw Sum/Mean scores
    Nerd_sum_raw = rowSums(across(Q1:Q26), na.rm = TRUE),
    Nerd_mean_raw = rowMeans(across(Q1:Q26), na.rm = TRUE), # better for missing data
    # Standardized Sum/Mean scores
    Nerd_sum_std = rowSums(across(Q1:Q26, .fns = scale), na.rm = TRUE),
    Nerd_mean_std = rowMeans(across(Q1:Q26, .fns = scale), na.rm = TRUE), # better for missing data
  ) %>%
  select(-(Q1:Q26))

head(df_NPAS_with_score)

# For more reliability measures see the `psych` and `irr` packages.
