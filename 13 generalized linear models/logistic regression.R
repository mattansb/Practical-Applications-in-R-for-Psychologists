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
library(emmeans)

depression_language <- read.csv("depression_language.csv")
head(depression_language)
# The variables:
# - is.depressed            - is the participant depressed?
# - neg_emotion_words_count - In a free association task, how many negative
#                             words were used?
# - mean_valence            - In a free association task, how positive were
#                             the words on average?

# we will try to predict depression from mean_valence

fit <- glm(is.depressed ~ mean_valence,
           data = depression_language,
           family = binomial()) # we need to specify the family!

model_parameters(fit, standardize = "basic")
#> Parameter    | Coefficient (std.) |   SE |         95% CI |     z |  df |     p
#> -------------------------------------------------------------------------------
#> (Intercept)  |               0.00 | 0.00 | [ 0.00,  0.00] |  2.10 | 198 | 0.036
#> mean_valence |              -0.33 | 0.15 | [-0.62, -0.04] | -2.21 | 198 | 0.027

# Note that the standardization is only on the predictors, as the dependant
# variable is binary and has no scale! (Yes... This is very tricky
# stuff)...

model_performance(fit)
#> # Indices of model performance
#>
#>     AIC     BIC R2_Tjur  RMSE LOGLOSS SCORE_LOG SCORE_SPHERICAL   PCP
#> 275.396 281.993   0.025 1.165   0.678   -58.811           0.006 0.514

# These are slightly different indices than from linear models...
# For example, since the predictor has not variane, `R2_Tjur` isn't really
# a measure of variance explained.

# Making sense of coefficients --------------------------------------------

# 1. The Y in the model has no variance, to the standerdized coefficiant
#    represents the change in the logit variable after a change in 1 SD
#    of X. This has a different interpertation than the classic "beta",
#    but still allows for comparing among predictors.
# 2. The coefficients are the log of the change in odds ratio.
#    To get the change in odds ratio (that is P(y==1) / (1 - P(y==1))),
#    we can:
exp(coef(fit)) # get the odds-change
#> (Intercept) mean_valence
#>  15.8065673    0.6195958

# From this we can learn that:
# 1. When the valance is 0 (as negative as possible), the odds of being
#    depressed are 15.8, or P(y==depressed) = 15.8 / (1 + 15.8) = 0.94!
# 2. For every increase in valence, the odds DECREASE by 0.62, so someone
#    with a valance of 6 (around the median) will have:
#    mu = 2.76 + -0.48 * mean_valence = 2.76 + -0.48 * 6 = -0.12
#    P(y==depressed) = 1 / (1 + exp(-mu)) = 1 / (1 + exp(--0.12)) = 0.47
#
# We can use the `plogis()` function to convert mu to P(y==1):
plogis(2.76 + -0.48 * 6)
# we can also use the `qlogis()` to convert P(y==1) to mu:
qlogis(0.4700359)

# Note that change in odds ratio are easier to interpret when the
# predictor is categorical, where we can compare groups. But for
# continuous predictors, we need to pick-a-point to see the change between
# the two points!


# predicted vs fitted values ----------------------------------------------

# The function `predict` returns the result of the linear part of the
# model. That is, it returns the values of the logit mu:
predict(fit)

# The function `fitted` returns the transformed mu values, that it the
# P(y==1):
fitted(fit) # or
predict(fit, type = "response")



depression_language$pred <- fitted(fit)

ggplot(depression_language, aes(mean_valence, is.depressed)) +
  geom_point() +
  geom_line(aes(y = pred))



# latent vs outcome analysis ----------------------------------------------

# Although the latent (logit) and the outcome (probabilitiy) are
# transformations of one another, analyses on the different levels can
# yield different results!
# We will use `emmeans` for this demonastation, where we will analyze the
# SAME effect in 3 different ways.

## ---------------------- ##
## 1. On the latent level ##
## ---------------------- ##

# These are expected means (predicted values) on the log-odds scale.
em_logit <- emmeans(fit, ~ mean_valence,
                    at = list(mean_valence = c(5,4)))
em_logit
#> mean_valence emmean    SE  df asymp.LCL asymp.UCL
#>            5  0.367 0.264 Inf   -0.1505     0.884
#>            4  0.846 0.461 Inf   -0.0584     1.750
#>
#> Results are given on the logit (not the response) scale.
#> Confidence level used: 0.95

