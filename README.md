
<img src='logo/BGUHex.png' align="right" height="139" />

# Advanced Research Methods foR Psychologists

<sub>*Last updated 2020-01-09.*</sub>

This Github repo contains all lesson files used in the graduate-level
course: *Advanced Research Methods foR Psychologists - Practical
Applications in R*, taught at Ben-Gurion University on the Negev (fall
2019 semester).

The goal is to impart students with the basic tools to process data,
describe data (w/ summary statistics and plots), and finally build,
evaluate and compare statistical models (using both the frequentist and
Bayesian approach), focusing mostly on linear regression modeling. This
course will lay the foundation for the topic-focused courses:

  - Structural equation modelling (*SEM*)
  - Analysis of factorial designs (*ANOVA*).
  - Machine Learning (*ML*).
  - Hierarchical linear models (*HLM*).

**Notes:**

  - This repo contains only materials relating to *Practical
    Applications in R*, and does not contain any theoretical or
    introductory materials.  
  - Please note that some code does not work *on purpose*, to force
    students to learn to debug.

## Setup

You will need:

1.  A fresh installation of [**`R`**](https://cran.r-project.org/)
    (preferably version 3.6 or above).

2.  [RStudio](https://www.rstudio.com/products/rstudio/download/)
    (optional - but I recommend using an IDE).

3.  The following packages, listed by lesson:
    
      - *[02 data.frames](/02%20data.frames)*: `tidyverse`, `haven`
      - *[03 outliers & missing
        data](/03%20outliers%20&%20missing%20data)*: `finalfit`,
        `Hmisc`, `mice`, `dplyr`
      - *[04 describing data](/04%20describing%20data)*: `dplyr`,
        `parameters`, `summarytools`, `ggplot2`, `psych`
      - *[05 testing](/05%20testing)*: `psych`, `effectsize`, `ppcor`,
        `BayesFactor`
      - *[06 regression](/06%20regression)*: `dplyr`, `effectsize`,
        `parameters`, `performance`, `psychTools`
      - *[07 dummy and hierarchical](/07%20dummy%20and%20hierarchical)*:
        `dplyr`, `emmeans`, `car`, `performance`, `MASS`
      - *[08 moderation and
        curvilinear](/08%20moderation%20and%20curvilinear)*:
        `performance`, `parameters`, `ggplot2`, `dplyr`, `interactions`,
        `emmeans`
      - *[09 mediation](/09%20mediation)*: `JSmediation`, `mediation`
      - *[10 Bayesian model
        selection](/10%20Bayesian%20model%20selection)*: `BayesFactor`,
        `bayestestR`
      - *[11 assumptions and non-parameteric
        inference](/11%20assumptions%20and%20non-parameteric%20inference)*:
        `dplyr`, `performance`, `ggplot2`, `GGally`, `ggResidpanel`,
        `afex`, `permuco`, `parameters`
      - *[12 generalized linear
        models](/12%20generalized%20linear%20models)*: `parameters`,
        `performance`, `ggplot2`

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "afex", "BayesFactor", "bayestestR", "car", "dplyr", "effectsize",
      "emmeans", "finalfit", "GGally", "ggplot2", "ggResidpanel", "haven",
      "Hmisc", "interactions", "JSmediation", "MASS", "mediation",
      "mice", "parameters", "performance", "permuco", "ppcor", "psych",
      "psychTools", "summarytools", "tidyverse"
    )

``` r
install.packages(pkgs, dependencies = TRUE)
```

The package versions used here:

    ##         afex  BayesFactor   bayestestR          car        dplyr   effectsize 
    ##     "0.25-1" "0.9.12-4.2"      "0.4.9"      "3.0-6"      "0.8.3"      "0.0.1" 
    ##      emmeans     finalfit       GGally      ggplot2 ggResidpanel        haven 
    ##   "1.4.3.01"      "0.9.7"      "1.4.0"      "3.2.1"      "0.3.0"      "2.2.0" 
    ##        Hmisc interactions  JSmediation    mediation         mice   parameters 
    ##      "4.3-0"      "1.1.1"      "0.1.0"      "4.5.0"      "3.7.0"      "0.3.0" 
    ##  performance      permuco        ppcor        psych   psychTools summarytools 
    ##      "0.4.2"      "1.1.0"        "1.1"     "1.9.12"   "1.9.5.26"      "0.9.4" 
    ##    tidyverse         MASS 
    ##      "1.3.0"   "7.3-51.4"

## To Do

  - [ ] Power analysis with `pwr` (?)
