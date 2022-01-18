
library(effectsize) # cohens_d and cramers_v
library(correlation) # for correlation
library(BayesFactor) # all the Bayes...

pdat <- readRDS("pdat.Rds")

head(pdat)

# This exercise will demo how to conduct the "classic" statistical hypothesis
# tests, along with their accompanying:
#   - Bayesian counterparts.
#   - Confidence intervals.
#   - Standardized effect sizes.
#
# It is important to note that each of these so-called "tests" are actually a
# (simple) statistical model.


# t-test ------------------------------------------------------------------


# What is the model?


## between ----
t.test(pdat$Depression[pdat$Group == "a"],
       pdat$Depression[pdat$Group == "b"], var.equal = TRUE)
# Note, the default is `var.equal = FALSE` which gives a Welch test.
# How to know if you can or cannot assume equal variance? You can use:
?var.test

ttestBF(pdat$Depression[pdat$Group == "a"],
        pdat$Depression[pdat$Group == "b"])

cohens_d(pdat$Depression[pdat$Group == "a"],
         pdat$Depression[pdat$Group == "b"])




## within ----
# order of values is crucial! TAKE CARE WHEN USING LONG DATA!
t.test(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

ttestBF(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

cohens_d(pdat$Cond_A, pdat$Cond_B, paired = TRUE)




# You can also set the width of the prior with the `rscale` argument.
# Read more about selecting and reporting this, here:
# http://xeniaschmalz.blogspot.com/2019/09/justifying-bayesian-prior-parameters-in.html


# Correlation -------------------------------------------------------------

## single correlation
cor(pdat$Depression, pdat$Joy)

# Pearson
# What is the model?
cor.test(pdat$Depression, pdat$Joy)

correlationBF(pdat$Depression, pdat$Joy)



## Spearman correlation ----
# What is the model?
cor.test(pdat$Depression, pdat$Joy, method = "spearman")




## Many at once ----
corrs <- correlation(pdat, select = c("Depression","Anxiety","Joy"))
corrs # Look at the function docs for Bayesian correlations.
summary(corrs, redundant = TRUE) # output as a nice matrix

correlation(pdat, select = c("Depression","Anxiety","Joy"),
            method = "spearman")

correlation(pdat, select = c("Depression","Anxiety","Joy"),
            partial = TRUE) # for partial correlations


# correlation() akso supports group_by()!
library(dplyr)
pdat |>
  group_by(Group) |>
  correlation(select = c("Depression","Anxiety","Joy"))


# Proportion test ---------------------------------------------------------

# What is the model?


prop.test(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

proportionBF(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

# What's the effect size?






# Chi-squared test --------------------------------------------------------


cont_table <- table(pdat$sex, pdat$Group)
cont_table

proportions(cont_table) # % from total
proportions(cont_table, margin = 1) # % from rows
proportions(cont_table, margin = 2) # % from columns


# What is the model?
chisq.test(cont_table, correct = FALSE)

contingencyTableBF(cont_table, sampleType = "jointMulti")

cramers_v(cont_table)



## Goodness of fit ----
group_table <- table(pdat$Group)
group_table
chisq.test(group_table, p = c(0.2,0.4,0.4))

phi(group_table, p = c(0.2,0.4,0.4))


# Exercise ----------------------------------------------------------------

# 1. Conduct a t-test comparing Anxiety between the Sexes.
#   - What is Cohen's d?
#   - What is the Bayes Factor for this difference?
# 2. What is the correlation between the Cond_A and Cond_B scores?
# 3. Both frequentist and Bayesian tests (and effect sizes) support one sided
#   tests... Conduct a one sided:
#   - Frequentist correlation test (from Question 2).
#   - Bayesian t test (from Question 1).
#   How do these affect the results (compared to the two-sided test)?
#   See also:
?effectsize_CIs
# 4. Look at one of the tests conducted above. How would you visually represent
#   the results? Try to plot a relevant plot with ggplot2.
