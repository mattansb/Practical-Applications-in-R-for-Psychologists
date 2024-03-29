

# Although this course is focused for the most part on linear regression models,
# the principles of modeling are quite consistent across all types of models
# that you can build in R:
# - *Build* a model:
#   - Specify a model
#   - Estimate its parameters
# - *Evaluate* the model's fit
# - *Explore* the model (predict, plot, estimate...)
# And so everything taught here and in the next few of lessons is also relevant
# to those interested in machine learning, mixed models, structural equation
# modeling, ANOVAs, and more and more...

library(effectsize)   # for parameters_standardize
library(parameters)   # for model_parameters
library(performance)  # for model_performance etc..
library(ggeffects)    # for plotting models


# load a data set
data(hardlyworking, package = "effectsize")
head(hardlyworking)
# - salary      : Shekels per month
# - xtra_hours  : Hours over (weekly) over time worked
# - n_comps     : Number of compliments given to the boss
# - age         : Age in years.
# - seniority   : Number of years working in the company



# Simple Regression -------------------------------------------------------

# In R, models are build in two parts:
# 1. *Specifying* the model:
#   What are the parameters we want to estimate?
# 2. *Fitting* the model to some data:
#   Actually estimate the parameters using some data.


# Models are usually specified with a formula:
y ~ x
# This can be read as "y is a function of x" or "y is predicted by x"

# Different model types require different fitting functions (we will get back to
# this later on in the semester, and in the following semester) - to fit a
# Linear Model, we will use `lm()`:
fit <- lm(salary ~ xtra_hours, data = hardlyworking)
fit

# Now that we have the model, we can evaluate and explore it!


# Some basic stuff: estimate, SE, test values, and more...
summary(fit)


## Explore the model's *parameters* ----

# CIs
confint(fit)

# beta
standardize_parameters(fit, method = "basic")


# Get all at once:
model_parameters(fit)
model_parameters(fit, standardize = "basic")








## Evaluate the model ----
# Look at some model indices
rmse(fit) # or mae(fit)
r2(fit) # and more...
model_performance(fit)




## Prediction ----
# and residuals
predict(fit)
residuals(fit)
# what is the correlation between these ^ two?

# We can also predict new data:
(new_observations <- data.frame(xtra_hours = c(-15, 30)))
predict(fit, newdata = new_observations)
# We will see many more examples of these next semester in the Machine Learning
# module.


## Plot ----
gge_xtra_hours <- ggpredict(fit, "xtra_hours")
gge_xtra_hours
plot(gge_xtra_hours)
plot(gge_xtra_hours, add.data = TRUE, jitter = 0)
# see more: https://strengejacke.github.io/ggeffects








# Multiple Regression -----------------------------------------------------

# Multiple predictors in a formula are specified with "+":
fit2 <- lm(salary ~ xtra_hours + n_comps, data = hardlyworking)

summary(fit2)


## Explore the model's *parameters* ----
model_parameters(fit2)
model_parameters(fit2, standardize = "basic") # Get Betas


# how will this affect the results?
hardlyworking$xtra_minutes <- hardlyworking$xtra_hours * 60

fit3 <- lm(salary ~ xtra_minutes + n_comps, data = hardlyworking)

model_parameters(fit2)
model_parameters(fit3)



## Evaluate the model ----
model_performance(fit2)





## Predict ----
new_obs2 <- data.frame(xtra_hours = c(0, 5),
                       # What are negative compliments??
                       # What is HALF a compliment??
                       n_comps = c(1.5, -2))
new_obs2
predict(fit2, newdata = new_obs2)




## Plot ----
ggpredict(fit2, "xtra_hours")               |> plot(add.data = TRUE, jitter = 0)
ggpredict(fit2, "n_comps")                  |> plot(add.data = TRUE, jitter = 0.1) # jitter?
ggpredict(fit2, c("xtra_hours", "n_comps")) |> plot(add.data = TRUE, jitter = 0)
# The lines in the last plot are exactly parallel - why?



# for multiple regression, you might want to use partial residuals instead of
# the raw data, by setting `residuals = TRUE`. See:
# https://strengejacke.github.io/ggeffects/articles/introduction_partial_residuals.html









# More Syntax -------------------------------------------------------------

# If we have non-linear relationships, we can also pre-transform the data,
# BUT... we can also specify any transformations in the formula:
fit_seniority <- lm(salary ~ sqrt(seniority), data = hardlyworking)

ggpredict(fit_seniority, "seniority") |>
  plot(add.data = TRUE, jitter = 0.1)



# Predict from all variables in the data.frame with a `.` (almost never useful):
fit_all <- lm(salary ~ ., data = hardlyworking)
summary(fit_all)
# (Note that xtra_hours and xtra_minutes are fully colinear - we will see how we
# might examine this in later lessons.)



# If we want to fit a model without any predictors (called the empty model, or
# the intercept-only model):
fit_intercept <- lm(salary ~ 1, data = hardlyworking)
summary(fit_intercept)
predict(fit_intercept) # What's going on here?



# Exercise ----------------------------------------------------------------

sai <- psychTools::sai
head(sai)
?psychTools::sai


# 1. Fit a linear model, predicting `joyful` from two variables of your choice.
#   a. Interpret the model's parameters.
#   b. Which of the two has the bigger contribution to predicting joy?
#   c. What is the 80% CI for the second predictor? (see ?model_parameters.glm)
#   d. What is the R^2 of the model?
# 2. Plot (with `ggpredict()`) the tri-variate relationship (the relationship
#   between the outcome, `joyful`, and the two predictors).
# *. What does `update` do?
# **. In the `salary` example, what would you recommend to someone who wants a
#   higher salary to do - work more? or compliment their boss more?
