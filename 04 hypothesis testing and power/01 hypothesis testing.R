library(psych) # for corr.test
library(effectsize) # cohens_d and cramers_v
library(ppcor) # for pcor and spcor
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


# correlation -------------------------------------------------------------

## single correlation

# Pearson
# What is the model?
cor.test(pdat$Depression, pdat$Joy)

correlationBF(pdat$Depression, pdat$Joy)



# Spearman correlation
# What is the model?
cor.test(pdat$Depression, pdat$Joy, method = "spearman")




## many at once (`corr.test` is NOT `cor.test`!)
(res <- corr.test(pdat[,c("Depression","Anxiety","Joy")]))
res$ci


corr.test(pdat[,c("Depression","Anxiety","Joy")],
          method = "spearman", use = "complete")
# `use = "complete"` to only use full cases for all correlations!





# The `psych` package has a lot more correlation-related things... We will meet
# some of them next semester.
# You might also find the `correlation` package interesting for quick (and tidy)
# exploration and visualization of correlations.





# partial and part (semi-partial) correlations ----------------------------

# What is the model?

## partial correlation
pcor(pdat[, c("Depression", "Anxiety", "Joy")])

## part / semi-partial correlation
spcor(pdat[, c("Depression", "Anxiety", "Joy")])

# ci? :(







# proportion test ---------------------------------------------------------

# What is the model?


prop.test(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

proportionBF(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

# Whats the effect size?






# chi-squared test --------------------------------------------------------

# What is the model?

(cont_table <- table(pdat$sex, pdat$Group))

chisq.test(cont_table, correct = FALSE)

contingencyTableBF(cont_table, sampleType = "jointMulti")

cramers_v(cont_table)





# Exercise ----------------------------------------------------------------


# Both frequentist and Bayesian tests support one sided tests...
# Conduct a one sided:
#  - t test
#  - correlation test
# How do these affect the results (compared to the two-sided test)?


