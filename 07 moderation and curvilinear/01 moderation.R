
library(dplyr)
library(performance) # for `compare_performance()`
library(emmeans) # for simple slope analysis
library(ggeffects) # for model plotting

parental_iris <- read.csv("parental_iris.csv")

glimpse(parental_iris)
head(parental_iris)

# Last time we saw that R doesn't need you to make dummy variables - if can deal
# with factors just fine.
# Today we will see that this is also true for moderation and interactions!
# (I will not be showing how to do these the long way...)





# Categorical moderator ---------------------------------------------------

# Let's prep the data for modeling:
parental_iris <- parental_iris %>%
  mutate(attachment = relevel(factor(attachment), ref = "secure"),
         involvement_c = scale(parental_involvement,center = TRUE, scale = FALSE))
# Here we don't want to get z scores (or maybe we do?) just to center the
# variable around 0.





# 1. Fit the model(s) -----------------------------------------------------
m_additive <- lm(child_satisfaction ~ involvement_c + attachment,
                 data = parental_iris)


# all you need is to tell R to add an interaction!
m_moderation <- lm(child_satisfaction ~ involvement_c + attachment + involvement_c:attachment,
                   data = parental_iris)
# or use `*` -- A * B = A + B + A:B
m_moderation <- lm(child_satisfaction ~ involvement_c * attachment,
                   data = parental_iris)

anova(m_additive, m_moderation)
compare_performance(m_additive, m_moderation)
summary(m_moderation) # for comparison







# 2. Explore the model  ---------------------------------------------------
# simple slope analysis!

emtrends(m_moderation, ~attachment, "involvement_c") %>%
  summary(infer = TRUE)
# (we can also use contrasts here to COMPARE slopes)



plot(ggemmeans(m_moderation, c("involvement_c","attachment")), add.data = TRUE)








# Continuous moderator ----------------------------------------------------

## Prep the data
parental_iris$strictness_c <- scale(parental_iris$parental_strictness, TRUE, FALSE)



# 1. Fit the model(s) -----------------------------------------------------

m_additive <- lm(child_satisfaction ~ involvement_c + strictness_c,
                 data = parental_iris)
m_moderation <- lm(child_satisfaction ~ involvement_c * strictness_c,
                   data = parental_iris)

# compare models:
anova(m_additive, m_moderation)
compare_performance(m_additive, m_moderation)

summary(m_moderation)








# 2. Explore the model  ---------------------------------------------------
# simple slope analysis!

emtrends(m_moderation, ~strictness_c, "involvement_c",
         cov.reduce = list(strictness_c = values_at)) %>%
  # `cov.reduce = list(strictness_c = values_at)` tells `emtrends()` to get the
  # mean +-sd of `strictness_c`.
  summary(infer = TRUE)
# (we can also use contrasts here to COMPARE slopes)


plot(ggemmeans(m_moderation, c("involvement_c","strictness_c [meansd]")), add.data = TRUE)



# Once again, note that in R, model fitting and hypothesis testing are not as
# closely knit as they are in SPSS. For simple slope analysis, in SPSS, we would
# re-fit new models for each simple slope, in R we instead (1) fit a model, (2)
# test the simple slope of interest.






# Exercise ----------------------------------------------------------------

# 1. Using the `interactions` package, plot a Johnson-Neyman plot
#   (`interactions::johnson_neyman()`). What does it do?
# 2. Fit the same moderation model with the un-centered predictors. How does it
#   differ from the moderation model with the centered predictors?
#   A. How do the parameters differ?
#   B. How does the model fit (R^2) differ?
#   C. How does the simple slopes analysis differ?

