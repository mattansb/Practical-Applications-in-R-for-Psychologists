
library(JSmediation)

# `JSmediation` gives a simple solution for simple mediation models.


parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)



# Fit a simple mediation model
med_model <- mdt_simple(data = parental_iris,
                        IV = ave_sweets,
                        DV = child_satisfaction,
                        M  = parental_strictness)
med_model


# Look at the *indirect effect*
add_index(med_model)
# Note that this uses bootstrapping for the CI.



# What would we make of an indirect effect w/o a total effect?
# http://www.the100.ci/2019/10/03/indirect-effect-ex-machina/



# see all the path models:
display_models(med_model)



# Things become more complex with more complex models:
# 1. For *moderated mediation* you can use `JSmediation::mdt_moderated()`.
# 2. If you want to control for other variables in your mediations (other
#    covariates), you can use `mediate()` from the `mediation` package.
# 3. For even more complex mediation patterns, you will need to use SEM
#    (`lavaan`, next semester...).




# CIs and Betas -----------------------------------------------------------


# What about CIs or Betas?



## Option 1. Extract models one by one:
model_1 <- extract_model(med_model, step = 1)
summary(model_1) # now do what ever you would do as usual!
parameters::model_parameters(model_1, standardize = "basic")



## Option 2. Extract all models at once!
models <- extract_models(med_model)

library(purrr) # let's you apply functions on elements of lists!
map(models, parameters::model_parameters, standardize = "basic")



# What about the standerdized indirect beta?
# Not easy... But you can multiply the standerdized a and b:
-0.87 * 1.36
# No solution here for the CI.





# Exercise ----------------------------------------------------------------

# 1. Fit the reverse moderation models: ave_sweets mediates the effect of
#    parental_strictness on child_satisfaction.
# 2. Is the direct effect significant?
# 3. Is the indirect effect significant?
# 4. How would you interpret these results?
