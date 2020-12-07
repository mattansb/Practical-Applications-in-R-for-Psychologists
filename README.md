
<img src='logo/Hex.png' align="right" height="139" />

# Practical Applications in R for Psychologists

[![](https://img.shields.io/badge/Open%20Educational%20Resources-Compatable-brightgreen)](https://creativecommons.org/about/program-areas/education-oer/)
[![](https://img.shields.io/badge/CC-BY--NC%204.0-lightgray)](http://creativecommons.org/licenses/by-nc/4.0/)  
[![](https://img.shields.io/badge/Language-R-blue)](http://cran.r-project.org/)

<sub>*Last updated 2020-12-06.*</sub>

This Github repo contains all lesson files for *Practical Applications
in R for Psychologists*. The goal is to impart students with the basic
tools to process data, describe data (w/ summary statistics and plots),
and the foundations of **building, evaluating and comparing statistical
models in `R`**, focusing on linear regression modeling (using both
frequentist and Bayesian approaches).

These topics were taught in the graduate-level course ***Advanced
Research Methods for Psychologists*** (Psych Dep., Ben-Gurion University
of the Negev, *Fall semester, 2020*), laying the foundation for the
topic-focused courses (*Spring semester*):

  - Hierarchical linear models (*HLM*).
  - [Analysis of Factorial Designs
    (*ANOVA*)](https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists)
  - [Structural equation modelling
    (*SEM*)](https://github.com/mattansb/Structural-Equation-Modeling-foR-Psychologists)
  - Machine Learning (*ML*).

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

| Lesson                                                                                                      | Packages                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [01 intro](/01%20intro)                                                                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| [02 data wrangling](/02%20data%20wrangling)                                                                 | [**`haven`**](https://CRAN.R-project.org/package=haven), [**`tidyverse`**](https://CRAN.R-project.org/package=tidyverse), [**`readxl`**](https://CRAN.R-project.org/package=readxl), [**`dplyr`**](https://CRAN.R-project.org/package=dplyr), [**`parameters`**](https://CRAN.R-project.org/package=parameters), [**`summarytools`**](https://CRAN.R-project.org/package=summarytools), [**`psych`**](https://CRAN.R-project.org/package=psych), [**`DescTools`**](https://CRAN.R-project.org/package=DescTools), [**`finalfit`**](https://CRAN.R-project.org/package=finalfit), [**`Hmisc`**](https://CRAN.R-project.org/package=Hmisc), [**`mice`**](https://CRAN.R-project.org/package=mice) |
| [03 plotting](/03%20plotting)                                                                               | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [**`ggplot2`**](https://CRAN.R-project.org/package=ggplot2), [**`tidyr`**](https://CRAN.R-project.org/package=tidyr)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| [04 hypothesis testing and power](/04%20hypothesis%20testing%20and%20power)                                 | [`psych`](https://CRAN.R-project.org/package=psych), [**`effectsize`**](https://CRAN.R-project.org/package=effectsize), [**`BayesFactor`**](https://CRAN.R-project.org/package=BayesFactor), [**`pwr`**](https://CRAN.R-project.org/package=pwr), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                                                                                                                                                       |
| [05 regression 101](/05%20regression%20101)                                                                 | [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`parameters`](https://CRAN.R-project.org/package=parameters), [**`performance`**](https://CRAN.R-project.org/package=performance), [**`ggeffects`**](https://CRAN.R-project.org/package=ggeffects), [**`psychTools`**](https://CRAN.R-project.org/package=psychTools)                                                                                                                                                                                                                                                                                                                                                           |
| [06 categorical predictors and model comparison](/06%20categorical%20predictors%20and%20model%20comparison) | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [**`emmeans`**](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`BayesFactor`](https://CRAN.R-project.org/package=BayesFactor), [**`bayestestR`**](https://CRAN.R-project.org/package=bayestestR), [`performance`](https://CRAN.R-project.org/package=performance)                                                                                                                                                                                                                                               |
| [07 moderation and curvilinear](/07%20moderation%20and%20curvilinear)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`performance`](https://CRAN.R-project.org/package=performance), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [**`interactions`**](https://CRAN.R-project.org/package=interactions), [`parameters`](https://CRAN.R-project.org/package=parameters), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                       |
| [08 generalized linear models](/08%20generalized%20linear%20models)                                         | [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`emmeans`](https://CRAN.R-project.org/package=emmeans)                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| [09 assumption checks and violations](/09%20assumption%20checks%20and%20violations)                         | [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`performance`](https://CRAN.R-project.org/package=performance), [**`ggResidpanel`**](https://CRAN.R-project.org/package=ggResidpanel), [`parameters`](https://CRAN.R-project.org/package=parameters), [**`permuco`**](https://CRAN.R-project.org/package=permuco), [**`insight`**](https://CRAN.R-project.org/package=insight)                                                                                                                                                                                                                                                                                                    |
| [10 ANOVA](/10%20ANOVA)                                                                                     | [**`afex`**](https://CRAN.R-project.org/package=afex), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`tidyr`](https://CRAN.R-project.org/package=tidyr)                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| [11 mediation](/11%20mediation)                                                                             | [**`mediation`**](https://CRAN.R-project.org/package=mediation)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

<sub>*(Bold denotes the first lesson in which the package was
used.)*</sub>

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "afex", "BayesFactor", "bayestestR", "DescTools", "dplyr",
      "effectsize", "emmeans", "finalfit", "ggeffects", "ggplot2",
      "ggResidpanel", "haven", "Hmisc", "insight", "interactions",
      "mediation", "mice", "parameters", "performance", "permuco",
      "psych", "psychTools", "pwr", "readxl", "summarytools", "tidyr", "tidyverse"
    )

    install.packages(pkgs, dependencies = TRUE)

<details>

<summary><i>Package Versions</i></summary> The package versions used
here:

  - `afex` 0.28-0 (*CRAN*)
  - `BayesFactor` 0.9.12-4.2 (*CRAN*)
  - `bayestestR` 0.8.0 (*CRAN*)
  - `DescTools` 0.99.38 (*CRAN*)
  - `dplyr` 1.0.2 (*CRAN*)
  - `effectsize` 0.4.1 (*Dev*)
  - `emmeans` 1.5.2-1 (*CRAN*)
  - `finalfit` 1.0.2 (*CRAN*)
  - `ggeffects` 0.16.0 (*CRAN*)
  - `ggplot2` 3.3.2 (*CRAN*)
  - `ggResidpanel` 0.3.0 (*CRAN*)
  - `haven` 2.3.1 (*CRAN*)
  - `Hmisc` 4.4-1 (*CRAN*)
  - `insight` 0.11.0 (*CRAN*)
  - `interactions` 1.1.3 (*CRAN*)
  - `mediation` 4.5.0 (*CRAN*)
  - `mice` 3.11.0 (*CRAN*)
  - `parameters` 0.10.0 (*CRAN*)
  - `performance` 0.6.0 (*CRAN*)
  - `permuco` 1.1.0 (*CRAN*)
  - `psych` 2.0.9 (*CRAN*)
  - `psychTools` 2.0.8 (*CRAN*)
  - `pwr` 1.3-0 (*CRAN*)
  - `readxl` 1.3.1 (*CRAN*)
  - `summarytools` 0.9.6 (*CRAN*)
  - `tidyr` 1.1.2 (*CRAN*)
  - `tidyverse` 1.3.0 (*CRAN*)

</details>
