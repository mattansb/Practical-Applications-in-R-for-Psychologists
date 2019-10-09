
library(JSmediation)

parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)

med_model <- mdt_simple(data = parental_iris,
                        IV = ave_sweets,
                        DV = child_satisfaction,
                        M  = parental_strictness)
med_model
add_index(med_model)

# What would we make of an indirect effect w/o a total effect?
# http://www.the100.ci/2019/10/03/indirect-effect-ex-machina/

# see the models
display_models(med_model)

model_1 <- extract_model(med_model, step = 1)
summary(model_1) # now do what ever you would do as usual!

# Things become more complex with more complex models:
# 1. For moderated mediation you can use `JSmediation::mdt_moderated()`.
# 2. If you want to control for other variables in your mediations (other
#    covariates), you can use `mediation::mediate()`
# 3. For more complex mediation patterns, you will need to use SEM
#    (`lavaan`, next semester...)

# Exercise ----------------------------------------------------------------

# 1. Try fitting the flpped moderation models: ave_sweets mediates the
#    effect of parental_strictness.
# 2. Is the direct effect significant?
# 3. Is the indirect effect significant?
# 4. How would you interpret these results?
