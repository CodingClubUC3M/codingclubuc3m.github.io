---
layout: post
comments:  true
title: "RStudio Addin Code-Helpers for Plotting"
date: 2016-01-21 18:00:00
published: true
categories: [R]
output:
  html_document:
    mathjax:  default
---

There are many benefits to teaching undergraduate statistics with R--especially in the RStudio environment--but it must be admitted that the learning curve is fairly steep, especially when it comes to tinkering with plots to get them to look just the way one wants.  If there were ever a situation when I would prefer that the students have access to a graphical user interface, production of plots would be it.

You can, of course, write Shiny apps like [this one](https://homer.shinyapps.io/bwplotAddin/), where the user controls features of the graphs through various input-widgets.  But then the user must visit the remote site, and if he or she wishes to build a graph from a data frame not supplied by the app, then the app has to deal with thorny issues surrounding the uploading and processing of .csv files, and in the end the user still has to copy and paste the relevant graph-making code back to wherever it was needed.

It would be much nicer if all of this could be accomplished locally.  `mPlot()` in [package `mosaic`](https://cran.r-project.org/web/packages/mosaic/index.html) does a great job in this respect by taking advantage of RStudio's `manipulate` package.  However, `manipulate` doesn't offer much flexibility in terms of control of inputs, so it's not feasible within the `manipulate` framework to write a code-helper that allows much fine-tuning one's plot.

[Addins](http://rstudio.github.io/rstudioaddins/) (a new feature in the current RStudio [Preview Version](https://www.rstudio.com/products/rstudio/download/preview/)) permit us to have the best of both worlds.  An Addin works like a locally-run Shiny app.  As such it can draw on information available in the user's R session, and it can return information directly to where the user needs it in a source document such as an R script or R Markdown file.

[addinplots](https://github.com/homerhanumat/addinplots) is a package of Addins, each of which is a code-helper for a particular type of plot in the `lattice` graphing system.  The intention is to help students (and colleagues who are newcomers to `lattice`) to make reasonably well-customized graphs while teaching--through example--the rudiments of the coding principles of the `lattice` package.


If you are using the Preview version of RStudio and would like to give these Addins a try, then follow the installation directions in the [article cited above](http://rstudio.github.io/rstudioaddins/).  In addition, install my package and one of its dependencies, as follows:

```
devtools::install_github("homerhanumat/shinyCustom")
devtools::install_github("homerhanumat/addinplots")
```

To use an Addin:

* Type the name of a data frame into an R script, or inside a code chunk in an R Markdown document.
* Select the name.
* Go to the Addins button and pick the Addin for the plot you wish to make.
* The Addin will walk you through the process of constructing a graph based upon variables in your data frame.  At each step you see the graph to that point, along with R-code to produce said graph.
* When you are happy with your graph press the Done button. The app will go dark.
* Close the app tab and return to RStudio.

You will see that the code for your graph has been inserted in place of the name of the data frame.

These Addins are flexible enough to handle the everyday needs of beginning students in undergraduate statistics classes, but they only scratch the surface of `lattice`'s capability.  Eventually students should graduate to coding directly with `lattice`.

My Addins are scarcely more than toys, and clunky ones at that.  I imagine that before long other folks will have written a host of Addins that accomplish some quite sophisticated tasks and make the R environment much more "GUI."  I'm excited to see what will happen.

*Note on addinplot performance*:  My Addins are intended for use in a classroom setting where the entire class is working on a single not-so-powerful RStudio server.  Accordingly many of the input controls have been customized to inhibit their propensity to update.  When you are entering text or a number, you need to press Enter or shift focus away from the input area in order to cue the machine to update your information.  You will also note (in the `cloudplotAddin`) that sliders take a bit longer to "respond".  These input-damping behaviors, enabled by the [`shinyCustom`](https://github.com/homerhanumat/shinyCustom) package, prevent the Server from being overwhelmed by numerous requests for expensive graph-computations that most users don't really want.

