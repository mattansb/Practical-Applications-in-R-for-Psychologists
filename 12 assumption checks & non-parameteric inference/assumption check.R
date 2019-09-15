library(dplyr)
library(performance) # for check_*
library(ggplot2)
library(GGally) # for ggpairs
library(ggResidpanel) # for resid_panel


exp_grades <- read.csv("Exp_Psych_Grades.csv")
head(exp_grades)

mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)

summary(mod)

# What are the assumptions of linear regression?
# https://shouldbewriting.netlify.com/posts/2018-08-30-linear-regression-assumptions/

# Collinearity ------------------------------------------------------------

check_collinearity(mod)

model.matrix(mod) %>%
  as.data.frame() %>%
  ggpairs()

# Do the predictors look skewed?

# >>> What to do if violated? <<<

# Normality (of residuals) ------------------------------------------------

# Shapiro-Wilk test for the normality (of THE RESIDUALS!!!)
check_normality(mod)

# but...
# https://notstatschat.rbind.io/2019/02/09/what-have-i-got-against-the-shapiro-wilk-test/

resid_panel(mod)

# >>> What to do if violated? <<<

# Homoscedasticity --------------------------------------------------------

check_heteroscedasticity(mod)

exp_grades$pred <- predict(mod)
exp_grades$resid <- residuals(mod)

ggplot(exp_grades, aes(pred,Report)) +
  geom_point()

# >>> What to do if violated? <<<


# (multivariate) Outliers -------------------------------------------------

ol_test <- check_outliers(mod)
ol_test

exp_grades$outliers <- ol_test$.outliers

ggplot(exp_grades, aes(pred,Report, color = outliers)) +
  geom_point() +
  geom_label(aes(label = Group))

# What does this actually do?
?check_outliers


# Exercise ----------------------------------------------------------------

# 1. What does `resid_xpanel()` do? What should it look like?
# 2. Conduct a boostrap analysis (see lesson 06).
#    - How does this effect the results?
