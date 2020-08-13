
<img src='logo/BGUHex.png' align="right" height="139" />

# Advanced Research Methods foR Psychologists

[![](https://img.shields.io/badge/Open%20Educational%20Resources-Compatable-brightgreen)](https://creativecommons.org/about/program-areas/education-oer/)
[![](https://img.shields.io/badge/CC-BY--NC--SA%204.0-lightgray)](http://creativecommons.org/licenses/by-nc-sa/4.0/)  
[![](https://img.shields.io/badge/Language-R-blue)](http://cran.r-project.org/)

<sub>*Last updated 2020-08-13.*</sub>

This Github repo contains all lesson files used in the graduate-level
course: *Advanced Research Methods foR Psychologists - Practical
Applications in R*, taught at Ben-Gurion University on the Negev (fall
2020 semester).

The goal is to impart students with the basic tools to process data,
describe data (w/ summary statistics and plots), and the foundations of
building, evaluating and comparing statistical models in `R` focusing on
linear regression modeling (using both frequentist and Bayesian
approaches).

This course will lay the foundation for the topic-focused courses:

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
| [02 data wrangling](/02%20data%20wrangling)                                                                 | [`tidyverse`](https://CRAN.R-project.org/package=tidyverse), [`haven`](https://CRAN.R-project.org/package=haven), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`summarytools`](https://CRAN.R-project.org/package=summarytools), [`psych`](https://CRAN.R-project.org/package=psych), [`DescTools`](https://CRAN.R-project.org/package=DescTools), [`finalfit`](https://CRAN.R-project.org/package=finalfit), [`Hmisc`](https://CRAN.R-project.org/package=Hmisc), [`mice`](https://CRAN.R-project.org/package=mice) |
| [03 plotting](/03%20plotting)                                                                               | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| [04 hypothesis testing](/04%20hypothesis%20testing)                                                         | [`psych`](https://CRAN.R-project.org/package=psych), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`ppcor`](https://CRAN.R-project.org/package=ppcor), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor)                                                                                                                                                                                                                                                                                                                                                     |
| [05 regression 101](/05%20regression%20101)                                                                 | [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`psychTools`](https://CRAN.R-project.org/package=psychTools)                                                                                                                                                                                                                                                                    |
| [06 categorical predictors and model comparison](/06%20categorical%20predictors%20and%20model%20comparison) | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [`bayestestR`](https://CRAN.R-project.org/package=bayestestR), [`performance`](https://CRAN.R-project.org/package=performance)                                                                                                                                                    |
| [07 moderation and curvilinear](/07%20moderation%20and%20curvilinear)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`performance`](https://CRAN.R-project.org/package=performance), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`interactions`](https://CRAN.R-project.org/package=interactions), [`parameters`](https://CRAN.R-project.org/package=parameters), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                        |
| [09 assumptions and non-parametric inference](/09%20assumptions%20and%20non-parametric%20inference)         | [`performance`](https://CRAN.R-project.org/package=performance), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`GGally`](https://CRAN.R-project.org/package=GGally), [`ggResidpanel`](https://CRAN.R-project.org/package=ggResidpanel), [`permuco`](https://CRAN.R-project.org/package=permuco), [`parameters`](https://CRAN.R-project.org/package=parameters)                                                                                                                                                                                                                       |
| [10 generalized linear models](/10%20generalized%20linear%20models)                                         | [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2), [`emmeans`](https://CRAN.R-project.org/package=emmeans)                                                                                                                                                                                                                                                                                                                                             |
| [mediation](/mediation)                                                                                     | [`JSmediation`](https://CRAN.R-project.org/package=JSmediation), [`purrr`](https://CRAN.R-project.org/package=purrr), [`parameters`](https://CRAN.R-project.org/package=parameters)                                                                                                                                                                                                                                                                                                                                                                                                          |
| [power](/power)                                                                                             | [`pwr`](https://CRAN.R-project.org/package=pwr), [`effectsize`](https://CRAN.R-project.org/package=effectsize)                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "BayesFactor", "bayestestR", "DescTools", "dplyr", "effectsize",
      "emmeans", "finalfit", "GGally", "ggeffects", "ggplot2", "ggResidpanel",
      "haven", "Hmisc", "interactions", "JSmediation", "mice", "parameters",
      "performance", "permuco", "ppcor", "psych", "psychTools", "purrr",
      "pwr", "summarytools", "tidyverse"
    )

    install.packages(pkgs, dependencies = TRUE)

The package versions used here:

    ##  BayesFactor   bayestestR    DescTools        dplyr   effectsize      emmeans 
    ## "0.9.12-4.2"    "0.7.2.1"    "0.99.37"      "1.0.1"      "0.3.2"      "1.4.8" 
    ##     finalfit       GGally    ggeffects      ggplot2 ggResidpanel        haven 
    ##      "1.0.2"      "2.0.0"     "0.15.1"      "3.3.2"      "0.3.0"      "2.3.1" 
    ##        Hmisc interactions  JSmediation         mice   parameters  performance 
    ##      "4.4-1"      "1.1.3"      "0.1.1"     "3.11.0"      "0.8.2"      "0.4.8" 
    ##      permuco        ppcor        psych   psychTools        purrr          pwr 
    ##      "1.1.0"        "1.1"      "2.0.7"      "2.0.8"      "0.3.4"      "1.3-0" 
    ## summarytools    tidyverse 
    ##      "0.9.6"      "1.3.0"
