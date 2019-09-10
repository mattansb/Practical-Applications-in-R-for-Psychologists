library(psych) # for corr.test
library(apa) # for cohens_d
library(ppcor) # for pcor and spcor
library(BayesFactor) # all the Bayes...

# library(tidyverse)
# pdat <- tibble(
#   ID = seq_len(46),
#   sex = sample(c("F","M"), size = 46, replace = T),
#   Cond_A = rnorm(46),
#   Cond_B = Cond_A + rnorm(46, 3),
#   Group = rep(letters[1:2], each = 23),
#   Depression = c(rnorm(23),rnorm(23)),
#   Anxiety = Depression + rnorm(46,,2),
#   Joy = rnorm(46,,2)
# )
#
# pdat$Anxiety[14] <- NA
#
# saveRDS(pdat,"pdat.Rds")

pdat <- readRDS("pdat.Rds")


# ttest -------------------------------------------------------------------

## between
res <- t.test(pdat$Depression[pdat$Group == "a"],
              pdat$Depression[pdat$Group == "b"], var.equal = TRUE)
res
cohens_d(res)

ttestBF(pdat$Depression[pdat$Group == "a"],
        pdat$Depression[pdat$Group == "b"])

## within
# order of values is crutial! TAKE CARE WHEN USING LONG DATA!
res <- t.test(pdat$Cond_A, pdat$Cond_B, paired = TRUE)
res
cohens_d(res)

ttestBF(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

# corr test ---------------------------------------------------------------

## simple correlation

cor.test(pdat$Depression, pdat$Joy)
correlationBF(pdat$Depression, pdat$Joy)

cor.test(pdat$Depression, pdat$Joy, method = "spearman")

# many at once
res <- corr.test(pdat[,c("Depression","Anxiety","Joy")])
res
res$ci

corr.test(pdat[,c("Depression","Anxiety","Joy")], method = "spearman", use = "complete")


## partial
pcor(pdat[,c("Depression","Anxiety","Joy")])

## part / semi_partial
spcor(pdat[,c("Depression","Anxiety","Joy")])

# ci? :(

# the `psych` package has a lot more correlation-related thing...
# you might also find the `corrr` package interesting for quick (tidy)
# exploration and visualization of correlations.

# proportion test ---------------------------------------------------------

prop.test(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

proportionBF(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)

# chi test ----------------------------------------------------------------

cramers_v <- function(chisq.test.res){
  chisq <- unname(chisq.test.res$statistic)
  n <- sum(chisq.test.res$observed)
  k <- min(dim(chisq.test.res$observed))

  c("cramers_v" = sqrt(chisq / (n * (k - 1))))
}

res <- chisq.test(pdat$sex, pdat$Group, correct = FALSE)
res

cramers_v(res)


contingencyTableBF(table(pdat$sex, pdat$Group), sampleType = "jointMulti")


# Exercise ----------------------------------------------------------------


# 1. Both frequentist and bayesian tests support one sided test...
#    conduct a one sided:
#    - t test
#    - correlation test
#    - proportion test
#    How do these affect the results?
# 2. Load one of the files from prevoius lessons - conduct 2 tests of
#    your choosing.
