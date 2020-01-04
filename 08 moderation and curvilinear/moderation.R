library(dplyr)

parental_iris <- read.csv("parental_iris.csv")

glimpse(parental_iris)
head(parental_iris)


# Categorical moderator (the long way) ------------------------------------

## 1. Prep the data
parental_iris_long_way <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = TRUE, scale = FALSE), # WHY DO WE CENTER VARIABLES?
    # dummy vars
    d_avoidant = as.numeric(attachment == "avoidant"),
    d_anxious  = as.numeric(attachment == "anxious"),
    # moderations vars
    avoidant_X_involvement = involvement_c * d_avoidant,
    anxious_X_involvement  = involvement_c * d_anxious
  )

## 2. Fit the model(s)
m_additive <- lm(child_satisfaction ~ involvement_c + d_avoidant + d_anxious,
                 data = parental_iris_long_way)

m_moderation <- lm(child_satisfaction ~ involvement_c + d_avoidant + d_anxious + avoidant_X_involvement + anxious_X_involvement,
                    data = parental_iris_long_way)

anova(m_additive, m_moderation)
summary(m_moderation) # what does each parameter mean?


## 3. Simple slopes analysis

# for avoidant
parental_iris_long_way2 <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = TRUE, scale = FALSE),
    # dummy vars
    d_secure  = as.numeric(attachment == "secure"),
    d_anxious = as.numeric(attachment == "anxious"),
    # moderations vars
    secure_X_involvement  = involvement_c * d_secure,
    anxious_X_involvement = involvement_c * d_anxious
  )

m_moderation2 <- lm(child_satisfaction ~ involvement_c + d_secure + d_anxious + secure_X_involvement + anxious_X_involvement,
                    data = parental_iris_long_way2)

summary(m_moderation2)


# for avoidant
parental_iris_long_way3 <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = c(scale(parental_involvement, center = TRUE, scale = FALSE)),
    # dummy vars
    d_secure   = as.numeric(attachment == "secure"),
    d_avoidant = as.numeric(attachment == "avoidant"),
    # moderations vars
    secure_X_involvement   = involvement_c * d_secure,
    avoidant_X_involvement = involvement_c * d_avoidant
  )

m_moderation3 <- lm(child_satisfaction ~ involvement_c + d_secure + d_avoidant + secure_X_involvement + avoidant_X_involvement,
                     data = parental_iris_long_way3)

summary(m_moderation3)


# Categorical moderator (the short way) -----------------------------------

## 1. Prep the data
parental_iris_short_way <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = TRUE, scale = FALSE),
    # recode so that "secure" is base group
    attachment = factor(attachment, levels = c("secure","avoidant","anxious"))
  )

## 2. Fit the model(s)
m_additive_short <- lm(child_satisfaction ~ involvement_c + attachment,
                 data = parental_iris_short_way)

m_moderation_short <- lm(child_satisfaction ~ involvement_c + attachment + involvement_c:attachment,
                    data = parental_iris_short_way)
# or:
m_moderation_short <- lm(child_satisfaction ~ involvement_c * attachment, # A * B = A + B + A:B
                        data = parental_iris_short_way)
anova(m_additive_short, m_moderation_short)
summary(m_moderation_short)
summary(m_moderation) # for comparison

model.matrix(m_moderation_short)

## 3. Simple slopes analysis
library(interactions)

sim_slopes(m_moderation_short, pred = involvement_c, modx = attachment,
           confint = TRUE)

## We can also compare simple slopes with contrasts using the `emmeans` package:
# library(emmeans)
# emtrends(m_moderation_short, ~ attachment, "involvement_c") %>%
#   summary(infer = TRUE)
## (we can also use contrasts here to COMPARE slopes)


# Continuous moderator (the short way) ------------------------------------

## 1. Prep the data
parental_iris_short_way <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, TRUE, FALSE),
    # center parental_strictness
    strictness_c = scale(parental_strictness, TRUE, FALSE),
  )

## 2. Fit the model(s)
m_additive_short <- lm(child_satisfaction ~ involvement_c + strictness_c,
                       data = parental_iris_short_way)
m_moderation_short <- lm(child_satisfaction ~ involvement_c * strictness_c,
                          data = parental_iris_short_way)
anova(m_additive_short, m_moderation_short)
summary(m_moderation_short)
model.matrix(m_moderation_short)

## 3. Simple slopes analysis

# get simple slopes
sim_slopes(m_moderation_short, pred = involvement_c, modx = strictness_c,
           modx.values = NULL, # pick-a-point, by default is M+-S
           confint = TRUE)


# Exercise ----------------------------------------------------------------

# 1. Fit the following moderation model:
#    child_satisfaction ~ parental_involvement * parental_strictness (uncentered!)
# 2. How does it differ from the moderation model with the centered predictors?
#    A. How do the parameters differ?
#    B. How does the model fit (R^2) differ?
#    C. How does the simple slopes analysis differ?
# 3. Using the `interactions` package:
#    A. Plot an interaction plot (`interact_plot`).
#    B. Plot a Johnson-Neyman plot (`johnson_neyman`). What does it do?
# *. Do the simple slopes analysis with `emmeans`.
