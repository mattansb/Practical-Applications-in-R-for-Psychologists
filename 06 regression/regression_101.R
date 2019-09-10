library(dplyr)
library(parameters) # for parameters_standardize and model_bootstrap
library(performance) # for model_performance etc..
# will also need `psych` for dataset

# load a data set
data("sai", package = "psych")
head(sai)
?psych::sai
sai_AGES <- sai %>%
  filter(study == "AGES") %>%
  select(-study)

# Simple Regression -------------------------------------------------------

# we specify a *model* with a formula:
class(y ~ x)

# we fit Linear Models with `lm`:
fit <- lm(anxious ~ calm, data = sai_AGES)
fit

predict(fit)
residuals(fit)
# what is the correlation between these ^ two?

# beta
parameters_standardize(fit, method = "classic")

# ci
confint(fit)
plot(model_parameters(fit))

# bootstrap
parameters_bootstrap(fit)

# model indices
model_performance(fit)
rmse(fit)
r2(fit) # and more...


# Multiple Regression -----------------------------------------------------

fit2 <- lm(anxious ~ calm + tense + worrying, sai_AGES)
summary(fit2)
parameters_standardize(fit2, method = "classic")
confint(fit2)
plot(model_parameters(fit2))
parameters_bootstrap(fit2)
model_performance(fit22)

# how will this affect the results?
sai_AGES$tense_100 <- sai_AGES$tense * 100
fit3 <- lm(anxious ~ calm + tense_100 + worrying, sai_AGES)
summary(fit2)
summary(fit3)



# all variables in a data.frame (almost never useful)
fit_all <- lm(anxious ~ ., sai_AGES)
summary(fit_all)


# Exercise ----------------------------------------------------------------

# 1. Predict `joyful` from two predictors for your choice.
#    a. Which of the two has the bigger contribution to predicting joyfulness?
#    b. What is the 80% CI for the second predictor?
#    c. What is the R^2 of the model?
# 2. Plot (with ggplot) the tri-variate relationship.
# 3. Add the predicted values to the data.frame. Plot them (with ggplot2,
#    duh) in relation to the true values. Use geom_smooth.
# *. What does `update` do?