# We can see the that difference between them is the same as the
# coefficiant we got:
pairs(em_logit, type = "response")
#>  contrast odds.ratio    SE  df z.ratio p.value
#>  5 / 4          0.62 0.134 Inf -2.208  0.0272
#>
#> Tests are performed on the log odds ratio scale




## ------------------------------------- ##
## 2. On the response level: differences ##
## ------------------------------------- ##


em_prob <- emmeans(fit, ~ mean_valence,
                   at = list(mean_valence = c(5,4)),
                   trans = "response")
em_prob
#> mean_valence  prob     SE  df asymp.LCL asymp.UCL
#>            5 0.591 0.0638 Inf     0.466     0.716
#>            4 0.700 0.0969 Inf     0.510     0.890
#>
#> Confidence level used: 0.95

# The difference between them:
pairs(em_prob, type = "response")
#>  contrast estimate     SE  df z.ratio p.value
#>  5 - 4      -0.109 0.0388 Inf -2.807  0.0050





## -------------------------------- ##
## 3. On the response level: ratios ##
## -------------------------------- ##

# Finally, here is how to get RR (risk ratios, an alternative to OR):
# (read more about RR: doi.org/10.1097/SMJ.0b013e31817a7ee4)


em_prob2 <- emmeans(fit, ~ mean_valence,
                    at = list(mean_valence = c(5,4)),
                    trans = "log")
em_prob2
#>  mean_valence   prob    SE  df asymp.LCL asymp.UCL
#>             5 -0.526 0.108 Inf    -0.738   -0.3146
#>             4 -0.357 0.139 Inf    -0.629   -0.0856
#>
#> Results are given on the log (not the response) scale.
#> Confidence level used: 0.95

# The difference between the logs = the ratio of the probs:
pairs(em_prob2, type = "response")
#>  contrast ratio    SE  df z.ratio p.value
#>  5 / 4    0.844 0.037 Inf -3.860  0.0001
#>
#> Tests are performed on the log scale


# This section is based on:
# https://shouldbewriting.netlify.com/posts/2020-04-13-estimating-and-testing-glms-with-emmeans/


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
#> Parameter    | Coefficient |   SE |         95% CI |     z |  df |      p
#> -------------------------------------------------------------------------
#> (Intercept)  |        2.14 | 0.03 | [ 2.07,  2.20] | 64.17 | 198 | < .001
#> is.depressed |       -0.15 | 0.05 | [-0.25, -0.05] | -2.90 | 198 | 0.004

# looks like depressed people use exp(mu) = exp(-0.15) = 0.86 times LESS
# negative words (these results make no sense).

model_parameters(fit2, standardize = "basic")
#> Parameter    | Coefficient (std.) |   SE |         95% CI |     z |  df |      p
#> --------------------------------------------------------------------------------
#> (Intercept)  |               0.00 | 0.00 | [ 0.00,  0.00] | 64.17 | 198 | < .001
#> is.depressed |              -0.07 | 0.03 | [-0.12, -0.02] | -2.90 | 198 | 0.004


model_performance(fit2)
#> # Indices of model performance
#>
#>     AIC |     BIC | R2_Nagelkerke | RMSE | SCORE_LOG | SCORE_SPHERICAL
#> ----------------------------------------------------------------------
#> 1148.98 | 1155.58 |          0.05 | 1.40 |     -2.86 |            0.06


## On latent scale log-rate
em_log <- emmeans(fit2, ~ is.depressed)
em_log
#>  is.depressed emmean     SE  df asymp.LCL asymp.UCL
#>             0   2.14 0.0333 Inf      2.07      2.20
#>             1   1.99 0.0381 Inf      1.92      2.07
#>
#> Results are given on the log (not the response) scale.
#> Confidence level used: 0.95

pairs(em_log, type = "response")
#>  contrast ratio     SE  df z.ratio p.value
#>  0 / 1     1.16 0.0586 Inf 2.904   0.0037
#>
#> Tests are performed on the log scale

## On outcome scale (rate)
em_rate <- emmeans(fit2, ~ is.depressed,
                   trans = "response")
em_rate
#>  is.depressed rate    SE  df asymp.LCL asymp.UCL
#>             0 8.49 0.283 Inf      7.94      9.05
#>             1 7.33 0.279 Inf      6.78      7.88
#>
#> Confidence level used: 0.95

pairs(em_rate, type = "response")
#>  contrast estimate    SE  df z.ratio p.value
#>  0 - 1        1.16 0.398 Inf 2.920   0.0035
