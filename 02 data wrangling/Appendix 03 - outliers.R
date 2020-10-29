
library(dplyr)

# There are many rules of thumb for defining what an outlier IS (relative
# thresholds, absolute thresholds). For the purposes of this demo, an outlier
# will be defined as any observation that is 1.1 IQRs (interquartile range) the
# median (this is NOT a good rule of thumb!).

tai_missing <- readRDS("data/tai_missing.Rds")
head(tai_missing)

(moEd_range <- tai_missing %>%
    summarise(range = c(-1.1,1.1) * IQR(moED) + median(moED)))


{
  hist(tai_missing$moED)
  abline(v = moEd_range$range, col = "red")
}

# Here we will explore two popular options for dealing with outliers.



# Drop? -------------------------------------------------------------------
# This is the easiest option - remove them!

tai_no_OL <- tai_missing %>%
  mutate(moED_std_d = (moED - median(moED)) / IQR(moED),
         moEd_ol = moED_std_d > 1.1 | moED_std_d < -1.1) %>%
  filter(!moEd_ol)





# Winzorize ---------------------------------------------------------------
# Replace Extreme Values By Less Extreme Ones

tai_winzorize_OL <- tai_missing %>%
  mutate(moED_win = DescTools::Winsorize(moED,
                                         minval = -1.1 * IQR(moED) + median(moED),
                                         maxval = 1.1 * IQR(moED) + median(moED)))

# Compare -----------------------------------------------------------------


{
  par(mfrow = c(3, 1))

  hist(tai_missing$moED, main = "Original",
       xlim = c(0, 25), breaks = seq(0,25,1))
  abline(v = moEd_range$range, col = "red")

  hist(tai_no_OL$moED, main = "Omit",
       xlim = c(0, 25), breaks = seq(0,25,1))
  abline(v = moEd_range$range, col = "red")

  hist(tai_winzorize_OL$moED_win, main = "Winsorize",
       xlim = c(0, 25), breaks = seq(0,25,1))
  abline(v = moEd_range$range, col = "red")

  par(mfrow = c(1, 1))
}

# next lesson we will see better plotting methods...
