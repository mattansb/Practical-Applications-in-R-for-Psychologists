data("sai", package = "psychTools") # in the new version of `psych` data has been moved to `psychTools`

library(dplyr)
library(effectsize)
library(performance)
library(ggplot2)

sai_AGES <- sai %>%
  filter(study == "AGES") %>%
  select(-study)

# Exercise ----------------------------------------------------------------

# 1. Predict `joyful` from two predictors of your choice.
fit_joy <- lm(joyful ~ nervous + regretful,
              data = sai_AGES)

#    a. Which of the two has the bigger contribution to predicting joyfulness?
standardize_parameters(fit_joy, method = "basic")
# regretful has a beta of -0.08,
# which is larger than the beta of nervous (-0.06).

#    b. What is the 80% CI for the second predictor?
confint(fit_joy, parm = "regretful", level = 0.8)

#    c. What is the R^2 of the model?
r2(fit_joy) # 1.3%

# 2. Plot (with ggplot) the tri-variate relationship.
ggplot(sai_AGES, aes(nervous,regretful, color = joyful, size = joyful)) +
  # add jitter so points don't overlap (also `geom_jitter()`)
  geom_point(position = position_jitter(0.3, 0.3))

# or
ggplot(sai_AGES, aes(regretful, joyful)) +
  geom_point(position = position_jitter(0.3, 0.3)) +
  geom_smooth(method = "lm") +
  facet_grid( ~ cut(nervous, 3)) # cut into ranges

# 3. Add the predicted values to the data.frame. Plot them (with ggplot2,
#    duh) the relation to the true values. Use `geom_smooth`.
sai_AGES %>%
  mutate(predicted_joy = predict(fit_joy)) %>%
  ggplot(aes(predicted_joy, joyful)) +
  geom_point() +
  geom_smooth(method = "lm")

# *. What does `update` do?
# update() takes a model and updates its structure. For example,
# if I want to add `upset` as a predictor:
fit_joy2 <- update(fit_joy, formula. = . ~ . + upset)
# If I want to remove `regretful`:
fit_joy3 <- update(fit_joy2, formula. = . ~ . - regretful)

summary(fit_joy2)
summary(fit_joy3)

# this is useful whith complex models - and when we want to compare
# nested models (more on this next week!)
