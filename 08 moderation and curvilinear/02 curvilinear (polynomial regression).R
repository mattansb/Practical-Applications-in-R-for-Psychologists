library(ggplot2)

library(performance) # for compare_performance, r2
library(parameters) # for model_parameters
library(bayestestR) # for `bayesfactor_models()`
library(marginaleffects)


parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)


# So far we've only looked at linear models and associations - but there can be
# many different types of models or associations! Later on we will look at
# modeling non-Gaussian data, but today we will look at a type of non-linear
# prediction - polynomial regression.

# A linear model ----------------------------------------------------------

# 1. Fit the model
m_lin <- lm(child_satisfaction ~ parental_strictness, data = parental_iris)
model_parameters(m_lin)

# 2. Explore
plot_predictions(m_lin, condition = "parental_strictness", points = 1)

# Wow, that looks wrong! (See how important it is to plot the data points??)
# It seems like we need to model something more complex...

# A curvilinear model -----------------------------------------------------

# Polynomial regression allows to model predictors with the form of:
#   X + X^2 + X^3 + ... + X^k.
# This type of model is often called a "curvilinear" model.

# Polynomial regression is a type of regression analysis in which the
# relationship between the independent variable and the dependent variable is
# modeled as a polynomial function. This type of regression is useful when the
# relationship between the variables is non-linear, and it can provide a more
# accurate model of the data than linear regression, which only models the data
# as a straight line.

# A polynomial regression model is defined by the degree of the polynomial
# function, which is the highest power of the independent variable in the
# function. For example, a first-degree polynomial regression model has a linear
# function, a second-degree polynomial regression model has a quadratic
# function, and a third-degree polynomial regression model has a cubic function.
# Higher-degree polynomial regression models can have more complex shapes, but
# they can also be more sensitive to outlier data points and may not generalize
# well to new data.

# A first-degree polynomial function is called a linear function.
# A second-degree polynomial function is called a quadratic function.
# A third-degree polynomial function is called a cubic function.
# A fourth-degree polynomial function is called a quartic function.
# A fifth-degree polynomial function is called a quintic function.

## 1. Fit the model ----
# We can fit it using the `poly()` function:
m_curvi <- lm(
  child_satisfaction ~ poly(parental_strictness, 2),
  data = parental_iris
)
# we can also have X^3 with poly(x,3), etc...
# Note that the `poly` function also centers the predictor!

model_parameters(m_curvi)
# model_parameters(m_curvi, standardize = "basic")

compare_performance(m_lin, m_curvi)
anova(m_lin, m_curvi)


# Each coefficient in a polynomial regression model can be interpreted as the
# direct influence on the dependent variable when all other coefficients are
# held constant. For example, in the above model, if you hold the constant and
# linear terms constant, the value of the dependent variable will be directly
# influenced by the value of the quadratic term.

## 2. Explore ----
plot_predictions(m_curvi, condition = "parental_strictness", points = 1)
# This looks a lot better (not perfect, but better...)

# We can also plot both predicted lines:
ggplot(mapping = aes(x = parental_strictness)) +
  geom_line(
    aes(y = estimate, color = "Linear"),
    data = predictions(m_lin, condition = "parental_strictness")
  ) +
  geom_line(
    aes(y = estimate, color = "Poly, 2"),
    data = predictions(m_curvi, condition = "parental_strictness")
  ) +
  geom_point(
    aes(y = child_satisfaction),
    data = parental_iris
  )

# Even More ---------------------------------------------------------------

# We can fit even more complex associations with GAMs (generalized additive
# models) or even more complex models all together with machine learning
# techniques (see next semester).
