
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
    Nerdy1 = rowSums(across(.cols = Q1:Q26), na.rm = TRUE),
    Nerdy2 = rowMeans(across(.cols = Q1:Q26), na.rm = TRUE) # better for missing data
  ) %>%
  select(-(Q1:Q26))

head(df_NPAS_with_score)

