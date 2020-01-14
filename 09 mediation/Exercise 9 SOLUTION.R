library(JSmediation)

parental_iris <- read.csv("parental_iris.csv")

# 1. Fit the reverse moderation models:
#    ave_sweets mediates the effect of parental_strictness on child_satisfaction.

med_model_rev <- mdt_simple(data = parental_iris,
                            IV = parental_strictness,
                            DV = child_satisfaction,
                            M  = ave_sweets)

# 2. Is the direct effect significant?
med_model_rev # yes

# 3. Is the indirect effect significant?
add_index(med_model_rev) # yes

# 4. How would you interpret these results?
# The direct effect of parental_strictness on child_satisfaction
# is suppressed by the inderect effect:
# While the direct effect is positive, the indirect effect is negative,
# making the over all total effect positive, but smaller.
