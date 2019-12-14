library(dplyr)
library(ggplot2)

df_NPAS_with_score <- readRDS("NPAS-data_clean.Rds") %>%
  mutate(
    Nerdy = select(., Q1:Q26) %>% rowSums()
  )


# 1. Summarize the data in `df_NPAS_with_score` by describing the
#    variable `Nerdy` - mean, sd, and at least 2 other measures you
#    can think of.
df_NPAS_with_score %>%
  summarise(M = mean(Nerdy),
            S = sd(Nerdy),
            Md = median(Nerdy),
            IQR = IQR(Nerdy))

# 2. Repeat (1) but for EACH gender and ASD group.
df_NPAS_with_score %>%
  group_by(gender, ASD) %>%
  summarise(M = mean(Nerdy),
            S = sd(Nerdy),
            Md = median(Nerdy),
            IQR = IQR(Nerdy))

# 3. Using ggplot, try and answer the following question:
#    a. What is the relationship between sexual orientation (`orientation`)
#       and nerdiness (`Nerdy`).
df_NPAS_with_score %>%
  na.omit() %>%
  ggplot(aes(x = orientation, y = Nerdy)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(alpha = 0)

#    b. Does it vary by ASD? education? Both?
df_NPAS_with_score %>%
  na.omit() %>%
  ggplot(aes(x = orientation, y = Nerdy, fill = ASD)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(alpha = 0) +
  facet_grid( ~ education)
