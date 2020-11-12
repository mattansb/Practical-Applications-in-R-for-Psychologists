
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
# common GLMs: binomial (logistic) regression and Poisson regression.

# Suggested reading: Chapter 15 in Fox, J. (2015). Applied regression analysis
# and generalized linear models. Sage Publications.


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




# 1. Binomial Regression --------------------------------------------------

# In this example we will explore a binomial regression model, which is suitable
# for binary outcomes. The most common link function for modeling such data is
# the logit function, which is why most often people just call this type of
# model "logistic regression", where:
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
# variable is binary and has no scale! (Yes... This is very tricky stuff) - so
# the standardized coefficient represents the change in the *logit* variable
# after a change in 1 SD of X. This has a different interpretation than the
# classic "beta", but still allows for comparing between predictors.

# we can exponentiate (with `exp()`) these results, or we can directly ask
# `model_parameters()` to do that for us:
model_parameters(fit, standardize = "basic", exponentiate = TRUE)


model_performance(fit)
# These are slightly different indices than from linear models...
# For example, since the predictor has not variance, `R2_Tjur` isn't really a
# measure of variance explained. You can read more about these in the function's
# documentation.





# Making sense of coefficients --------------------------------------------

# The coefficients are the log of the change in odds (change in odds is also
# called the odds ratio: OR). To get the change in odds ratio (that is
# P(y==1) / (1 - P(y==1))), we can:
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






# Follow-up analyses: on the link vs response scale -----------------------

# We have the same link/response problem when conducting follow-up analyses (contrasts,
# simple slopes, simple effects, etc.). We will usually prefer to look at the response scale,
# as this is usually what we're interested in (who cares about the log of the odds??).

# `ggeffects` plots the response scale by default:
plot(ggemmeans(fit, "mean_valence [all]"), add.data = TRUE)




# For `emmeans`, we need only add `type = "response"` to get the estimates on
# the response scale.

(em_resp <- emmeans(fit, ~ mean_valence,
                    at = list(mean_valence = c(5,4)),
                    type = "response"))

contrast(em_resp, method = "pairwise")



# Compare to the log-odds link - very hard to interpret:
(em_logit <- emmeans(fit, ~ mean_valence,
                     at = list(mean_valence = c(5,4))))
contrast(em_logit, method = "pairwise")





# Of course, things are always more complicated... You can read more about
# different types of follow-up analyses of GLMs here:
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
model_parameters(fit2, standardize = "basic", exponentiate = TRUE)
# (these results make no sense).


model_performance(fit2)



# Even MORE ---------------------------------------------------------------

# Logistic and Poisson regression models are the most popular GLMs, but they are
# not the only ones. There are models for *ordinal* outcomes, for *truncated*
# outcomes, for *reaction times*, and more and more and more...
#
# See a short review of the different outcomes and their corresponding models
# and packages: http://htmlpreview.github.io/?https://github.com/strengejacke/mixed-models-snippets/blob/master/overview_modelling_packages.html
# and for RTs: https://lindeloev.github.io/shiny-rt/


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

