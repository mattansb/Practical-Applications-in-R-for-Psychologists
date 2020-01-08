#' GLMs (generalized linear models) allow modeling of non-linear
#' dependant variables.
#'
#' Unlike LMs, where the model is fit to the DV, in GLMs the model
#' is fit to some function of the DV, or f(DV) where this function
#' is called the "link function".
#'
#' In this example we will explore a logistic regression model.
#' This model is suited for binary DVs, and the link function
#' is the logit function, where:
#' mu ~ a + b * X
#' and
#' Pr(DV==1) ~ 1 / (1 + exp(-mu))


library(parameters)
library(performance)
library(ggplot2)

depression_language <- read.csv("depression_language.csv")
head(depression_language)
# The variables:
# - is.depressed            - is the participant depressed?
# - neg_emotion_words_count - In a free association task, how many negative words were used?
# - mean_valence            - In a free association task, how positive were the words on average?

# we will try to predict depression from mean_valence

fit <- glm(is.depressed ~ mean_valence,
           data = depression_language,
           family = binomial()) # we need to specify the family!

model_parameters(fit, standardize = "basic")
#> Parameter    | Coefficient | Coefficient (std.) |   SE |         95% CI |     z |  df |     p
#> ---------------------------------------------------------------------------------------------
#> (Intercept)  |        2.76 |               0.00 | 1.31 | [ 0.25,  5.43] |  2.10 | 198 | 0.036
#> mean_valence |       -0.48 |              -0.33 | 0.22 | [-0.92, -0.06] | -2.21 | 198 | 0.027

model_performance(fit)
#> # Indices of model performance
#>
#>     AIC     BIC R2_Tjur  RMSE LOGLOSS SCORE_LOG SCORE_SPHERICAL   PCP
#> 275.396 281.993   0.025 1.165   0.678   -58.811           0.006 0.514

# These are slightly different indices than from linear models...

# Making sense of coefficients --------------------------------------------

# 1. The Y in the model has no variance, to the standerdized coefficiant represents the
#    change in the logit variable after a change in 1 SD of X. This has a different interpertation
#    than the classic "beta", but still allows for comparing among predictors.
# 2. The coefficients are the log of the change in odds ratio.
#    To get the change in odds ratio (that is P(y==1) / (1 - P(y==1))),
#    we can:
exp(coef(fit)) # get the odds-change
#> (Intercept) mean_valence
#>  15.8065673    0.6195958

# From this we can learn that:
# 1. When the valance is 0 (as negative as possible), the odds of being depressed are 15.8,
#    or P(y==depressed) = 15.8 / (1 + 15.8) = 0.94!
# 2. For every increase in valence, the odds DECREASE by 0.62, so someone with a valance
#    of 6 (around the median) will have:
#    mu = 2.76 + -0.48 * mean_valence = 2.76 + -0.48 * 6 = -0.12
#    P(y==depressed) = 1 / (1 + exp(-mu)) = 1 / (1 + exp(--0.12)) = 0.47


# predicted vs fitted values ----------------------------------------------

# The function `predict` returns the result of the linear part of the model.
# That is, it returns the values of the logit mu:
predict(fit)

# The function `fitted` returns the transformed mu values, that it the
# P(y==1):
fitted(fit)


depression_language$pred <- fitted(fit)

ggplot(depression_language, aes(mean_valence, is.depressed)) +
  geom_point() +
  geom_line(aes(y = pred))


# Other GLMs --------------------------------------------------------------

# You can see a list of families provided by R (but there are many more!)
?family

# The common ones:
# - gaussian() - For "regular" linear models with linear DVs.
# - binomial() - For logistic regression with binary DVs.
# - poisson()  - For poisson regression with count DVs, e.g.:

fit2 <- glm(neg_emotion_words_count ~ is.depressed,
            data = depression_language,
            family = poisson())
model_parameters(fit2)
# looks like depressed people use exp(mu) = exp(-0.15) = 0.86 times LESS
# negative words (these results make no sense).
