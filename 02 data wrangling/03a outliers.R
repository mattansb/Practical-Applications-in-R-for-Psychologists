
library(dplyr)


# There are many rules of thumb for defining what an outlier IS (relative
# thresholds, absolute thresholds). For the purposes of this demo, an outlier
# will be defined as any observation that is 1.2 SDs from the mean (this is NOT
# a good rule of thumb!).

tai_missing <- readRDS("tai_missing.Rds")
head(tai_missing)

hist(tai_missing$moED)
abline(v = c(-1.2, 1.2)*sd(tai_missing$moED) + mean(tai_missing$moED), col = "red")

# Here we will explore two popular options for dealing with outliers.



# Drop? -------------------------------------------------------------------
# This is the easiest option - remove them!

tai_no_OL <- tai_missing %>%
  mutate(moED_z = scale(moED),
         moEd_ol = abs(moED_z) > 1.2) %>%
  filter(!moEd_ol)





# Winzorize ---------------------------------------------------------------
# Replace Extreme Values By Less Extreme Ones

library(DescTools) # for `Winsorize()`


tai_winzorize_OL <- tai_missing %>%
  mutate(moED_win = Winsorize(moED,
                              minval = -1.2 * sd(moED) + mean(moED),
                              maxval = 1.2 * sd(moED) + mean(moED)))


# Compare -----------------------------------------------------------------


hist(tai_missing$moED, xlim = c(0, 25))
hist(tai_no_OL$moED, xlim = c(0, 25))
hist(tai_winzorize_OL$moED_win, xlim = c(0, 25))

