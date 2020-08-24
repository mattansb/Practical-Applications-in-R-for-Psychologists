
# GLMs (generalized linear models) allow modeling of non-linear dependent
# variables.
#
# Unlike linear models, where the model is fit to the outcome directly, in GLMs
# the model is fit to some function of the outcome - f(outcome) - where this
# function is called the "link function".

# You can see a list of families and link functions provided by R (but there are
# many more!)
?family

# Thess link function can make interpretation of the models a bit less
# straightforward, but we will demonstrate how to do just this in the two most
# common GLMs: logistic regression and Poisson regression.


library(parameters)
library(performance)
library(ggeffects)
library(emmeans)

depression_language <- read.csv("depression_language.csv")
depression_language$is.depressed <- factor(depression_language$is.depressed)
head(depression_language)
# The variables:
#   is.depressed            - is the participant depressed?
#   neg_emotion_words_count - In a free association task, how many negative
#                             words were used?
#   mean_valence            - In a free association task, how positive were the
#                             words on average?



# 1. Logistic Regression --------------------------------------------------

# In this example we will explore a logistic regression model. This model is
# suited for binary outcomes, and the link function is the logit function,
# where:
#
# mu ~ a + b * X
#
# and
#
# Pr(DV==1) = 1 / (1 + exp(-mu))
#
# log(Pr(DV==1)/Pr(DV==1)) = mu
#
# When comparing two probabilities or odds, the ratio between the odds is called
# the OR (Odds Ratio), which is what is usually reported for comparisons.

# we will try to predict depression from mean_valence

fit <- glm(is.depressed ~ mean_valence,
           data = depression_language,
           family = binomial()) # we need to specify the family!


model_parameters(fit, standardize = "basic")
# Note that the standardization is only on the predictors, as the outcome
# variable is binary and has no scale! (Yes... This is very tricky stuff)...


model_performance(fit)
# These are slightly different indices than from linear models...
# For example, since the predictor has not variance, `R2_Tjur` isn't really a
# measure of variance explained. You can read more about these in the function's
# documnetation.





# Making sense of coefficients --------------------------------------------

# 1. The Y in the model has no variance, to the standardized coefficient
#   represents the change in the *logit* variable after a change in 1 SD of X.
#   This has a different interpretation than the classic "beta", but still
#   allows for comparing between predictors.
# 2. The coefficients are the log of the change in odds (change in odds is also
#   called the odds ratio: OR). To get the change in odds ratio (that is
#   P(y==1) / (1 - P(y==1))), we can:
exp(coef(fit)) # get the odds-change


# From this we can learn that:
# 1. When the valance is 0 (as negative as possible), the odds of being
#   depressed are 15.8, or P(y==depressed) = 15.8 / (1 + 15.8) = 0.94!
# 2. For every increase in valence, the odds DECREASE by a factor of 0.62, so
#   someone with a valance of 6 (around the median) will have:
#   mu = 2.76 + -0.48 * mean_valence
#   = 2.76 + -0.48 * 6
#   = -0.12
#
#   P(y==depressed) = 1 / (1 + exp(-mu)) =
#   = 1 / (1 + exp(--0.12))
#   = 0.47
#
# We can use the `plogis()` function to convert mu to P(y==1):
plogis(2.76 + -0.48 * 6)
# we can also use the `qlogis()` to convert P(y==1) to mu:
qlogis(0.4700359)

# Note that change in odds are easier to interpret when the predictor is
# categorical, where we can compare groups. But for continuous predictors, we
# need to pick-a-point to see the change between the two points!



# predicted values: on the link vs response scale -------------------------

# The function `predict` returns the result of the linear part of the model.
# That is, it returns the values of the logit, mu:
predict(fit)

# For predictions on the response scale - the transformed mu values - that it
# the P(y==1):
predict(fit, type = "response")
# We will see many more examples of predicting and categorization next semester
# in the Machine Learning module.



plot(ggemmeans(fit, "mean_valence [all]"), add.data = TRUE)



# latent vs outcome analysis ----------------------------------------------

# Although the latent (logit) and the outcome (probability) are transformations
# of one another (but not a linear transformation!), analyses on the different
# levels can yield different results!

# We will use `emmeans` for this demonstration, where we will analyze the SAME
# effect in 3 different ways.

## ---------------------- ##
## 1. On the latent level ##
## ---------------------- ##

# These are expected means (predicted values) on the log-odds scale.
em_logit <- emmeans(fit, ~ mean_valence,
                    at = list(mean_valence = c(5,4)))
em_logit

# We can see the that difference between them is the same as the coefficient we
# got:
pairs(em_logit, type = "response")





## ------------------------------------- ##
## 2. On the response level: differences ##
## ------------------------------------- ##


em_prob <- emmeans(fit, ~ mean_valence,
                   at = list(mean_valence = c(5,4)),
                   trans = "response")
em_prob


# The difference between them:
pairs(em_prob, type = "response")





## -------------------------------- ##
## 3. On the response level: ratios ##
## -------------------------------- ##

# Finally, here is how to get RR (risk ratios, an alternative to OR):
# (read more about RR: doi.org/10.1097/SMJ.0b013e31817a7ee4)


em_prob2 <- emmeans(fit, ~ mean_valence,
                    at = list(mean_valence = c(5,4)),
                    trans = "log")
em_prob2


# The difference between the logs = the ratio of the probs:
pairs(em_prob2, type = "response")




# This section is based on:
# https://shouldbewriting.netlify.com/posts/2020-04-13-estimating-and-testing-glms-with-emmeans/






# 2. Poisson Regression ---------------------------------------------------

# Poisson regression is suitable for count outcomes, and the link function is:
# mu = a + b * X
#
# and
#
# rate = exp(mu)
#
# When comparing two rates, the ratio between them is called the IRR (Incidence
# Rate Ratio), which is what is usually reported for comparisons.

fit2 <- glm(neg_emotion_words_count ~ is.depressed,
            data = depression_language,
            family = poisson())

model_parameters(fit2, standardize = "basic")
# (these results make no sense).


model_performance(fit2)






# Exercise ----------------------------------------------------------------


# 1. Plot (with `ggeffects`) the relationship between depression and the rate of
#   negative words. Interpret these results.
# 2. Predict the number of negative words for a non-depressed person for found
#   the words to have a mean_valence of 7.4.
# 3. Build a second Poisson model with `mean_valence` as an additional
#   predictor. Compare this model to the first model (use `anova()`).
# 4. In Poisson models, we can also conduct an follow-up analysis (with
#   `emmeans`) on the latent or on the outcome level. Compare the levels of
#   `is.depressed` on both levels.

