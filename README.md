
# Advanced Research Methods foR Psychologists

This Github repo contains all lesson files used in the graduate-level
course: *Advanced Research Methods foR Psychologists - Practical
Applications in R*, taught at Ben-Gurion University on the Negev (fall
2019 semester).

The goal is to impart students with the basic tools to process data,
describe data (w/ summary statistics and plots), and finally build,
evaluate and compare statistical models (using both the frequentist and
Bayesian approach), focusing mostly on linear regression modeling. These
lesson will lay the foundation for the advance courses:

  - Structural equation modelling (*SEM*)
  - Analysis of factorial data with (*ANOVA*).
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

## List of packages

Here is a list of packages used in the course, by lesson:

``` r
pkgs <- c(
  # 02 data.frames
  "tidyverse", # "reader", "dplyr", "tidyr",
  # 03 misc1
  "Hmisc", "mice", "dplyr", "tidyr", 
  # 04 describing data
  "dplyr", "psych", "ggplot2",
  # 05 testing
  "psych", "apa", "ppcor", "BayesFactor", 
  # 06 regression
  "dplyr", "parameters", "performance", "psych", "see",
  # 07 hierarchical (and dummy)
  "dplyr", "emmeans", "car", "performance",
  # 08 moderation
  "dplyr", "emmeans", "interactions",
  # 09 mediation & curvilinear,
  "ggplot2", "performance", "emmeans", "JSmediation",
  # 10 beyond NHST
   "BayesFactor", "bayestestR", "see",
  # 11 misc2
  "performance", "dplyr", "ggplot2", "GGally", "ggResidpanel"
)
```

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "apa", "BayesFactor", "bayestestR", "car", "dplyr", "emmeans",
      "GGally", "ggplot2", "ggResidpanel", "Hmisc", "interactions",
      "JSmediation", "mice", "parameters", "performance", "ppcor",
      "psych", "see", "tidyr", "tidyverse"
    )

``` r
install.packages(pkgs, dependencies = TRUE)
```

### To Do

  - [ ] Equivalence testing (?)
  - [ ] Logistic Regression (?)
