library(dplyr)
library(effectsize) # for parameters_standardize
library(parameters) # for model_parameters
library(performance) # for model_performance etc..
# will also need `psychTools` for dataset
# will also need `see` for plotting

# load a data set
sai <- psychTools::sai
head(sai)
?psychTools::sai

sai_AGES <- sai %>%
  filter(study == "AGES") %>%
  select(-study)

# Simple Regression -------------------------------------------------------

# In R, models are build in two parts:
# 1. Describing the model.
# 2. Fitting the described model to some data (parameter estimation).


# Models are usually described with a formula:
y ~ x
# This can be read as "y is a function of x"


# To fit a Linear Model, we will use `lm`:
fit <- lm(anxious ~ calm, data = sai_AGES)
fit

summary(fit) # see df, sig and more...



predict(fit)
residuals(fit)
# what is the correlation between these ^ two?


## CIs
confint(fit)

## beta
standardize_parameters(fit, method = "basic")
# We can get the CIs for Beta with
model_parameters(fit, standardize = "basic")



# nice printing method:
reg_table <- model_parameters(fit, standardize = "basic")
reg_table
plot(reg_table)





## model indices
model_performance(fit)
rmse(fit)
r2(fit) # and more...





# Multiple Regression -----------------------------------------------------

# Multiple predictors in a formula are specified with "+":
fit2 <- lm(anxious ~ calm + tense + worrying, data = sai_AGES)
summary(fit2)


# how will this affect the results?
sai_AGES$tense_100 <- sai_AGES$tense * 100


fit3 <- lm(anxious ~ calm + tense_100 + worrying, sai_AGES)
summary(fit2)
summary(fit3)


# Get Beta
model_parameters(fit2, standardize = "basic")




# All variables in a data.frame are predictors (almost never useful)
fit_all <- lm(anxious ~ ., sai_AGES)
summary(fit_all)




# Exercise ----------------------------------------------------------------

# 1. Predict `joyful` from two predictors of your choice.
#    a. Which of the two has the bigger contribution to predicting
#       joyfulness?
#    b. What is the 80% CI for the second predictor?
#    c. What is the R^2 of the model?
# 2. Plot (with ggplot) the tri-variate relationship.
# 3. Add the predicted values to the data.frame.
#    Plot (with ggplot2, duh) the relation to the true values.
#    a. Use `geom_smooth`.
#    b. Why is the slope positive?
#    c. What does the correlation between the two represent?
# *. What does `update` do?
