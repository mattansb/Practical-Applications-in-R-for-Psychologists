
<img src='logo/Hex.png' align="right" height="139" />

# Practical Applications in R for Psychologists

[![](https://img.shields.io/badge/Open%20Educational%20Resources-Compatable-brightgreen)](https://creativecommons.org/about/program-areas/education-oer/)
[![](https://img.shields.io/badge/CC-BY--NC%204.0-lightgray)](http://creativecommons.org/licenses/by-nc/4.0/)  
[![](https://img.shields.io/badge/Language-R-blue)](http://cran.r-project.org/)

<sub>*Last updated 2022-01-18.*</sub>

This Github repo contains all lesson files for *Practical Applications
in R for Psychologists*. The goal is to impart students with the basic
tools to process data, describe data (w/ summary statistics and plots),
and the foundations of **building, evaluating and comparing statistical
models in `R`**, focusing on linear regression modeling (using both
frequentist and Bayesian approaches).

These topics were taught in the graduate-level course ***Advanced
Research Methods for Psychologists*** (Psych Dep., Ben-Gurion University
of the Negev, *Fall semester, 2021*), laying the foundation for the
topic-focused courses (*Spring semester*):

-   Hierarchical linear models (*HLM*).
-   [Analysis of Factorial Designs
    (*ANOVA*)](https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists)
-   [Structural equation modelling
    (*SEM*)](https://github.com/mattansb/Structural-Equation-Modeling-foR-Psychologists)
-   Machine Learning (*ML*).

**Notes:**

-   This repo contains only materials relating to *Practical
    Applications in R*. Though statistics are naturally discussed in
    many lessons, the focus is generally on the application and not on
    the theory.  
-   Please note that some code does not work *on purpose* and without
    warning, to force students to learn to debug.

## Setup

You will need:

1.  A fresh installation of [**`R`**](https://cran.r-project.org/)
    (preferably version 4.1.1 or above).
2.  [RStudio IDE](https://www.rstudio.com/products/rstudio/download/)
    (optional, but recommended).
3.  The following packages, listed by lesson:

| Lesson                                                                                                      | Packages                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|-------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [01 intro](/01%20intro)                                                                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| [02 data wrangling](/02%20data%20wrangling)                                                                 | [**`haven`**](https://CRAN.R-project.org/package=haven), [**`tidyverse`**](https://CRAN.R-project.org/package=tidyverse), [**`readxl`**](https://CRAN.R-project.org/package=readxl), [**`dplyr`**](https://CRAN.R-project.org/package=dplyr), [**`datawizard`**](https://CRAN.R-project.org/package=datawizard), [**`summarytools`**](https://CRAN.R-project.org/package=summarytools), [**`parameters`**](https://CRAN.R-project.org/package=parameters), [**`psych`**](https://CRAN.R-project.org/package=psych), [**`DescTools`**](https://CRAN.R-project.org/package=DescTools), [**`finalfit`**](https://CRAN.R-project.org/package=finalfit), [**`Hmisc`**](https://CRAN.R-project.org/package=Hmisc), [**`mice`**](https://CRAN.R-project.org/package=mice) |
| [03 plotting](/03%20plotting)                                                                               | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [**`ggplot2`**](https://CRAN.R-project.org/package=ggplot2), [**`ragg`**](https://CRAN.R-project.org/package=ragg), [**`tidyr`**](https://CRAN.R-project.org/package=tidyr)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| [04 hypothesis testing and power](/04%20hypothesis%20testing%20and%20power)                                 | [**`effectsize`**](https://CRAN.R-project.org/package=effectsize), [**`correlation`**](https://CRAN.R-project.org/package=correlation), [**`BayesFactor`**](https://CRAN.R-project.org/package=BayesFactor), [`dplyr`](https://CRAN.R-project.org/package=dplyr), [**`pwr`**](https://CRAN.R-project.org/package=pwr), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                                                                                                                                                     |
| [05 regression 101](/05%20regression%20101)                                                                 | [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`parameters`](https://CRAN.R-project.org/package=parameters), [**`performance`**](https://CRAN.R-project.org/package=performance), [**`ggeffects`**](https://CRAN.R-project.org/package=ggeffects), [**`psychTools`**](https://CRAN.R-project.org/package=psychTools)                                                                                                                                                                                                                                                                                                                                                                                                                              |
| [06 categorical predictors and model comparison](/06%20categorical%20predictors%20and%20model%20comparison) | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [**`emmeans`**](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [**`bayestestR`**](https://CRAN.R-project.org/package=bayestestR), [`performance`](https://CRAN.R-project.org/package=performance)                                                                                                                                                                                                                                                                                                                                                                                   |
| [07 moderation and curvilinear](/07%20moderation%20and%20curvilinear)                                       | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`bayestestR`](https://CRAN.R-project.org/package=bayestestR), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [**`modelbased`**](https://CRAN.R-project.org/package=modelbased), [`ggplot2`](https://CRAN.R-project.org/package=ggplot2)                                                                                                                                                                                                                                                               |
| [08 generalized linear models](/08%20generalized%20linear%20models)                                         | [`dplyr`](https://CRAN.R-project.org/package=dplyr), [`parameters`](https://CRAN.R-project.org/package=parameters), [`performance`](https://CRAN.R-project.org/package=performance), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`emmeans`](https://CRAN.R-project.org/package=emmeans)                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| [09 assumption checks and violations](/09%20assumption%20checks%20and%20violations)                         | [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`performance`](https://CRAN.R-project.org/package=performance), [**`see`**](https://CRAN.R-project.org/package=see), [**`bayesplot`**](https://CRAN.R-project.org/package=bayesplot), [**`qqplotr`**](https://CRAN.R-project.org/package=qqplotr), [`datawizard`](https://CRAN.R-project.org/package=datawizard), [**`permuco`**](https://CRAN.R-project.org/package=permuco), [`parameters`](https://CRAN.R-project.org/package=parameters), [**`insight`**](https://CRAN.R-project.org/package=insight)                                                                                                                                                                                            |
| [10 ANOVA](/10%20ANOVA)                                                                                     | [**`afex`**](https://CRAN.R-project.org/package=afex), [`emmeans`](https://CRAN.R-project.org/package=emmeans), [`effectsize`](https://CRAN.R-project.org/package=effectsize), [`ggeffects`](https://CRAN.R-project.org/package=ggeffects), [`tidyr`](https://CRAN.R-project.org/package=tidyr)                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| [11 mediation](/11%20mediation)                                                                             | [**`mediation`**](https://CRAN.R-project.org/package=mediation), [**`tidySEM`**](https://CRAN.R-project.org/package=tidySEM)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |

<sub>*(Bold denotes the first lesson in which the package was
used.)*</sub>

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "afex", "BayesFactor", "bayesplot", "bayestestR", "correlation",
      "datawizard", "DescTools", "dplyr", "effectsize", "emmeans",
      "finalfit", "ggeffects", "ggplot2", "haven", "Hmisc", "insight",
      "mediation", "mice", "modelbased", "parameters", "performance",
      "permuco", "psych", "psychTools", "pwr", "qqplotr", "ragg", "readxl",
      "see", "summarytools", "tidyr", "tidySEM", "tidyverse"
    )

    install.packages(pkgs, repos = c("https://easystats.r-universe.dev", getOption("repos")))

<details>
<summary>
<i>Package Versions</i>
</summary>

Run on Windows 10 x64 (build 22000), with R version 4.1.1.

The packages used here:

-   `afex` 1.0-1 (*CRAN*)
-   `BayesFactor` 0.9.12-4.3 (*CRAN*)
-   `bayesplot` 1.8.1 (*CRAN*)
-   `bayestestR` 0.11.5 (*CRAN*)
-   `correlation` 0.7.1 (*CRAN*)
-   `datawizard` 0.2.2 (*CRAN*)
-   `DescTools` 0.99.44 (*CRAN*)
-   `dplyr` 1.0.7 (*CRAN*)
-   `effectsize` 0.6.0 (*CRAN*)
-   `emmeans` 1.7.1-1 (*CRAN*)
-   `finalfit` 1.0.4 (*CRAN*)
-   `ggeffects` 1.1.1 (*CRAN*)
-   `ggplot2` 3.3.5 (*CRAN*)
-   `haven` 2.4.3 (*CRAN*)
-   `Hmisc` 4.6-0 (*CRAN*)
-   `insight` 0.15.0 (*CRAN*)
-   `mediation` 4.5.0 (*CRAN*)
-   `mice` 3.14.0 (*CRAN*)
-   `modelbased` 0.7.0.1 (*<https://easystats.r-universe.dev>*)
-   `parameters` 0.16.0 (*CRAN*)
-   `performance` 0.8.0.1 (*<https://easystats.r-universe.dev>*)
-   `permuco` 1.1.1 (*CRAN*)
-   `psych` 2.1.9 (*CRAN*)
-   `psychTools` 2.1.12 (*CRAN*)
-   `pwr` 1.3-0 (*CRAN*)
-   `qqplotr` 0.0.5 (*CRAN*)
-   `ragg` 1.2.1 (*CRAN*)
-   `readxl` 1.3.1 (*CRAN*)
-   `see` 0.6.8 (*<https://easystats.r-universe.dev>*)
-   `summarytools` 1.0.0 (*CRAN*)
-   `tidyr` 1.1.4 (*CRAN*)
-   `tidySEM` 0.2.0 (*CRAN*)
-   `tidyverse` 1.3.1 (*CRAN*)

</details>
