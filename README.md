
# Advanced Research Methods foR Psychologists

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
  - Hierarchical linear models (*HLM*).
  - Machine Learning (*ML*).

**Notes:**

  - This repo contains only materials relating to *Practical
    Applications in R*, and does not contain any theoretical or
    introductory materials.  
  - Please note that some code does not work *on purpose*, to force
    students to learn to debug. <sub>(Other code might not work because…
    I’m only human, okay??)</sub>  
  - Solutions to exercises are not provided here (yet?). Sorry.

## Setup

You will need:

1.  A fresh installation of [**`R`**](https://cran.r-project.org/)
    (preferably version 3.6 or above).
2.  [RStudio](https://www.rstudio.com/products/rstudio/download/)
    (optional - but I recommend using an IDE).
3.  The following packages, listed by lesson:

<!-- end list -->

``` r
pkgs <- c(
  # 02 data.frames
  "tidyverse", # "reader", "dplyr", "tidyr",
  # 04 missing data
  "finalfit", "Hmisc", "mice", 
  # 05 describing data
  "dplyr", "parameters", "summarytools", "psych", "ggplot2",
  # 06 testing
  "psych", "apa", "ppcor", "BayesFactor", 
  # 07 regression
  "dplyr", "parameters", "performance", "psych", "see",
  # 08 hierarchical (and dummy)
  "dplyr", "emmeans", "car", "performance",
  # 09 moderation
  "dplyr", "emmeans", "interactions",
  # 10 mediation & curvilinear,
  "ggplot2", "performance", "JSmediation",
  # 11 beyond NHST
   "BayesFactor", "bayestestR", "see",
  # 12 assumption checks & non-parameteric inference
  "performance", "dplyr", "ggplot2", "GGally", "ggResidpanel", "parameters", "permuco"
)
```

<!-- And their versions: -->

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "apa", "BayesFactor", "bayestestR", "car", "dplyr", "emmeans",
      "finalfit", "GGally", "ggplot2", "ggResidpanel", "Hmisc", "interactions",
      "JSmediation", "mice", "parameters", "performance", "permuco",
      "ppcor", "psych", "see", "summarytools", "tidyverse"
    )

``` r
install.packages(pkgs, dependencies = TRUE)
```

## To Do

  - [ ] Equivalence testing (?)
  - [ ] Logistic Regression (?)
  - [ ] Power analysis with `pwr`?
