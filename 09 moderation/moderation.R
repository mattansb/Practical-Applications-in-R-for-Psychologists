library(dplyr)

parental_iris <- read.csv("parental_iris.csv")

head(parental_iris)



# Categorical moderator (the long way) ------------------------------------

## 1. Prep the data

parental_iris_long_way <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = T, scale = F),
    # dummy vars
    d_avoidant = as.numeric(attachment == "avoidant"),
    d_anxious  = as.numeric(attachment == "anxious"),
    # interactions vars
    avoidant_X_involvement = involvement_c * d_avoidant,
    anxious_X_involvement  = involvement_c * d_anxious
  )

## 2. Fit the model(s)

m_additive <- lm(child_satisfaction ~ involvement_c + d_avoidant + d_anxious,
                 data = parental_iris_long_way)

m_interaction <- lm(child_satisfaction ~ involvement_c + d_avoidant + d_anxious + avoidant_X_involvement + anxious_X_involvement,
                    data = parental_iris_long_way)

anova(m_additive, m_interaction)
summary(m_interaction) # what does each parameter mean?


## 3. Simple slopes analysis

# for avoidant
parental_iris_long_way2 <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = T, scale = F),
    # dummy vars
    d_secure  = as.numeric(attachment == "secure"),
    d_anxious = as.numeric(attachment == "anxious"),
    # interactions vars
    secure_X_involvement  = involvement_c * d_secure,
    anxious_X_involvement = involvement_c * d_anxious
  )

m_interaction2 <- lm(child_satisfaction ~ involvement_c + d_secure + d_anxious + secure_X_involvement + anxious_X_involvement,
                    data = parental_iris_long_way2)

summary(m_interaction2)


# for avoidant
parental_iris_long_way3 <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = T, scale = F),
    # dummy vars
    d_secure   = as.numeric(attachment == "secure"),
    d_avoidant = as.numeric(attachment == "avoidant"),
    # interactions vars
    secure_X_involvement   = involvement_c * d_secure,
    avoidant_X_involvement = involvement_c * d_avoidant
  )

m_interaction3 <- lm(child_satisfaction ~ involvement_c + d_secure + d_avoidant + secure_X_involvement + avoidant_X_involvement,
                     data = parental_iris_long_way3)

summary(m_interaction3)


# Categorical moderator (the short way) -----------------------------------

## 1. Prep the data

parental_iris_short_way <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = T, scale = F),
    # recode so that "secure" is base group
    attachment = factor(attachment, levels = c("secure","avoidant","anxious"))
  )

## 2. Fit the model(s)

m_additive_short <- lm(child_satisfaction ~ involvement_c + attachment,
                 data = parental_iris_short_way)

m_interaction_short <- lm(child_satisfaction ~ involvement_c * attachment,
                    data = parental_iris_short_way)

anova(m_additive_short, m_interaction_short)
summary(m_interaction_short)
summary(m_interaction) # for comparison

model.matrix(m_interaction)

## 3. Simple slopes analysis

library(emmeans)
et_involvement <- emtrends(m_interaction_short, ~ attachment, "involvement_c")
et_involvement

emmip(et_involvement, ~ attachment, CIs = TRUE) # what is on the y axis?

# sig test + CI for all simple slopes
summary(et_involvement, infer = T)

# We can also compre the simple slopes
contrast(et_involvement, "trt.vs.ctrl")
contrast(et_involvement, "pairwise")
?emmeans::`contrast-methods`
contrast(et_involvement, list(c(-1,-1,2)/2))

# the overall (average) slope
emtrends(m_interaction_short, ~ 1, "involvement_c")


# Continuous moderator (the short way) ------------------------------------


## 1. Prep the data
parental_iris_short_way <- parental_iris %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, center = T, scale = F),
    # center parental_strictness
    strictness_c = scale(parental_strictness, center = T, scale = F),
  )

## 2. Fit the model(s)
m_additive_short <- lm(child_satisfaction ~ involvement_c + strictness_c,
                       data = parental_iris_short_way)
m_interaction_short <- lm(child_satisfaction ~ involvement_c * strictness_c,
                          data = parental_iris_short_way)
anova(m_additive_short, m_interaction_short)
summary(m_interaction_short)
model.matrix(m_interaction_short)

## 3. Simple slopes analysis


# get simple slopes

emtrends(m_interaction_short, ~ strictness_c, "involvement_c")

mean_sd <- function(x) {mean(x) + c(-1,0,1) * sd(x)}
mean_sd(c(1,2,3,3,3,3))

(et_involvement <- emtrends(m_interaction_short, ~ strictness_c, "involvement_c"))


emmip(et_involvement, ~ strictness_c, CIs = TRUE) # what is on the y axis?

# Why are all the ts the same?
contrast(et_involvement, "trt.vs.ctrl") #?
contrast(et_involvement, "pairwise") #?
contrast(et_involvement, list(c(-1,-1,2)/2)) #?

# the overall (average) slope
emtrends(m_interaction_short, ~ 1, "involvement_c")

# Exercise + Plotting -------------------------------------------------

# 1. Extract the simple slopes for parental_strictness (conditioned on
#    parental_involvement).
# 2. Using the `interactions` package:
#    A. Plot an interaction plot.   (`interact_plot`)
#    B. Plot a Johnson-Neyman plot. (`johnson_neyman`)
# *. Do the Continuous moderator the LONG way.
