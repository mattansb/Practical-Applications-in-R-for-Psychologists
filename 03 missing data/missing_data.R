
tai_missing <- readRDS("tai_missing.Rds")
head(tai_missing)

# Test Patterns of Missingness --------------------------------------------

library(finalfit)

# How many missing?
ff_glimpse(tai_missing)
missing_plot(tai_missing)

# How to test patterns of missingness (MCAR, MAR, MNAR)?
# It is out of the scope of our work here, but this is a really (really)
# good tutorial about detecting & visializing patterns of missingness
# using the `finalfit` package:
# https://finalfit.org/articles/missing.html

# Simple Imputation (Hmisc) -----------------------------------------------

library(Hmisc)

# imputate a single var with a single value
tai_missing$calm_imp <- impute(tai_missing$calm, fun = mean)

tai_missing$calm_imp # the `*` marks the imputated value...

(tai_missing$calm_imp <- impute(tai_missing$calm, fun = median))
(tai_missing$calm_imp <- impute(tai_missing$calm, fun = 1.2)) # can also be a number

# Multivariate Imputation (MICE) ------------------------------------------

library(mice)

imputed_Data <- mice(tai_missing, m = 5, maxit = 1, method = 'pmm', seed = 500)

#' `seed` will guarantee you always get the same results)
#' This will imputate ALL missing data based on ALL variables. If you want
#' more control over what is imputated how - read:
?mice

# see the first rows of some imputaed data
head(imputed_Data$imp$pleasant) # numeric
head(imputed_Data$imp$study)    # categorical


tai_imp_full <- complete(imputed_Data, action = 2) # I chose the second imputation
