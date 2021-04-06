
library(psych) # for corr.test
library(effectsize) # cohens_d and cramers_v
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


## between
t.test(pdat$Depression[pdat$Group == "a"],
       pdat$Depression[pdat$Group == "b"], var.equal = TRUE)
# Note, the default is `var.equal = FALSE` which gives a Welch test.
# How to know if you can or cannot assume equal variance? You can use:
?var.test

ttestBF(pdat$Depression[pdat$Group == "a"],
        pdat$Depression[pdat$Group == "b"])

cohens_d(pdat$Depression[pdat$Group == "a"],
         pdat$Depression[pdat$Group == "b"])




## within
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



# Spearman correlation
# What is the model?
cor.test(pdat$Depression, pdat$Joy, method = "spearman")




## many at once (`corr.test` is NOT `cor.test`!)
res <- corr.test(pdat[,c("Depression","Anxiety","Joy")])
print(res, short = FALSE)


res <- corr.test(pdat[,c("Depression","Anxiety","Joy")],
                 method = "spearman", use = "complete")
# `use = "complete"` to only use full cases for all correlations!
print(res, short = FALSE)



# The `psych` package has a lot more correlation-related things... We will meet
# some of them next semester.
# The `ppcor` also offers partial and semi-partial (part) correlations. You
# might also find the `correlation` package interesting for quick (and tidy)
# exploration and visualization of correlations.



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


# Chi-sqaured for goodness of fit
group_table <- table(pdat$Group)
chisq.test(group_table, p = c(0.2,0.4,0.4))


# Exercise ----------------------------------------------------------------

# 1. Conduct a t-test comparing Anxiety between the Sexes.
#   - What is Cohen's d?
#   - What is the Bayes Factor for this difference?
# 2. What is the correlation between the Cond_A and Cond_B scores?
# 3. Both frequentist and Bayesian tests support one sided tests... Conduct a
#   one sided:
#   - Frequentist correlation test (from Question 2).
#   - Bayesian t test (from Question 1).
#   How do these affect the results (compared to the two-sided test)?


