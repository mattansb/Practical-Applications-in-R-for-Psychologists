library(dplyr)

tai_missing <- readRDS("tai_missing.Rds")
head(tai_missing)


# Drop? -------------------------------------------------------------------

tai_no_OL <- tai_missing %>%
  mutate(moED_z = scale(moED),
         moEd_ol = abs(moED_z) > 2) %>%
  filter(!moEd_ol)

# or
tai_no_OL <- tai_missing %>%
  filter(abs(scale(moED)) <= 2)


# "fix" -------------------------------------------------------------------

tai_winzorize_OL <- tai_missing %>%
  mutate(moED_z = scale(moED),
         moED_win = case_when(moED_z >  2 ~ max(moED[moED_z <= 2]),
                              moED_z < -2 ~ min(moED[moED_z >= 2]),
                              TRUE        ~ moED))

hist(tai_no_OL$moED)
hist(tai_winzorize_OL$moED_win)

