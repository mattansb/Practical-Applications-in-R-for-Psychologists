

library(effectsize)   # for parameters_standardize
library(parameters)   # for model_parameters
library(performance)  # for model_performance etc..
library(ggeffects)    # for plotting models



# load a data set
salary <- read.csv("salary.csv")
head(salary)
# - salary:     Shekels per month
# - xtra_hours: Hours over (weekly) over time worked
# - n_comps:    Number of compliments given to the boss
# - age:        Age in years.
# - seniority:  Number of years working in the company



# Simple Regression -------------------------------------------------------

# In R, models are build in two parts:
# 1. Specifying the model.
# 2. Fitting the model to some data.


# Models are usually described with a formula:
y ~ x
# This can be read as "y is a function of x"



# To fit a Linear Model, we will use `lm`:
fit <- lm(salary ~ xtra_hours, data = salary)
fit

# See df, sig and more...
summary(fit)


## Explore the model's parameter:
# CIs
confint(fit)

# beta
standardize_parameters(fit, method = "basic")

# Get all at once:
model_parameters(fit)
model_parameters(fit, standardize = "basic")








## Model indices
rmse(fit)
r2(fit) # and more...
model_performance(fit)




## Prediction and residuals
predict(fit)
residuals(fit)
# what is the correlation between these ^ two?

# We can also predict new data:
predict(fit, newdata = data.frame(xtra_hours = c(-3, 30)))
# We will see many more examples of these next semester in the Machine Learning
# module.


## Plot
plot(ggpredict(fit, "xtra_hours"))
plot(ggpredict(fit, "xtra_hours"), add.data = TRUE)
# see more: https://strengejacke.github.io/ggeffects








# Multiple Regression -----------------------------------------------------

# Multiple predictors in a formula are specified with "+":
fit2 <- lm(salary ~ xtra_hours + n_comps, data = salary)
summary(fit2)


# how will this affect the results?
salary$xtra_minutes <- salary$xtra_hours * 60


fit3 <- lm(salary ~ xtra_minutes + n_comps, data = salary)
model_parameters(fit2)
model_parameters(fit3)



## Get Beta and R2
model_parameters(fit2, standardize = "basic")
r2(fit2)


## Predict
newdata <- data.frame(xtra_hours = c(0, 5),
                      n_comps = c(-1, 2)) # what are negative compliments??
predict(fit2, newdata = newdata)



## Plot
plot(ggpredict(fit2, "xtra_hours"), add.data = TRUE)
plot(ggpredict(fit2, "n_comps"), add.data = TRUE)
plot(ggpredict(fit2, c("xtra_hours", "n_comps")), add.data = TRUE)

# The lines in the last are exactly parallel - why?

# for multiple regression, you might want to use partial residuals instead of
# the raw data, by setting `residuals = TRUE`. See:
# https://strengejacke.github.io/ggeffects/articles/introduction_partial_residuals.html


# More Syntax -------------------------------------------------------------

# If we have non-linear relationships, we can specify any transformations in the
# formula:
fit_seniority <- lm(salary ~ log(seniority), data = salary)
plot(ggpredict(fit_seniority, "seniority"))



# Predict from all variables in the data.frame with a `.` (almost never useful):
fit_all <- lm(salary ~ ., data = salary)
summary(fit_all)






# Exercise ----------------------------------------------------------------

sai <- psychTools::sai
head(sai)
?psychTools::sai


# 1. Predict `joyful` from two predictors of your choice.
#   a. Which of the two has the bigger contribution to predicting
#     joyfulness?
#   b. What is the 80% CI for the second predictor? (see ?model_parameters.glm)
#   c. What is the R^2 of the model?
# 2. Plot (with `ggemmeans()`) the tri-variate relationship.
# 3. What does `update` do?
# *. In the `salary` example, what would you recommend to someone who wants a
#   higher salary to do - work more? or compliment their boss more?
