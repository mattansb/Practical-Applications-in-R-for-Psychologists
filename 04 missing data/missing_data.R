library(dplyr)

tai_missing <- readRDS("tai_missing.Rds")
head(tai_missing)

#how many missing?
tai_missing %>%
  summarise_all( ~ mean(is.na(.x)))


# Test Patterns of Missingness --------------------------------------------

#' How to test patterns of missingness (MCAR, MAR, MNAR)?
#' It is out of the scope of our work here, but this is a really (really)
#' good tutorial about detecting & visializing patterns of missingness
#' using the `finalfit` package.
#'
#' https://finalfit.org/articles/missing.html


# Impute ------------------------------------------------------------------

# https://www.analyticsvidhya.com/blog/2016/03/tutorial-powerful-packages-imputing-missing-values/

## Hmisc ##

library(Hmisc)

# imputate single var
tai_missing$calm_imp <- impute(tai_missing$calm, fun = mean)
tai_missing$calm_imp <- impute(tai_missing$calm, fun = median)


## MICE ##

library(mice)

md.pattern(tai_missing, plot = FALSE)

imputed_Data <- mice(tai_missing, m = 5, maxit = 1, method = 'pmm', seed = 500)
imputed_Data$imp %>% lapply(head)

tai_imp_full <- complete(imputed_Data,action = 2)

table(tai_imp_full$study,tai_missing$study, exclude = FALSE)
