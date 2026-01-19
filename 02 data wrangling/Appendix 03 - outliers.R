library(dplyr)
library(ggplot2)
library(performance)
library(datawizard)
library(see)

# There are many rules of thumb for defining what an outlier IS:
# https://doi.org/10.3758/s13428-024-02356-w

tai_missing <- readRDS("data/tai_missing.Rds")
head(tai_missing)


ol_iqr <- check_outliers(tai_missing$moED, method = "iqr", threshold = 1.7)
which(ol_iqr)
# plot(ol_iqr)
# These are univariate outliers according to the IQR method. But there are
# more univariate methods, multivariate methods, and model-based methods.

?check_outliers # see documentation for details about the various methods


# Here we will explore two popular options for dealing with outliers.

# Drop --------------------------------------------------------------------
# This is the easiest option - remove them!

tai_no_OL <- tai_missing |>
  filter(!ol_iqr)


# Winzorize ---------------------------------------------------------------
# Replace Extreme Values By Less Extreme Ones

sort(unique(tai_missing$moED[ol_iqr]))

tai_winzorize_OL <- tai_missing |>
  mutate(
    moED_win = winsorize(moED, threshold = c(1, 19), method = "raw")
  )


# Compare -----------------------------------------------------------------

{
  par(mfrow = c(3, 1))

  hist(
    tai_missing$moED,
    main = "Original",
    xlim = c(0, 25),
    breaks = seq(0, 25, 1)
  )

  hist(tai_no_OL$moED, main = "Omit", xlim = c(0, 25), breaks = seq(0, 25, 1))

  hist(
    tai_winzorize_OL$moED_win,
    main = "Winsorize",
    xlim = c(0, 25),
    breaks = seq(0, 25, 1)
  )

  par(mfrow = c(1, 1))
}

# next lesson we will see better plotting methods...
