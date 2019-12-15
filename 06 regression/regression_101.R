library(dplyr)
library(effectsize) # for parameters_standardize
library(parameters) # for model_parameters
library(performance) # for model_performance etc..
# will also need `psych` for dataset
# will also need `see` for plotting

# load a data set
data("sai", package = "psych")
head(sai)
?psych::sai

sai_AGES <- sai %>%
  filter(study == "AGES") %>%
  select(-study)

# Simple Regression -------------------------------------------------------

# we specify a *model* with a formula:
y ~ x

# we fit Linear Models with `lm`:
fit <- lm(anxious ~ calm, data = sai_AGES)
fit

summary(fit) # see df, sig and more...

predict(fit)
residuals(fit)
# what is the correlation between these ^ two?

# beta
standardize_parameters(fit)

# ci
confint(fit)

# nice printing method:
reg_table <- model_parameters(fit, standardize = "basic")
reg_table
plot(reg_table)

# model indices
model_performance(fit)
rmse(fit)
r2(fit) # and more...


# Multiple Regression -----------------------------------------------------

fit2 <- lm(anxious ~ calm + tense + worrying, sai_AGES)
summary(fit2)

# how will this affect the results?
sai_AGES$tense_100 <- sai_AGES$tense * 100
fit3 <- lm(anxious ~ calm + tense_100 + worrying, sai_AGES)
summary(fit2)
summary(fit3)


# all variables in a data.frame (almost never useful)
fit_all <- lm(anxious ~ ., sai_AGES)
summary(fit_all)


# Exercise ----------------------------------------------------------------

# 1. Predict `joyful` from two predictors of your choice.
#    a. Which of the two has the bigger contribution to predicting joyfulness?
#    b. What is the 80% CI for the second predictor?
#    c. What is the R^2 of the model?
# 2. Plot (with ggplot) the tri-variate relationship.
# 3. Add the predicted values to the data.frame. Plot them (with ggplot2,
#    duh) the relation to the true values. Use `geom_smooth`.
# *. What does `update` do?
