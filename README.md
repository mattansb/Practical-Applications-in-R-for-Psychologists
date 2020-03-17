
<img src='logo/BGUHex.png' align="right" height="139" />

# Advanced Research Methods foR Psychologists

<sub>*Last updated 2020-03-17.*</sub>

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
2.  [RStudio](https://www.rstudio.com/products/rstudio/download/)
    (optional - but I recommend using an IDE).
3.  The following packages, listed by lesson:

| Lesson                                                                                              | Packages                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [02 data.frames](/02%20data.frames)                                                                 | [`tidyverse`](https://CRAN.R-project.org/package=tidyverse), [`haven`](https://CRAN.R-project.org/package=haven)                                                                                                                                                                                                                                                         |
| [03 outliers & missing data](/03%20outliers%20&%20missing%20data)                                   | [`finalfit`](https://CRAN.R-project.org/package=finalfit), [`Hmisc`](https://CRAN.R-project.org/package=Hmisc), [`mice`](https://CRAN.R-project.org/package=mice), [`dplyr`](https://CRAN.R-project.org/package=dplyr)                                                                                                                                                   |
| [04 describing data](/04%20describing%20data)                                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`summarytools`](https://CRAN.R-project.org/package=summarytools), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2), [`psych`](https://CRAN.R-project.org/package=psych)                                                                      |
| [05 testing](/05%20testing)                                                                         | [`psych`](https://CRAN.R-project.org/package=psych), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`ppcor`](https://CRAN.R-project.org/package=ppcor), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor)                                                                                                                                 |
| [06 regression](/06%20regression)                                                                   | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`psychTools`](https://CRAN.R-project.org/package=psychTools)                                                        |
| [07 dummy and hierarchical](/07%20dummy%20and%20hierarchical)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`car`](https://CRAN.R-project.org/package=car), [`performance`](https://CRAN.R-project.org/package=performance), [`MASS`](https://CRAN.R-project.org/package=MASS)                                                                                        |
| [08 moderation and curvilinear](/08%20moderation%20and%20curvilinear)                               | [`performance`](https://CRAN.R-project.org/package=performance), [`parameters`](https://CRAN.R-project.org/package=parameters), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`interactions`](https://CRAN.R-project.org/package=interactions), [`emmeans`](https://CRAN.R-project.org/package=emmeans) |
| [09 mediation](/09%20mediation)                                                                     | [`JSmediation`](https://CRAN.R-project.org/package=JSmediation), [`mediation`](https://CRAN.R-project.org/package=mediation)                                                                                                                                                                                                                                             |
| [10 Bayesian model selection](/10%20Bayesian%20model%20selection)                                   | [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [`bayestestR`](https://CRAN.R-project.org/package=bayestestR)                                                                                                                                                                                                                                           |
| [11 assumptions and non-parametric inference](/11%20assumptions%20and%20non-parametric%20inference) | [`performance`](https://CRAN.R-project.org/package=performance), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`GGally`](https://CRAN.R-project.org/package=GGally), [`ggResidpanel`](https://CRAN.R-project.org/package=ggResidpanel), [`permuco`](https://CRAN.R-project.org/package=permuco), [`parameters`](https://CRAN.R-project.org/package=parameters)   |
| [12 generalized linear models](/12%20generalized%20linear%20models)                                 | [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2), [`emmeans`](https://CRAN.R-project.org/package=emmeans)                                                                                                                         |

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "BayesFactor", "bayestestR", "car", "dplyr", "effectsize",
      "emmeans", "finalfit", "GGally", "ggplot2", "ggResidpanel", "haven",
      "Hmisc", "interactions", "JSmediation", "MASS", "mediation",
      "mice", "parameters", "performance", "permuco", "ppcor", "psych",
      "psychTools", "summarytools", "tidyverse"
    )

    install.packages(pkgs, dependencies = TRUE)

The package versions used here:

    ##  BayesFactor   bayestestR          car        dplyr   effectsize      emmeans 
    ## "0.9.12-4.2"      "0.5.2"      "3.0-7"      "0.8.5"      "0.2.0"      "1.4.5" 
    ##     finalfit       GGally      ggplot2 ggResidpanel        haven        Hmisc 
    ##      "1.0.0"      "1.4.0"      "3.3.0"      "0.3.0"      "2.2.0"      "4.3-1" 
    ## interactions  JSmediation    mediation         mice   parameters  performance 
    ##      "1.1.1"      "0.1.1"      "4.5.0"      "3.8.0"    "0.5.0.1"      "0.4.4" 
    ##      permuco        ppcor        psych   psychTools summarytools    tidyverse 
    ##      "1.1.0"        "1.1"  "1.9.12.31"     "1.9.12"      "0.9.6"      "1.3.0" 
    ##         MASS 
    ##   "7.3-51.5"

## To Do

  - [ ] Power analysis with `pwr` (?)
