library(BayesFactor) # all the Bayes...

pdat <- readRDS("pdat.Rds")


# Conduct a one sided:
#  - t test
#  - correlation test
# How do these affect the results?


# 1. t-test ---------------------------------------------------------------

t.test(pdat$Depression[pdat$Group == "a"],
       pdat$Depression[pdat$Group == "b"], var.equal = TRUE,
       # alternative hypothesis is that the difference is negative
       alternative = "less")

ttestBF(pdat$Depression[pdat$Group == "a"],
        pdat$Depression[pdat$Group == "b"],
        # Eventhough the nave of the arg has "null" in it,
        # it is used to define the alternative hypothesis:
        # here, that the difference is negative (-Inf < d < 0).
        nullInterval = c(-Inf, 0))

#' For Bayes factors, we get two alternatives - that one we asked for,
#' and its complimentary.
#' The BF we specifiyed has increased, and the p-value has decreased,
#' but our conclusion remaind the same - not very informative results.

# 2. simple correlation ---------------------------------------------------

cor.test(pdat$Depression, pdat$Joy,
         # alternative hypothesis is that the difference is negative
         alternative = "less")

correlationBF(pdat$Depression, pdat$Joy,
              # Eventhough the nave of the arg has "null" in it,
              # it is used to define the alternative hypothesis:
              # here, that the correlation is negative (-1 < r < 0).
              nullInterval = c(-1, 0))

#' For Bayes factors, we get two alternatives - that one we asked for,
#' and its complimentary.
#' The BF we specifiyed has decreased, and the p-value has also decreased.
#' Overall, our conclusion remaind the same - not very informative results.
