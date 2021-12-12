
library(performance)  # for check_*
library(see)


exp_grades <- read.csv("Exp_Psych_Grades.csv")
exp_grades$in_couple <- factor(exp_grades$in_couple)

head(exp_grades)




mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)

summary(mod)



# Leverage and (multivariate) Outliers ------------------------------------

# These two terms are similar - both relate to observations who are far from all
# other observations, in the *multivariate* space. This can be a problem if
# these "extreme" observation are influencing our model in such a way that the
# model over-represents them, and under-represents the other observations.

## Multivariate Outliers (leverage)
ol_test <- check_outliers(mod, method = "cook") # or "mahalanobis"
ol_test

plot(ol_test)


insight::get_data(mod)[ol_test, ]
# What makes these so extreme?





# >>> What to do if violated? <<<
# - Check for errors in data
# - Use robust methods that are less sensitive to such outliers




