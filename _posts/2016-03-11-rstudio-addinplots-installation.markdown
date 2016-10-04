---
layout: post
comments:  true
title: "Installing the Addinplots Package "
date: 2016-03-11 18:00:00
published: true
categories: [Tech Notes]
output:
  html_document:
    mathjax:  default
---

This is a quick note for instructors interested in installing the `addinplots` package.

First of all, you need a recent version of RStudio that enables Addins.  At the time of writing this is version 0.99.891.

You'll need several packages from CRAN, so run:

```
install.packages(c("devtools","shiny","miniUI",
                   "Hmisc","rstudioapi","lattice","devtools"))
```

Run this even if you already have some of these packages:  you will need up-to-date versions.

The `devtools` package allows you to install packages from GitHub.  Run the following two commands:

```
devtools::install_github("homerhanumat/shinyCustom")
devtools::install_github("homerhanumat/addinplots")
```

The `addinplots` package is now installed.  Refer to the previous post for details on use.

