
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

## List of packages

Here is a list of packages used in the course, by lesson:

``` r
pkgs <- c(
  # 02 data.frames
  "tidyverse", # "reader", "dplyr", "tidyr",
  # 04 missing data
  "Hmisc", "mice", "dplyr", "tidyr", 
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
  "ggplot2", "performance", "emmeans", "JSmediation",
  # 11 beyond NHST
   "BayesFactor", "bayestestR", "see",
  # 12 assumption checks
  "performance", "dplyr", "ggplot2", "GGally", "ggResidpanel"
)
```

And their versions:

    ##          apa  BayesFactor   bayestestR          car        dplyr 
    ##      "0.3.2" "0.9.12-4.2"      "0.2.5"      "3.0-3"      "0.8.3" 
    ##      emmeans       GGally      ggplot2 ggResidpanel        Hmisc 
    ##      "1.4.1"      "1.4.0"      "3.2.1"      "0.3.0"      "4.2-0" 
    ## interactions  JSmediation         mice   parameters  performance 
    ##      "1.1.1"      "0.1.0"      "3.6.0"      "0.1.0"      "0.3.0" 
    ##        ppcor        psych          see summarytools        tidyr 
    ##        "1.1"     "1.8.12"      "0.2.1"      "0.9.4"      "1.0.0" 
    ##    tidyverse 
    ##      "1.2.1"

You can install all the packages used by running:

    # in alphabetical order:

    pkgs <- c(
      "apa", "BayesFactor", "bayestestR", "car", "dplyr", "emmeans",
      "GGally", "ggplot2", "ggResidpanel", "Hmisc", "interactions",
      "JSmediation", "mice", "parameters", "performance", "ppcor",
      "psych", "see", "summarytools", "tidyr", "tidyverse"
    )

``` r
install.packages(pkgs, dependencies = TRUE)
```

### To Do

  - [ ] Equivalence testing (?)
  - [ ] Logistic Regression (?)
