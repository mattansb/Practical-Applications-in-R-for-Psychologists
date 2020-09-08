
<img src='logo/BGUHex.png' align="right" height="139" />

# Advanced Research Methods foR Psychologists

[![](https://img.shields.io/badge/Open%20Educational%20Resources-Compatable-brightgreen)](https://creativecommons.org/about/program-areas/education-oer/)
[![](https://img.shields.io/badge/CC-BY--NC--SA%204.0-lightgray)](http://creativecommons.org/licenses/by-nc-sa/4.0/)  
[![](https://img.shields.io/badge/Language-R-blue)](http://cran.r-project.org/)

<sub>*Last updated 2020-09-08.*</sub>

This Github repo contains all lesson files for the *Practical
Applications in R* portion of the graduate-level course: ***Advanced
Research Methods for Psychologists***, taught at Ben-Gurion University
on the Negev (*Fall semester, 2020*).

The goal is to impart students with the basic tools to process data,
describe data (w/ summary statistics and plots), and the foundations of
**building, evaluating and comparing statistical models in `R`**,
focusing on linear regression modeling (using both frequentist and
Bayesian approaches).

This course will lay the foundation for the topic-focused courses
(*Spring semester*):

  - [Structural equation modelling
    (*SEM*)](https://github.com/mattansb/Structural-Equation-Modeling-foR-Psychologists)
  - Machine Learning (*ML*).
  - Hierarchical linear models (*HLM*).

**Notes:**

  - This repo contains only materials relating to *Practical
    Applications in R*. Though statistics are naturally discussed in
    many lessons, the focus is generally on the application and not on
    the theory.  
  - Please note that some code does not work *on purpose* and without
    warning, to force students to learn to debug.

## Setup

You will need:

1.  A fresh installation of [**`R`**](https://cran.r-project.org/)
    (preferably version 4.0 or above).
2.  [RStudio IDE](https://www.rstudio.com/products/rstudio/download/)
    (optional, but recommended).
3.  The following packages, listed by lesson:

| Lesson                                                                                                      | Packages                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [01 intro](/01%20intro)                                                                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| [02 data wrangling](/02%20data%20wrangling)                                                                 | [`tidyverse`](https://CRAN.R-project.org/package=tidyverse), [`haven`](https://CRAN.R-project.org/package=haven), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`summarytools`](https://CRAN.R-project.org/package=summarytools), [`psych`](https://CRAN.R-project.org/package=psych), [`DescTools`](https://CRAN.R-project.org/package=DescTools), [`finalfit`](https://CRAN.R-project.org/package=finalfit), [`Hmisc`](https://CRAN.R-project.org/package=Hmisc), [`mice`](https://CRAN.R-project.org/package=mice) |
| [03 plotting](/03%20plotting)                                                                               | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| [04 hypothesis testing and power](/04%20hypothesis%20testing%20and%20power)                                 | [`psych`](https://CRAN.R-project.org/package=psych), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`ppcor`](https://CRAN.R-project.org/package=ppcor), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [`pwr`](https://CRAN.R-project.org/package=pwr)                                                                                                                                                                                                                                                                                                    |
| [05 regression 101](/05%20regression%20101)                                                                 | [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`psychTools`](https://CRAN.R-project.org/package=psychTools)                                                                                                                                                                                                                                                                    |
| [06 categorical predictors and model comparison](/06%20categorical%20predictors%20and%20model%20comparison) | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [`bayestestR`](https://CRAN.R-project.org/package=bayestestR), [`performance`](https://CRAN.R-project.org/package=performance)                                                                                                                                                    |
| [07 moderation and curvilinear](/07%20moderation%20and%20curvilinear)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`performance`](https://CRAN.R-project.org/package=performance), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`interactions`](https://CRAN.R-project.org/package=interactions), [`parameters`](https://CRAN.R-project.org/package=parameters), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                        |
| [08 ANOVA](/08%20ANOVA)                                                                                     | [`afex`](https://CRAN.R-project.org/package=afex), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`tidyr`](https://CRAN.R-project.org/package=tidyr)                                                                                                                                                                                                                                                                                                                                                                                                                              |
| [09 generalized linear models](/09%20generalized%20linear%20models)                                         | [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`emmeans`](https://CRAN.R-project.org/package=emmeans)                                                                                                                                                                                                                                                                                                                                         |
| [10 assumption checks and violations](/10%20assumption%20checks%20and%20violations)                         | [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`performance`](https://CRAN.R-project.org/package=performance), [`ggResidpanel`](https://CRAN.R-project.org/package=ggResidpanel), [`parameters`](https://CRAN.R-project.org/package=parameters), [`permuco`](https://CRAN.R-project.org/package=permuco), [`insight`](https://CRAN.R-project.org/package=insight)                                                                                                                                                                                                             |
| [11 mediation](/11%20mediation)                                                                             | [`mediation`](https://CRAN.R-project.org/package=mediation)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "afex", "BayesFactor", "bayestestR", "DescTools", "dplyr",
      "effectsize", "emmeans", "finalfit", "ggeffects", "ggplot2",
      "ggResidpanel", "haven", "Hmisc", "insight", "interactions",
      "mediation", "mice", "parameters", "performance", "permuco",
      "ppcor", "psych", "psychTools", "pwr", "summarytools", "tidyr", "tidyverse"
    )

    install.packages(pkgs, dependencies = TRUE)

The package versions used here:

    ##         afex  BayesFactor   bayestestR    DescTools        dplyr   effectsize 
    ##     "0.27-2" "0.9.12-4.2"      "0.7.2"    "0.99.37"      "1.0.1"      "0.3.2" 
    ##      emmeans     finalfit    ggeffects      ggplot2 ggResidpanel        haven 
    ##      "1.4.8"      "1.0.2"     "0.15.1"      "3.3.2"      "0.3.0"      "2.3.1" 
    ##        Hmisc      insight interactions    mediation         mice   parameters 
    ##      "4.4-1"      "0.9.5"      "1.1.3"      "4.5.0"     "3.11.0"      "0.8.3" 
    ##  performance      permuco        ppcor        psych   psychTools          pwr 
    ##    "0.4.8.1"      "1.1.0"        "1.1"      "2.0.7"      "2.0.8"      "1.3-0" 
    ## summarytools        tidyr    tidyverse 
    ##      "0.9.6"      "1.1.1"      "1.3.0"
