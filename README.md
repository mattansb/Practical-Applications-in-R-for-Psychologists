
# Advanced Research Methods foR Psychologists

This Github repo contains all lesson files used in the *Advanced
Research Methods foR Psychologists - Practical Applications in R*,
taught at Ben-Gurion University on the Negev (2019-2020).

<sub>(Please note that some code does not work *on purpose*, to force
students to learn to debug.)  
(Other code might not work because… I’m only human, okay??)</sub>

## List of packages

Here is a list of packages used in the course, by lesson:

``` r
pkgs <- c(
  # 02 data.frames
  'tidyverse', # 'reader', 'dplyr', 'tidyr',
  # 03 misc1
  'Hmisc', 'mice', 'dplyr', 'tidyr', 
  # 04 describing data
  'dplyr', 'psych', 'ggplot2',
  # 05 testing
  'psych', 'apa', 'ppcor', 'BayesFactor', 
  # 06 regression
  'dplyr', 'parameters', 'performance', 'psych',
  # 07 hierarchical (and dummy)
  'dplyr', 'emmeans', 'car', 'performance',
  # 08 moderation
  'dplyr', 'emmeans', 'interactions',
  # 09 mediation & curvilinear,
  'ggplot2', 'performance', 'emmeans', 'JSmediation'
)
```

Overall, these are the packages used in this course:

    pkgs <- c("apa", "BayesFactor", "car", "dplyr", "emmeans", "ggplot2",  
    "Hmisc", "interactions", "JSmediation", "mice", "parameters",  
    "performance", "ppcor", "psych", "tidyr", "tidyverse")

You can install all the packages by running:

``` r
install.packages(pkgs, dependencies = TRUE)
```

### To Do

  - [ ] Bayesian Regression
      - [ ] Equivalence testing(?)
  - [ ] Assumption checks
  - [ ] Logistic Regression
