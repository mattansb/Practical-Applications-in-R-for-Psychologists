library(performance)  # for check_*
library(dplyr)        # for the %>%
library(GGally)       # for ggpairs
library(ggResidpanel) # for resid_panel




exp_grades <- read.csv("Exp_Psych_Grades.csv")
head(exp_grades)

mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)

summary(mod)

# What are the assumptions of linear regression?
# https://shouldbewriting.netlify.com/posts/2018-08-30-linear-regression-assumptions/






# Collinearity ------------------------------------------------------------

check_collinearity(mod)

exp_grades %>%
  select(Report, DOI, OSF, in_couple) %>%
  ggpairs()

# Do the predictors look skewed? Do we care?



# >>> What to do if violated? <<<




# Normality (of residuals) ------------------------------------------------


# Shapiro-Wilk test for the normality (of THE RESIDUALS!!!)
check_normality(mod)


# but...
# https://notstatschat.rbind.io/2019/02/09/what-have-i-got-against-the-shapiro-wilk-test/

# So you should really LOOK at the residuals:
resid_panel(mod, plots = c("hist", "qq"),
            qqbands = TRUE)
# There are other plot options - these are the one I recommend.
?resid_panel



# >>> What to do if violated? <<<





# Homoscedasticity --------------------------------------------------------

check_heteroscedasticity(mod)

# Let's take a look.
resid_panel(mod, plots = c("resid", "ls", "yvp"),
            smoother = TRUE)
# How do we want there to look?

# We can also compare the residuals to each predictor
resid_xpanel(mod, smoother = TRUE)
# How do we want there to look?




# >>> What to do if violated? <<<






# Leverage and (multivariate) Outliers ------------------------------------

## Leverage
resid_panel(mod, plots = c("lev"),
            smoother = TRUE)




## (multivariate) Outliers
ol_test <- check_outliers(mod, method = "cook") # or "mahalanobis"
ol_test


exp_grades$outliers <- factor(ol_test)
exp_grades$pred <- predict(mod)

ggplot(exp_grades, aes(pred,Report, color = outliers)) +
  geom_point() +
  geom_label(aes(label = Group))


# What does this actually do?
?check_outliers # read about the methods





# Exercise ----------------------------------------------------------------

# Fit the model:   Report ~ Test + in_couple
#    1. Test all the assumptions.
#    2. Conduct a boostrap / permutation analysis.
#       How does this affect the results?
