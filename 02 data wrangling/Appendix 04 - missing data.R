
tai_missing <- readRDS("data/tai_missing.Rds")
tai_missing$sex <- sample(c("m","f"), size = nrow(tai_missing), replace = TRUE)
head(tai_missing)

# Learn about missing data:
# - https://stefvanbuuren.name/fimd/
# - http://doi.org/10.5334/irsp.289


# Test Patterns of Missingness --------------------------------------------

library(finalfit)

# How many missing?
ff_glimpse(tai_missing)
missing_plot(tai_missing)

# How to test patterns of missingness (MCAR, MAR, MNAR)?
# It is out of the scope of our work here, but this is a really (really) good
# tutorial about detecting & visualizing patterns of missingness using the
# `finalfit` package:
# https://finalfit.org/articles/missing.html

# Here are the basic functions:

# Describe the patterns of missingness:
tai_missing %>%
  missing_pattern(dependent = "nervous",
                  explanatory = c("sex", "calm", "happy"))


# Plot patterns of missingness:
tai_missing %>%
  missing_pairs(dependent = "nervous",
                explanatory = c("sex","calm", "happy"))


# Test patterns of missingness:
tai_missing %>%
  missing_compare(dependent = "nervous",
                  explanatory = c("sex","calm", "happy"))









# Other than dropping missing data, which is BAD if data is not missing are
# random, we can also impute the missing data.





# Imputations -------------------------------------------------------------


## Simple Imputation (Hmisc) -----------------------------------------------

library(Hmisc)

# imputate a single var with a single value
(tai_missing$calm_imp <- impute(tai_missing$calm, fun = mean))
# the `*` marks the imputated value...

(tai_missing$calm_imp <- impute(tai_missing$calm, fun = median))

# can also be a number
(tai_missing$calm_imp <- impute(tai_missing$calm, fun = 1.2))









## Multivariate Imputation (MICE) ------------------------------------------

library(mice)

# Read more at https://stefvanbuuren.name/mice/

imputed_Data <- mice(tai_missing, m = 5, maxit = 1, method = 'pmm', seed = 500)
# `seed` will guarantee you always get the same results)

# This will impute ALL missing data based on ALL variables. If you want more
# control over what is imputed how - read:
?mice

# see the first rows of some imputed data
head(imputed_Data$imp$pleasant) # numeric
head(imputed_Data$imp$study)    # categorical


tai_imp_full <- complete(imputed_Data, action = 2)
# I chose the second imputation




# You can also use ALL the imputation, not just a randomly selected one! This is
# slowly becoming the GOLD STANDARD for such cases.
#
# Read more here:
?with.mids



