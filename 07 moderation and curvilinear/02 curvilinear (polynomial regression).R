
library(performance) # for compare_performance, r2
library(parameters) # for model_parameters
library(ggplot2)
library(ggeffects) # model plotting


parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)


# So far we've only looked at linear models and associations - but there can be
# many different types of models or associations! Later on we will look at
# modeling non-Gaussian data, but today we will look at a type of non-linear
# prediction - polynomial regression.




# A linear model ----------------------------------------------------------

# 1. Fit the model
m_lin <- lm(child_satisfaction ~ parental_strictness, parental_iris)
model_parameters(m_lin)



# 2. Explore
plot(ggemmeans(m_lin, "parental_strictness"), add.data = TRUE)

# Wow, that looks wrong! (See how important it is to plot the data points??)
# It seems like we need to model something more complex...






# Curvilinear -------------------------------------------------------------

# Polynomial regression allows to model predictors with the form of:
#   X + X^2 + X^3 + ... + X^k.
# This type of model is often called a "curvilinear" model.


# 1. Fit the model
# We can fit it using the `poly()` function:
m_curvi <- lm(child_satisfaction ~ poly(parental_strictness, 2), parental_iris)
# we can also have X^3 with poly(x,3), etc...
# Note that the `poly` function also centers the predictor!

model_parameters(m_curvi)
model_parameters(m_curvi, standardize = "basic")

anova(m_lin, m_curvi)
compare_performance(m_lin, m_curvi)




# 2. Explore
plot(ggemmeans(m_curvi, "parental_strictness"), add.data = TRUE)
# This looks a lot better (not perfect, but better...)








# We can also plot both predicted lines:
parental_iris$Y_pred_lin <- predict(m_lin)
parental_iris$Y_pred_curvlin <- predict(m_curvi)

ggplot(parental_iris, aes(parental_strictness,child_satisfaction)) +
  geom_line(aes(y = Y_pred_lin, color = "Linear"), size = 1) +
  geom_line(aes(y = Y_pred_curvlin, color = "Poly"), size = 1) +
  geom_segment(aes(xend = parental_strictness, yend = Y_pred_lin, color = "Linear"),
               size = 1) +
  geom_segment(aes(xend = parental_strictness, yend = Y_pred_curvlin, color = "Poly"),
               size = 1) +
  geom_point()



# Even More ---------------------------------------------------------------

# We can fit even more complex associations with GAMs (generalized additive
# models) or even more complex models all together with machine learning
# techniques (see next semester).


