
<img src='logo/BGUHex.png' align="right" height="139" />

# Advanced Research Methods foR Psychologists

[![](https://img.shields.io/badge/Open%20Educational%20Resources-Compatable-brightgreen)](https://creativecommons.org/about/program-areas/education-oer/)
[![](https://img.shields.io/badge/CC-BY--NC--SA%204.0-lightgray)](http://creativecommons.org/licenses/by-nc-sa/4.0/)  
[![](https://img.shields.io/badge/Language-R-blue)](http://cran.r-project.org/)

<sub>*Last updated 2020-07-30.*</sub>

This Github repo contains all lesson files used in the graduate-level
course: *Advanced Research Methods foR Psychologists - Practical
Applications in R*, taught at Ben-Gurion University on the Negev (fall
2019 semester).

The goal is to impart students with the basic tools to process data,
describe data (w/ summary statistics and plots), and the foundations of
building, evaluating and comparing statistical models in `R` focusing on
linear regression modeling (using both frequentist and Bayesian
approaches).

This course will lay the foundation for the topic-focused courses:

  - [Structural equation modelling
    (*SEM*)](https://github.com/mattansb/Structural-Equation-Modeling-foR-Psychologists)
  - [Analysis of factorial designs
    (*ANOVA*)](https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists).
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
2.  [RStudio IDE](https://www.rstudio.com/products/rstudio/download/)
    (optional, but recommended).
3.  The following packages, listed by lesson:

| Lesson                                                                                              | Packages                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [02 data.frames](/02%20data.frames)                                                                 | [`tidyverse`](https://CRAN.R-project.org/package=tidyverse), [`haven`](https://CRAN.R-project.org/package=haven)                                                                                                                                                                                                                                                         |
| [03 describe and summarise](/03%20describe%20and%20summarise)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`summarytools`](https://CRAN.R-project.org/package=summarytools), [`psych`](https://CRAN.R-project.org/package=psych)                                                                                                                               |
| [04 plotting](/04%20plotting)                                                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                             |
| [05 testing & power](/05%20testing%20&%20power)                                                     | [`psych`](https://CRAN.R-project.org/package=psych), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`ppcor`](https://CRAN.R-project.org/package=ppcor), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [`pwr`](https://CRAN.R-project.org/package=pwr)                                                                                |
| [06 outliers & missing data](/06%20outliers%20&%20missing%20data)                                   | [`finalfit`](https://CRAN.R-project.org/package=finalfit), [`Hmisc`](https://CRAN.R-project.org/package=Hmisc), [`mice`](https://CRAN.R-project.org/package=mice), [`dplyr`](https://CRAN.R-project.org/package=dplyr)                                                                                                                                                   |
| [07 regression](/07%20regression)                                                                   | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`psychTools`](https://CRAN.R-project.org/package=psychTools)                                                        |
| [08 dummy and hierarchical](/08%20dummy%20and%20hierarchical)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`performance`](https://CRAN.R-project.org/package=performance)                                                                                                                                                                                            |
| [09 moderation and curvilinear](/09%20moderation%20and%20curvilinear)                               | [`performance`](https://CRAN.R-project.org/package=performance), [`parameters`](https://CRAN.R-project.org/package=parameters), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`interactions`](https://CRAN.R-project.org/package=interactions), [`emmeans`](https://CRAN.R-project.org/package=emmeans) |
| [10 mediation](/10%20mediation)                                                                     | [`JSmediation`](https://CRAN.R-project.org/package=JSmediation), [`purrr`](https://CRAN.R-project.org/package=purrr), [`parameters`](https://CRAN.R-project.org/package=parameters)                                                                                                                                                                                      |
| [11 Bayesian model selection](/11%20Bayesian%20model%20selection)                                   | [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [`bayestestR`](https://CRAN.R-project.org/package=bayestestR)                                                                                                                                                                                                                                           |
| [12 assumptions and non-parametric inference](/12%20assumptions%20and%20non-parametric%20inference) | [`performance`](https://CRAN.R-project.org/package=performance), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`GGally`](https://CRAN.R-project.org/package=GGally), [`ggResidpanel`](https://CRAN.R-project.org/package=ggResidpanel), [`permuco`](https://CRAN.R-project.org/package=permuco), [`parameters`](https://CRAN.R-project.org/package=parameters)   |
| [13 generalized linear models](/13%20generalized%20linear%20models)                                 | [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2), [`emmeans`](https://CRAN.R-project.org/package=emmeans)                                                                                                                         |

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "BayesFactor", "bayestestR", "dplyr", "effectsize", "emmeans",
      "finalfit", "GGally", "ggplot2", "ggResidpanel", "haven", "Hmisc",
      "interactions", "JSmediation", "mice", "parameters", "performance",
      "permuco", "ppcor", "psych", "psychTools", "purrr", "pwr", "summarytools",
      "tidyverse"
    )

    install.packages(pkgs, dependencies = TRUE)

The package versions used here:

    ##  BayesFactor   bayestestR        dplyr   effectsize      emmeans       GGally 
    ## "0.9.12-4.2"      "0.7.2"      "1.0.0"      "0.3.2"      "1.4.8"      "2.0.0" 
    ##      ggplot2 ggResidpanel        haven        Hmisc interactions  JSmediation 
    ##      "3.3.2"      "0.3.0"      "2.3.1"      "4.4-0"      "1.1.3"      "0.1.1" 
    ##         mice   parameters  performance      permuco        ppcor        psych 
    ##     "3.10.0"      "0.8.2"      "0.4.8"      "1.1.0"        "1.1"  "1.9.12.31" 
    ##   psychTools        purrr          pwr summarytools    tidyverse 
    ##     "1.9.12"      "0.3.4"      "1.3-0"      "0.9.6"      "1.3.0"
