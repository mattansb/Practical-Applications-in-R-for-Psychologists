library(dplyr)

tai_missing <- readRDS("tai_missing.Rds")
head(tai_missing)

#how many missing?
tai_missing %>%
  gather("Var","value",everything()) %>%
  group_by(Var) %>%
  summarise(missing_vals = mean(is.na(value)))

# Test MCAR ---------------------------------------------------------------

#' HOW TO TEST MISSING AT RANDOM??


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
imputed_Data$imp %>% map(head)

tai_imp_full <- complete(imputed_Data,action = 2)

table(tai_imp_full$study,tai_missing$study, exclude = FALSE)
