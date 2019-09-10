
library(JSmediation)

parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)

med_model <- mdt_simple(data = parental_iris,
                        IV = ave_sweets,
                        DV = child_satisfaction,
                        M  = parental_strictness)
med_model
add_index(med_model)

# see the models
display_models(med_model)

model_1 <- extract_model(med_model, step = 1)
summary(model_1) # now do what ever you would do as usual!

# for more complex models, you will need to use SEM...

# Exercise ----------------------------------------------------------------

# 1. Try fitting the flpped moderation models: ave_sweets mediates the
#    effect of parental_strictness.
# 2. Is the direct effect significant?
# 3. Is the indirect effect significant?
# 4. How would you interpret these results?
