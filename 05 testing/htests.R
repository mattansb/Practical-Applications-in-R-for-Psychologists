library(psych) # for corr.test
library(effectsize) # cohens_d and cramers_v
library(ppcor) # for pcor and spcor
library(BayesFactor) # all the Bayes...

pdat <- readRDS("pdat.Rds")

# This exercise will demo how to conduct the "classic" statistical tests,
# along with their accompanying:
#   - Confidence interval.
#   - Standerdized effect size.


# t-test ------------------------------------------------------------------

## between
t.test(pdat$Depression[pdat$Group == "a"],
       pdat$Depression[pdat$Group == "b"], var.equal = TRUE)

cohens_d(pdat$Depression[pdat$Group == "a"],
         pdat$Depression[pdat$Group == "b"])


ttestBF(pdat$Depression[pdat$Group == "a"],
        pdat$Depression[pdat$Group == "b"])

## within
# order of values is crutial! TAKE CARE WHEN USING LONG DATA!
t.test(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

cohens_d(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

ttestBF(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

# You can also set the width of the prior with the `rscale` argument.
# Read more about selecting and reporting this, here:
# http://xeniaschmalz.blogspot.com/2019/09/justifying-bayesian-prior-parameters-in.html


# correlation -------------------------------------------------------------

## simple correlation

res <- cor.test(pdat$Depression, pdat$Joy)
res

correlationBF(pdat$Depression, pdat$Joy)

# You can also set the width of the prior with the `rscale` argument.
# Read more about selecting and reporting this, here:
# http://xeniaschmalz.blogspot.com/2019/09/justifying-bayesian-prior-parameters-in.html

cor.test(pdat$Depression, pdat$Joy, method = "spearman")

# many at once (`corr.test` is NOT `cor.test`!)
res <- corr.test(pdat[,c("Depression","Anxiety","Joy")])
res
res$ci

corr.test(pdat[,c("Depression","Anxiety","Joy")],
          method = "spearman", use = "complete")


# partial and part (semi-partial) correlations ----------------------------

## partial correlation
pcor(pdat[,c("Depression","Anxiety","Joy")])

## part / semi-partial correlation
spcor(pdat[,c("Depression","Anxiety","Joy")])

# ci? :(

# the `psych` package has a lot more correlation-related thing...
# you might also find the `corrr` package interesting for quick (tidy)
# exploration and visualization of correlations.

# proportion test ---------------------------------------------------------

prop.test(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

proportionBF(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)


# chi-squared test --------------------------------------------------------

res <- chisq.test(pdat$sex, pdat$Group, correct = FALSE)
res

chisq_to_cramers_v(chisq = res$statistic,
                   n = sum(res$observed),
                   nrow = nrow(res$observed),
                   ncol = ncol(res$observed))


contingencyTableBF(table(pdat$sex, pdat$Group), sampleType = "jointMulti")


# Exercise ----------------------------------------------------------------


# Both frequentist and bayesian tests support one sided tests...
# Conduct a one sided:
#  - t test
#  - correlation test
# How do these affect the results?
