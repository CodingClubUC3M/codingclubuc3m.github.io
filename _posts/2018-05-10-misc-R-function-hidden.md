---
layout: post
comments:  true
title: "Useful one-function R packages, big data solutions, and a message from Yoda - Hidden"
author: Eduardo García-Portugués
date: 2018-05-10 20:30:00
published: true
visible: false
categories: [R, big data, visualization, benchmark]
excerpt_seperator: <!--more-->
output:
  html_document:
    mathjax:  default
---

**Abstract:** As the title reads, in this heterogeneous talk we will see three topics of different interest. The first is a collection of three simple and useful one-function R packages that I use regularly in my coding workflow. The second collects some approaches to handling and performing linear regression with big data. The third brings in the freaky component: it presents tools to display graphical information in plain ASCII, from bivariate contours to messages from Yoda!

Materials to be disclosed at the session! 

<!--

## Required packages

We will need these packages for today's session:


{% highlight r linenos %}
install.packages(c("viridis", "microbenchmark", "multcomp", "manipulate", 
                   "Rmpfr", "ffbase", "biglm", "leaps", "txtplot", 
                   "NostalgiR", "cowsay"), 
                 dependencies = TRUE)
{% endhighlight %}

## Some simple and useful `R` packages

### Color palettes with `viridis`

Built-in color palettes in base `R` are somehow limited. We have `rainbow`, `topo.colors`, `terrain.colors`, `heat.colors`, and `cm.colors`. We also have flexibility to create our own palettes, e.g. by using `colorRamp`. These palettes look like:


{% highlight r linenos %}
# MATLAB's color palette
jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                                 "#7FFF7F", "yellow", "#FF7F00", "red", 
                                 "#7F0000"))
# Plot for palettes
testPalette <- function(col, n = 200, ...) {
  image(1:n, 1, as.matrix(1:n), col = get(col)(n = n, ...), 
        main = col, xlab = "", ylab = "", axes = FALSE)
}

# Color palettes comparison
par(mfrow = c(2, 3))
res <- sapply(c("rainbow", "topo.colors", "terrain.colors", 
                "heat.colors", "cm.colors", "jet.colors"), testPalette)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-1-1.png)

Notice that some palettes clearly show **non-uniformity** in the color gradient. This potentially leads to a bias when interpreting the color scales: some features are (unfairly) weakened and others are (unfairly) strengthen. This distortion on the representation of the data can be quite misleading.

In addition to these problems, some problematic points that are not usually thought when choosing a color scale are:

- What happens when you print out the image in **black-and-white**?
- How do **colorblind** people read the images?

The package [`viridisLite`](https://cran.r-project.org/web/packages/viridisLite/index.html) (a port from `Python`'s [`Matplotlib`](http://matplotlib.org/)) comes to solve these issues. It provides the *viridis* color palette, which uses notions from color theory to be as much uniform as possible, black-and-white-ready, and colorblind-friendly. From `viridisLite`'s help:

> This color map is designed in such a way that it will analytically be perfectly perceptually-uniform, both in regular form and also when converted to black-and-white. It is also designed to be perceived by readers with the most common form of color blindness.

More details can be found in this great talk by one of the authors:


{% highlight text %}
## Error in loadNamespace(name): there is no package called 'webshot'
{% endhighlight %}

There are several palettes in the package. All of them have the same properties as `viridis` (*i.e.*, perceptually-uniform, black-and-white-ready, and colorblind-friendly). The `cividis` is specifically aimed to people with color vision deficiency. Let's see them in action:


{% highlight r linenos %}
library(viridisLite)
# Color palettes comparison
par(mfrow = c(2, 3))
res <- sapply(c("viridis", "magma", "inferno", "plasma", "cividis"), 
              testPalette)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-3-1.png)

Some useful options for any of the palettes are:


{% highlight r linenos %}
# Reverse palette
par(mfrow = c(1, 2))
testPalette("viridis", direction = 1)
testPalette("viridis", direction = -1)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-4-1.png)

{% highlight r linenos %}
# Truncate
par(mfrow = c(1, 2))
testPalette("viridis", begin = 0, end = 1)
testPalette("viridis", begin = 0.25, end = 0.75)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-4-2.png)

{% highlight r linenos %}
# Transparency
par(mfrow = c(1, 2))
testPalette("viridis", alpha = 1)
testPalette("viridis", alpha = 0.5)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-4-3.png)

In the extended [`viridis`](https://cran.r-project.org/web/packages/viridis/index.html) package there are color palettes functions for `ggplot2` fans: `scale_colour_viridis` (or `scale_color_viridis`) and `scale_fill_viridis`. Some examples of their use:


{% highlight r linenos %}
library(viridis)
library(ggplot2)

# scale_color_viridis
ggplot(mtcars, aes(wt, mpg)) + 
  geom_point(size = 4, aes(colour = factor(cyl))) +
  scale_color_viridis(discrete = TRUE) +
  theme_bw()
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-5-1.png)

{% highlight r linenos %}
# scale_fill_viridis
dat <- data.frame(x = rnorm(1e4), y = rnorm(1e4))
ggplot(dat, aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-5-2.png)

{% highlight r linenos %}
# scale_fill_gradientn with viridis
ggplot(dat, aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_gradientn(colours = viridis(256))
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/viridis-5-3.png)

### Benchmarking with `microbenchmark`

Measuring the code performance is a day-to-day routine for many developers. It is also a requirement for regular users that want to choose the most efficient coding strategy for implementing a method.

We can measure computing times in base `R` using `proc.time` or `system.time`:


{% highlight r linenos %}
# Using proc.time
time <- proc.time()
for (i in 1:100) rnorm(100)
time <- proc.time() - time
time # elapsed is the 'real' elapsed time since the process was started
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.004   0.000   0.005
{% endhighlight %}



{% highlight r linenos %}
# Using system.time - a wrapped for the above code
system.time({for (i in 1:100) rnorm(100)})
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.004   0.000   0.003
{% endhighlight %}

However, this very basic approach presents several inconveniences to be aware:

- The precision of `proc.time` is within the millisecond. This means that evaluating `1:1000000` takes `0` seconds at the sight of `proc.time`.
- Each time measurement of a procedure is subject to variability (depends on the processor usage at that time, processor warm-up, memory status, etc). So, one single call is not enough to assess the time performance, several must be made (conveniently) and averaged.
- It is cumbersome to check the times for different expressions. We will need several lines of code for each and creating auxiliary variables.
- We do not have easy-to-use summaries of the timings. We have to code them by ourselves.
- We cannot check automatically if the different procedures yield the same result (accuracy is also important, not only speed).

Hopefully, the [`microbenchmark`](https://cran.r-project.org/package=microbenchmark) package fills in these gaps. Let's see an example of its usage on approaching a common problem in `R`: how to **recentre a matrix by columns**, *i.e.*, how to make each column to have zero mean. There are several possibilities to do so, with different efficiencies.


{% highlight r linenos %}
# Data and mean
n <- 3
m <- 10
X <- matrix(1:(n * m), nrow = n, ncol = m)
mu <- colMeans(X)
# We assume mu is given in the time comparisons

# The competing approaches

# 1) sweep
Y1 <- sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-")

# 2) apply (+ transpose to maintain the arrangement of X)
Y2 <- t(apply(X, 1, function(x) x - mu))

# 3) scale
Y3 <- scale(X, center = mu, scale = FALSE)

# 4) loop
Y4 <- matrix(0, nrow = n, ncol = m)
for (j in 1:m) Y4[, j] <- X[, j] - mu[j]
  
# 5) implicit column recycling (my favourite!)
Y5 <- t(t(X) - mu)

# All the same?
c(max(abs(Y1 - Y2)), max(abs(Y1 - Y3)), 
  max(abs(Y1 - Y4)), max(abs(Y1 - Y5))) < 1e-15
{% endhighlight %}



{% highlight text %}
## [1] TRUE TRUE TRUE TRUE
{% endhighlight %}



{% highlight r linenos %}
# With microbenchmark
library(microbenchmark)
bench <- microbenchmark(
  sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-"), 
  t(apply(X, 1, function(x) x - mu)), 
  scale(X, center = mu, scale = FALSE), 
  {for (j in 1:m) Y4[, j] <- X[, j] - mu[j]; Y4},
  t(t(X) - mu)
)

# Printing a microbenchmark object gives a numerical summary
bench
{% endhighlight %}



{% highlight text %}
## Unit: microseconds
##                                                     expr      min
##          sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-")   33.676
##                       t(apply(X, 1, function(x) x - mu))   27.618
##                     scale(X, center = mu, scale = FALSE)   39.876
##  {     for (j in 1:m) Y4[, j] <- X[, j] - mu[j]     Y4 } 2024.901
##                                             t(t(X) - mu)    4.624
##         lq       mean    median        uq      max neval cld
##    51.6185   64.39349   58.9395   71.6055  162.440   100  a 
##    44.8820   68.20103   55.9700   73.4285 1055.247   100  a 
##    59.3545   97.65434   69.4460   84.8210 2393.015   100  a 
##  2913.2465 3082.84117 3173.4515 3340.3345 5900.946   100   b
##     8.1505   12.10247   10.4380   14.9845   27.384   100  a
{% endhighlight %}



{% highlight r linenos %}
# Notice the last column. It is only present if the package multcomp is present.
# It provides a statistical ranking (accounts for which method is significantly 
# slower or faster) using multcomp::cld
 
# Adjusting display
print(bench, unit = "ms", signif = 2)
{% endhighlight %}



{% highlight text %}
## Unit: milliseconds
##                                                     expr    min     lq
##          sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-") 0.0340 0.0520
##                       t(apply(X, 1, function(x) x - mu)) 0.0280 0.0450
##                     scale(X, center = mu, scale = FALSE) 0.0400 0.0590
##  {     for (j in 1:m) Y4[, j] <- X[, j] - mu[j]     Y4 } 2.0000 2.9000
##                                             t(t(X) - mu) 0.0046 0.0082
##   mean median    uq   max neval cld
##  0.064  0.059 0.072 0.160   100  a 
##  0.068  0.056 0.073 1.100   100  a 
##  0.098  0.069 0.085 2.400   100  a 
##  3.100  3.200 3.300 5.900   100   b
##  0.012  0.010 0.015 0.027   100  a
{% endhighlight %}



{% highlight r linenos %}
# unit = "ns" (nanosecs), "us" ("microsecs"), "ms" (millisecs), "s" (secs)

# Graphical methods for the microbenchmark object
# Raw time data
plot(bench, names = c("sweep", "apply", "scale", "for", "recycling"))
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/bench-2-1.png)

{% highlight r linenos %}
# Employs time logarithms
boxplot(bench, names = c("sweep", "apply", "scale", "for", "recycling")) 
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/bench-2-2.png)

{% highlight r linenos %}
# Violin plots
autoplot(bench)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/bench-2-3.png)

{% highlight r linenos %}
# microbenchmark uses 100 evaluations and 2 warmup evaluations (these are not 
# measured) by default. Here is how to change these dafaults:
bench2 <- microbenchmark(
  sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-"), 
  t(apply(X, 1, function(x) x - mu)), 
  scale(X, center = mu, scale = FALSE), 
  {for (j in 1:m) Y4[, j] <- X[, j] - mu[j]; Y4},
  t(t(X) - mu),
  times = 1000, control = list(warmup = 10)
)
bench2
{% endhighlight %}



{% highlight text %}
## Unit: microseconds
##                                                     expr      min
##          sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-")   29.942
##                       t(apply(X, 1, function(x) x - mu))   25.675
##                     scale(X, center = mu, scale = FALSE)   33.773
##  {     for (j in 1:m) Y4[, j] <- X[, j] - mu[j]     Y4 } 1890.059
##                                             t(t(X) - mu)    4.259
##         lq       mean    median        uq      max neval cld
##    37.7850   48.13055   47.3860   54.2105  110.666  1000 ab 
##    35.7895   47.10295   44.5530   52.2885 1116.165  1000 ab 
##    44.6395   61.96133   54.6885   62.7740 2980.853  1000  b 
##  2018.6440 2453.39351 2101.2185 2894.7785 6819.791  1000   c
##     7.2975    9.59163    9.4335   11.1680   66.835  1000 a
{% endhighlight %}



{% highlight r linenos %}
# Let's check the accuracy of the methods as well as their timings. For that 
# we need to define a check function that takes as input a LIST with each slot
# representing the output of each method. The check must return TRUE or FALSE
check1 <- function (results) {
  all(sapply(results[-1], function(x) {
    max(abs(x - results[[1]]))
    }) < 1e-15) # Compares all results pair-wisely with the first
}

# Example with check function
bench3 <- microbenchmark(
  sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-"), 
  t(apply(X, 1, function(x) x - mu)), 
  scale(X, center = mu, scale = FALSE), 
  {for (j in 1:m) Y4[, j] <- X[, j] - mu[j]; Y4},
  t(t(X) - mu),
  check = check1
)
bench3
{% endhighlight %}



{% highlight text %}
## Unit: microseconds
##                                                     expr      min       lq
##          sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-")   32.674   47.261
##                       t(apply(X, 1, function(x) x - mu))   31.310   46.614
##                     scale(X, center = mu, scale = FALSE)   38.124   56.867
##  {     for (j in 1:m) Y4[, j] <- X[, j] - mu[j]     Y4 } 2031.521 2148.141
##                                             t(t(X) - mu)    4.263    8.678
##        mean    median        uq      max neval cld
##    58.18408   55.1075   66.6825  191.149   100  a 
##    56.00189   53.7235   64.0190  108.812   100  a 
##    68.87438   64.4450   74.3405  374.339   100  a 
##  2797.97590 2988.4680 3124.3430 6647.236   100   b
##    11.69104   10.9580   14.7735   26.678   100  a
{% endhighlight %}

### Quick animations with `manipulate`

The [`manipulate`](https://cran.r-project.org/package=manipulate) package (works only within `RStudio`!) allows to easily create simple animations. It is a simpler, local, alternative to `Shiny` applications.


{% highlight r linenos %}
library(manipulate)

# A simple example
manipulate({
  plot(1:n, sin(2 * pi * (1:n) / 100), xlim = c(1, 100), ylim = c(-1, 1),
       type = "o", xlab = "x", ylab = "y")
  lines(1:100, sin(2 * pi * 1:100 / 100), col = 2)
}, n = slider(min = 1, max = 100, step = 1, ticks = TRUE))
{% endhighlight %}


{% highlight r linenos %}
# Illustrating several types of controls using the kernel density estimator
manipulate({
  
  # Sample data
  if (newSample) {
    set.seed(sample(1:1000))
  } else {
    set.seed(12345678)
  }
  samp <- rnorm(n = n, mean = 0, sd = 1.5) 
  
  # Density estimate
  plot(density(x = samp, bw = h, kernel = kernel), 
       xlim = c(-x.rang, x.rang)/2, ylim = c(0, y.max))
  
  # Show data
  if (rugSamp) {
    rug(samp)
  }
  
  # Add reference density
  if (realDensity) {
    tt <- seq(-x.rang/2, x.rang/2, l = 200)
    lines(tt, dnorm(x = tt, mean = 0, sd = 1.5), col = 2)
  }
  },
  n = slider(min = 1, max = 250, step = 5, initial = 10),
  h = slider(0.05, 2, initial = 0.5, step = 0.05),
  x.rang = slider(1, 10, initial = 6, step = 0.5),
  y.max = slider(0.1, 2, initial = 0.5, step = 0.1),
  kernel = picker("gaussian", "epanechnikov", "rectangular", 
                  "triangular", "biweight", "cosine", "optcosine"),
  rugSamp = checkbox(TRUE, "Show rug"),
  realDensity = checkbox(TRUE, "Draw real density"),
  newSample = button("New sample!")
  )
{% endhighlight %}


{% highlight r linenos %}
# Another example: rotating 3D graphs without using rgl

# Mexican hat
x <- seq(-10, 10, l = 50)
y <- x
f <- function(x, y) {r <- sqrt(x^2 + y^2); 10 * sin(r)/r}
z <- outer(x, y, f)

# Colors
nrz <- nrow(z)
ncz <- ncol(z)
zfacet <- z[-1, -1] + z[-1, -ncz] + z[-nrz, -1] + z[-nrz, -ncz]
col <- viridis(100)
facetcol <- cut(zfacet, length(col))
col <- col[facetcol]

# 3D plot
manipulate(
  persp(x, y, z, theta = theta, phi = phi, expand = 0.5, col = col,
        ticktype = "detailed", xlab = "X", ylab = "Y", zlab = "Sinc(r)"),
  theta = slider(-180, 180, initial = 30, step = 5),
  phi = slider(-90, 90, initial = 30, step = 5))
{% endhighlight %}

## Handling big data in `R`

### The `ff` and `ffbase` packages

`R` stores all the data in RAM, which is where all the processing takes place. But when the data does not fit into RAM (e.g., vectors of size $2\times10^9$), alternatives are needed. [`ff`](https://cran.r-project.org/web/packages/ff/index.html) is an `R` package for working with data that does not fit in RAM. From `ff`'s description:

> The `ff` package provides data structures that are stored on disk but behave (almost) as if they were in RAM by transparently mapping only a section (pagesize) in main memory - the effective virtual memory consumption per `ff` object.

The package `ff` lacks some standard statistical methods for operating with `ff` objects. These are provided by [``ffbase`](https://cran.r-project.org/web/packages/ffbase/index.html).

Let's see some examples.


{% highlight r linenos %}
# Not really "big data", but for the sake of illustration
set.seed(12345)
n <- 1e6
p <- 10
beta <- seq(-1, 1, length.out = p)^5

# Data for linear regression
x1 <- matrix(rnorm(n * p), nrow = n, ncol = p)
x1[, p] <- 2 * x1[, 1] + rnorm(n, sd = 0.1)
x1[, p - 1] <- 2 - x1[, 2] + rnorm(n, sd = 0.5)
y1 <- 1 + x1 %*% beta + rnorm(n)
bigData1 <- data.frame("resp" = y1, "pred" = x1)

# Data for logistic regression
x2 <- matrix(rnorm(n * p), nrow = n, ncol = p)
y2 <- rbinom(n = n, size = 1, prob = 1 / (1 + exp(-(1 + x2 %*% beta))))
bigData2 <- data.frame("resp" = y2, "pred" = x2)

# Sizes of objects
print(object.size(bigData1), units = "Mb")
{% endhighlight %}



{% highlight text %}
## 83.9 Mb
{% endhighlight %}



{% highlight r linenos %}
print(object.size(bigData2), units = "Mb")
{% endhighlight %}



{% highlight text %}
## 80.1 Mb
{% endhighlight %}



{% highlight r linenos %}
# Save files to disk to emulate the situation with big data
write.csv(x = bigData1, file = "bigData1.csv", row.names = FALSE)
write.csv(x = bigData2, file = "bigData2.csv", row.names = FALSE)

# Read files using ff
library(ffbase) # Imports ff
bigData1ff <- read.table.ffdf(file = "bigData1.csv", header = TRUE, sep = ",")
bigData2ff <- read.table.ffdf(file = "bigData2.csv", header = TRUE, sep = ",")

# Recall: the *.csv are not copied into RAM!
print(object.size(bigData1ff), units = "Kb")
{% endhighlight %}



{% highlight text %}
## 37.8 Kb
{% endhighlight %}



{% highlight r linenos %}
print(object.size(bigData2ff), units = "Kb")
{% endhighlight %}



{% highlight text %}
## 37.8 Kb
{% endhighlight %}



{% highlight r linenos %}
# Delete the csv files in disk
file.remove(c("bigData1.csv", "bigData2.csv"))
{% endhighlight %}



{% highlight text %}
## [1] TRUE TRUE
{% endhighlight %}



{% highlight r linenos %}
# Operations on ff objects "almost" as with regular data.frames
class(bigData1ff)
{% endhighlight %}



{% highlight text %}
## [1] "ffdf"
{% endhighlight %}



{% highlight r linenos %}
class(bigData1ff[, 1])
{% endhighlight %}



{% highlight text %}
## [1] "numeric"
{% endhighlight %}



{% highlight r linenos %}
bigData1ff[1:5, 1] <- rnorm(5)
# See ?ffdf for more allowed operations

# Filter of data frames
ffwhich(bigData1ff, bigData1ff$resp > 5)
{% endhighlight %}



{% highlight text %}
## ff (open) integer length=12943 (12943)
##     [1]     [2]     [3]     [4]     [5]     [6]     [7]     [8]         
##      32      86     341     377     437     440     688     747       : 
## [12936] [12937] [12938] [12939] [12940] [12941] [12942] [12943] 
##  999645  999720  999724  999780  999825  999833  999845  999885
{% endhighlight %}

### Regression using `biglm`

#### Linear models

Linear regression with big data is done iteratively, an approach that is possible thanks to the nice properties of the least squares solution (more details of this can be found [here](https://bookdown.org/egarpor/PM-UC3M/lm-iii-bigdata.html)). The [`biglm`](https://cran.r-project.org/web/packages/biglm/index.html) package employs an iterative approach based on the QR decomposition. The package accepts as data input:

- either a regular `data.frame` object
- or a `ffdf` object.

Let's see how `biglm` works for the first case. Then we will use `ffdf` for the case of generalized linear models.


{% highlight r linenos %}
# biglm has a very similar syntaxis to lm - but the formula interface does not
# work always as expected
library(biglm)
# biglm(formula = resp ~ ., data = bigData1) # Does not work
# biglm(formula = y ~ x) # Does not work
# biglm(formula = resp ~ pred.1 + pred.2, data = bigData1) # Does work, but 
# not very convenient for a large number of predictors
# Hack for automatic inclusion of all the predictors
f <- formula(paste("resp ~", paste(names(bigData1)[-1], collapse = " + ")))
biglmMod <- biglm(formula = f, data = bigData1)
 
# lm's call
lmMod <- lm(formula = resp ~ ., data = bigData1)

# The reduction in size of the resulting object is more than notable
print(object.size(biglmMod), units = "Kb")
{% endhighlight %}



{% highlight text %}
## 12.1 Kb
{% endhighlight %}



{% highlight r linenos %}
print(object.size(lmMod), units = "Mb")
{% endhighlight %}



{% highlight text %}
## 358.6 Mb
{% endhighlight %}



{% highlight r linenos %}
# Summaries
s1 <- summary(biglmMod)
s2 <- summary(lmMod)
s1
{% endhighlight %}



{% highlight text %}
## Large data regression model: biglm(formula = f, data = bigData1)
## Sample size =  1000000 
##                Coef    (95%     CI)     SE      p
## (Intercept)  1.0021  0.9939  1.0104 0.0041 0.0000
## pred.1      -0.9733 -1.0133 -0.9333 0.0200 0.0000
## pred.2      -0.2866 -0.2911 -0.2822 0.0022 0.0000
## pred.3      -0.0535 -0.0555 -0.0515 0.0010 0.0000
## pred.4      -0.0041 -0.0061 -0.0021 0.0010 0.0000
## pred.5      -0.0002 -0.0022  0.0018 0.0010 0.8373
## pred.6       0.0003 -0.0017  0.0023 0.0010 0.7771
## pred.7       0.0026  0.0006  0.0046 0.0010 0.0091
## pred.8       0.0521  0.0501  0.0541 0.0010 0.0000
## pred.9       0.2840  0.2800  0.2880 0.0020 0.0000
## pred.10      0.9867  0.9667  1.0067 0.0100 0.0000
{% endhighlight %}



{% highlight r linenos %}
s2
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = resp ~ ., data = bigData1)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.8798 -0.6735 -0.0013  0.6735  4.9060 
## 
## Coefficients:
##               Estimate Std. Error  t value Pr(>|t|)    
## (Intercept)  1.0021454  0.0041200  243.236  < 2e-16 ***
## pred.1      -0.9732675  0.0199989  -48.666  < 2e-16 ***
## pred.2      -0.2866314  0.0022354 -128.227  < 2e-16 ***
## pred.3      -0.0534834  0.0009997  -53.500  < 2e-16 ***
## pred.4      -0.0040772  0.0009984   -4.084 4.43e-05 ***
## pred.5      -0.0002051  0.0009990   -0.205  0.83731    
## pred.6       0.0002828  0.0009989    0.283  0.77706    
## pred.7       0.0026085  0.0009996    2.610  0.00907 ** 
## pred.8       0.0520744  0.0009994   52.105  < 2e-16 ***
## pred.9       0.2840358  0.0019992  142.076  < 2e-16 ***
## pred.10      0.9866851  0.0099876   98.791  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.9993 on 999989 degrees of freedom
## Multiple R-squared:  0.5777,	Adjusted R-squared:  0.5777 
## F-statistic: 1.368e+05 on 10 and 999989 DF,  p-value: < 2.2e-16
{% endhighlight %}



{% highlight r linenos %}
# The summary of a biglm object yields slightly different significances for the
# coefficients than for lm. The reason is that biglm employs N(0, 1) 
# approximations for the distributions of the t-tests instead of the exact 
# t distribution. Obviously, if n is large, the differences are inappreciable.

# Extract coefficients
coef(biglmMod)
{% endhighlight %}



{% highlight text %}
##   (Intercept)        pred.1        pred.2        pred.3        pred.4 
##  1.0021454430 -0.9732674585 -0.2866314070 -0.0534833941 -0.0040771777 
##        pred.5        pred.6        pred.7        pred.8        pred.9 
## -0.0002051218  0.0002828388  0.0026085425  0.0520743791  0.2840358104 
##       pred.10 
##  0.9866850849
{% endhighlight %}



{% highlight r linenos %}
# AIC and BIC
AIC(biglmMod, k = 2)
{% endhighlight %}



{% highlight text %}
## [1] 998685.1
{% endhighlight %}



{% highlight r linenos %}
AIC(biglmMod, k = log(n))
{% endhighlight %}



{% highlight text %}
## [1] 998815.1
{% endhighlight %}



{% highlight r linenos %}
# Prediction works as usual
predict(biglmMod, newdata = bigData1[1:5, ])
{% endhighlight %}



{% highlight text %}
##       [,1]
## 1 2.459134
## 2 2.797507
## 3 1.446906
## 4 1.601356
## 5 2.153812
{% endhighlight %}



{% highlight r linenos %}
# Must contain a column for the response
# predict(biglmMod, newdata = bigData2[1:5, -1]) # Error

# Update the model with more training data - this is key for chunking the data
update(biglmMod, moredata = bigData1[1:100, ])
{% endhighlight %}



{% highlight text %}
## Large data regression model: biglm(formula = f, data = bigData1)
## Sample size =  1000100
{% endhighlight %}



{% highlight r linenos %}
# Features not immediately available for biglm objects: stepwise selection by 
# stepAIC, residuals, variance of the error, model diagnostics, and vifs
{% endhighlight %}

Model selection of `biglm` models can be done with the [`leaps`](https://cran.r-project.org/web/packages/leaps/index.html) package. This is achieved by the `regsubsets` function, which returns the *best subset* of up to (by default) `nvmax = 8` predictors. The function requires the *full* `biglm` model to begin the "exhaustive" search, in which is crucial the linear structure of the estimator. 


{% highlight r linenos %}
# Model selection adapted to big data models
library(leaps)
reg <- regsubsets(biglmMod, nvmax = p, method = "exhaustive")
plot(reg) # Plot best model (top row) to worst model (bottom row)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/biglm-2-1.png)

{% highlight r linenos %}
# Summarize (otherwise regsubsets's outptut is hard to decypher)
subs <- summary(reg)
subs
{% endhighlight %}



{% highlight text %}
## Subset selection object
## 10 Variables  (and intercept)
##         Forced in Forced out
## pred.1      FALSE      FALSE
## pred.2      FALSE      FALSE
## pred.3      FALSE      FALSE
## pred.4      FALSE      FALSE
## pred.5      FALSE      FALSE
## pred.6      FALSE      FALSE
## pred.7      FALSE      FALSE
## pred.8      FALSE      FALSE
## pred.9      FALSE      FALSE
## pred.10     FALSE      FALSE
## 1 subsets of each size up to 9
## Selection Algorithm: exhaustive
##          pred.1 pred.2 pred.3 pred.4 pred.5 pred.6 pred.7 pred.8 pred.9
## 1  ( 1 ) " "    " "    " "    " "    " "    " "    " "    " "    " "   
## 2  ( 1 ) " "    " "    " "    " "    " "    " "    " "    " "    "*"   
## 3  ( 1 ) " "    "*"    " "    " "    " "    " "    " "    " "    "*"   
## 4  ( 1 ) " "    "*"    "*"    " "    " "    " "    " "    " "    "*"   
## 5  ( 1 ) " "    "*"    "*"    " "    " "    " "    " "    "*"    "*"   
## 6  ( 1 ) "*"    "*"    "*"    " "    " "    " "    " "    "*"    "*"   
## 7  ( 1 ) "*"    "*"    "*"    "*"    " "    " "    " "    "*"    "*"   
## 8  ( 1 ) "*"    "*"    "*"    "*"    " "    " "    "*"    "*"    "*"   
## 9  ( 1 ) "*"    "*"    "*"    "*"    " "    "*"    "*"    "*"    "*"   
##          pred.10
## 1  ( 1 ) "*"    
## 2  ( 1 ) "*"    
## 3  ( 1 ) "*"    
## 4  ( 1 ) "*"    
## 5  ( 1 ) "*"    
## 6  ( 1 ) "*"    
## 7  ( 1 ) "*"    
## 8  ( 1 ) "*"    
## 9  ( 1 ) "*"
{% endhighlight %}



{% highlight r linenos %}
# Lots of useful information
str(subs, 1)
{% endhighlight %}



{% highlight text %}
## List of 8
##  $ which : logi [1:9, 1:11] TRUE TRUE TRUE TRUE TRUE TRUE ...
##   ..- attr(*, "dimnames")=List of 2
##  $ rsq   : num [1:9] 0.428 0.567 0.574 0.576 0.577 ...
##  $ rss   : num [1:9] 1352680 1023080 1006623 1003763 1001051 ...
##  $ adjr2 : num [1:9] 0.428 0.567 0.574 0.576 0.577 ...
##  $ cp    : num [1:9] 354480 24444 7968 5106 2392 ...
##  $ bic   : num [1:9] -558604 -837860 -854062 -856894 -859585 ...
##  $ outmat: chr [1:9, 1:10] " " " " " " " " ...
##   ..- attr(*, "dimnames")=List of 2
##  $ obj   :List of 27
##   ..- attr(*, "class")= chr "regsubsets"
##  - attr(*, "class")= chr "summary.regsubsets"
{% endhighlight %}



{% highlight r linenos %}
# Get the model with lowest BIC
subs$which
{% endhighlight %}



{% highlight text %}
##   (Intercept) pred.1 pred.2 pred.3 pred.4 pred.5 pred.6 pred.7 pred.8
## 1        TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 2        TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 3        TRUE  FALSE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 4        TRUE  FALSE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE
## 5        TRUE  FALSE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE   TRUE
## 6        TRUE   TRUE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE   TRUE
## 7        TRUE   TRUE   TRUE   TRUE   TRUE  FALSE  FALSE  FALSE   TRUE
## 8        TRUE   TRUE   TRUE   TRUE   TRUE  FALSE  FALSE   TRUE   TRUE
## 9        TRUE   TRUE   TRUE   TRUE   TRUE  FALSE   TRUE   TRUE   TRUE
##   pred.9 pred.10
## 1  FALSE    TRUE
## 2   TRUE    TRUE
## 3   TRUE    TRUE
## 4   TRUE    TRUE
## 5   TRUE    TRUE
## 6   TRUE    TRUE
## 7   TRUE    TRUE
## 8   TRUE    TRUE
## 9   TRUE    TRUE
{% endhighlight %}



{% highlight r linenos %}
subs$bic
{% endhighlight %}



{% highlight text %}
## [1] -558603.7 -837859.9 -854062.3 -856893.8 -859585.3 -861936.5 -861939.3
## [8] -861932.3 -861918.6
{% endhighlight %}



{% highlight r linenos %}
subs$which[which.min(subs$bic), ]
{% endhighlight %}



{% highlight text %}
## (Intercept)      pred.1      pred.2      pred.3      pred.4      pred.5 
##        TRUE        TRUE        TRUE        TRUE        TRUE       FALSE 
##      pred.6      pred.7      pred.8      pred.9     pred.10 
##       FALSE       FALSE        TRUE        TRUE        TRUE
{% endhighlight %}



{% highlight r linenos %}
# It also works with ordinary linear models and it is much faster and 
# informative than stepAIC
reg <- regsubsets(resp ~ ., data = bigData1, nvmax = p, 
                  method = "backward")
subs$bic
{% endhighlight %}



{% highlight text %}
## [1] -558603.7 -837859.9 -854062.3 -856893.8 -859585.3 -861936.5 -861939.3
## [8] -861932.3 -861918.6
{% endhighlight %}



{% highlight r linenos %}
subs$which[which.min(subs$bic), ]
{% endhighlight %}



{% highlight text %}
## (Intercept)      pred.1      pred.2      pred.3      pred.4      pred.5 
##        TRUE        TRUE        TRUE        TRUE        TRUE       FALSE 
##      pred.6      pred.7      pred.8      pred.9     pred.10 
##       FALSE       FALSE        TRUE        TRUE        TRUE
{% endhighlight %}



{% highlight r linenos %}
# Compare it with stepAIC
library(MASS)
stepAIC(lm(resp ~ ., data = bigData1), trace = 0, 
        direction = "backward", k = log(n))
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = resp ~ pred.1 + pred.2 + pred.3 + pred.4 + pred.8 + 
##     pred.9 + pred.10, data = bigData1)
## 
## Coefficients:
## (Intercept)       pred.1       pred.2       pred.3       pred.4  
##    1.002141    -0.973201    -0.286626    -0.053487    -0.004074  
##      pred.8       pred.9      pred.10  
##    0.052076     0.284038     0.986651
{% endhighlight %}

Let's see an example on how to fit a linear model to a large dataset that does not fit in RAM. A possible approach is to split the dataset and perform updates of the model in chunks of reasonable size. The next code provides a template for such approach using `biglm` and `update`.


{% highlight r linenos %}
# Linear regression with N = 10^8 and p = 10
N <- 10^8
p <- 10
beta <- seq(-1, 1, length.out = p)^5

# Number of chunks for splitting the dataset
nChunks <- 1e3
nSmall <- N / nChunks

# Simulates reading the first chunk of data
set.seed(12345)
x <- matrix(rnorm(nSmall * p), nrow = nSmall, ncol = p)
x[, p] <- 2 * x[, 1] + rnorm(nSmall, sd = 0.1)
x[, p - 1] <- 2 - x[, 2] + rnorm(nSmall, sd = 0.5)
y <- 1 + x %*% beta + rnorm(nSmall)

# First fit
bigMod <- biglm(y ~ x, data = data.frame(y, x))

# Update fit
# pb <- txtProgressBar(style = 3)
for (i in 2:nChunks) {
  
  # Simulates reading the i-th chunk of data
  set.seed(12345 + i)
  x <- matrix(rnorm(nSmall * p), nrow = nSmall, ncol = p)
  x[, p] <- 2 * x[, 1] + rnorm(nSmall, sd = 0.1)
  x[, p - 1] <- 2 - x[, 2] + rnorm(nSmall, sd = 0.5)
  y <- 1 + x %*% beta + rnorm(nSmall)
  
  # Update the fit
  bigMod <- update(bigMod, moredata = data.frame(y, x))
  
  # Progress
  # setTxtProgressBar(pb = pb, value = i / nChunks)

}

# Final model
summary(bigMod)
{% endhighlight %}



{% highlight text %}
## Large data regression model: biglm(y ~ x, data = data.frame(y, x))
## Sample size =  100000000 
##                Coef    (95%     CI)    SE      p
## (Intercept)  1.0003  0.9995  1.0011 4e-04 0.0000
## x1          -1.0015 -1.0055 -0.9975 2e-03 0.0000
## x2          -0.2847 -0.2852 -0.2843 2e-04 0.0000
## x3          -0.0531 -0.0533 -0.0529 1e-04 0.0000
## x4          -0.0041 -0.0043 -0.0039 1e-04 0.0000
## x5           0.0002  0.0000  0.0004 1e-04 0.0760
## x6          -0.0001 -0.0003  0.0001 1e-04 0.2201
## x7           0.0041  0.0039  0.0043 1e-04 0.0000
## x8           0.0529  0.0527  0.0531 1e-04 0.0000
## x9           0.2844  0.2840  0.2848 2e-04 0.0000
## x10          1.0007  0.9987  1.0027 1e-03 0.0000
{% endhighlight %}



{% highlight r linenos %}
print(object.size(bigMod), units = "Kb")
{% endhighlight %}



{% highlight text %}
## 7.1 Kb
{% endhighlight %}

#### Generalized linear models

Fitting a generalized linear model involves fitting a series of linear models using the the IRLS algorithm. The nonlinearities introduced through this process imply that (more details are available [here](https://bookdown.org/egarpor/PM-UC3M/glm-bigdata.html)):

1. *Updating* the model with a new chunk implies re-fitting with *all* the data.
2. The IRLS algorithm requires *reading the data as many times as iterations*.

This means that `biglm`'s fitting function for generalized linear models, `bigglm`, needs to have access to the *full data* while performing the fitting. So the only possibility, if the data does not fit into RAM, is to go with an `ffbase` approach.

Let's see an example for logistic regression.


{% highlight r linenos %}
# Logistic regression
# Same comments for the formula framework - this is the hack for automatic
# inclusion of all the predictors
f <- formula(paste("resp ~", paste(names(bigData2ff)[-1], collapse = " + ")))
bigglmMod <- bigglm.ffdf(formula = f, data = bigData2ff, family = binomial())

# glm's call
glmMod <- glm(formula = resp ~ ., data = bigData2, family = binomial())

# Compare sizes
print(object.size(bigglmMod), units = "Kb")
{% endhighlight %}



{% highlight text %}
## 173.1 Kb
{% endhighlight %}



{% highlight r linenos %}
print(object.size(glmMod), units = "Mb")
{% endhighlight %}



{% highlight text %}
## 679.2 Mb
{% endhighlight %}



{% highlight r linenos %}
# Summaries
s1 <- summary(bigglmMod)
s2 <- summary(glmMod)
s1
{% endhighlight %}



{% highlight text %}
## Large data regression model: bigglm(formula = f, data = bigData2ff, family = binomial())
## Sample size =  1e+06 
##                Coef    (95%     CI)     SE      p
## (Intercept)  0.9960  0.9906  1.0015 0.0027 0.0000
## pred.1      -0.9970 -1.0028 -0.9911 0.0029 0.0000
## pred.2      -0.2839 -0.2890 -0.2789 0.0025 0.0000
## pred.3      -0.0533 -0.0583 -0.0483 0.0025 0.0000
## pred.4      -0.0015 -0.0065  0.0035 0.0025 0.5466
## pred.5      -0.0020 -0.0070  0.0030 0.0025 0.4201
## pred.6       0.0029 -0.0021  0.0079 0.0025 0.2465
## pred.7       0.0035 -0.0015  0.0085 0.0025 0.1584
## pred.8       0.0529  0.0479  0.0579 0.0025 0.0000
## pred.9       0.2821  0.2770  0.2871 0.0025 0.0000
## pred.10      0.9962  0.9903  1.0021 0.0029 0.0000
{% endhighlight %}



{% highlight r linenos %}
s2
{% endhighlight %}



{% highlight text %}
## 
## Call:
## glm(formula = resp ~ ., family = binomial(), data = bigData2)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.5073  -0.8193   0.4306   0.7691   3.0466  
## 
## Coefficients:
##              Estimate Std. Error  z value Pr(>|z|)    
## (Intercept)  0.996049   0.002707  367.986   <2e-16 ***
## pred.1      -0.996951   0.002931 -340.134   <2e-16 ***
## pred.2      -0.283919   0.002535 -112.021   <2e-16 ***
## pred.3      -0.053271   0.002496  -21.340   <2e-16 ***
## pred.4      -0.001504   0.002494   -0.603    0.547    
## pred.5      -0.002011   0.002494   -0.806    0.420    
## pred.6       0.002889   0.002493    1.159    0.246    
## pred.7       0.003519   0.002495    1.411    0.158    
## pred.8       0.052924   0.002495   21.216   <2e-16 ***
## pred.9       0.282086   0.002531  111.466   <2e-16 ***
## pred.10      0.996187   0.002933  339.625   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1265999  on 999999  degrees of freedom
## Residual deviance:  974224  on 999989  degrees of freedom
## AIC: 974246
## 
## Number of Fisher Scoring iterations: 5
{% endhighlight %}



{% highlight r linenos %}
# Further information
s1$mat # Coefficients and their inferences
{% endhighlight %}



{% highlight text %}
##                     Coef         (95%          CI)          SE
## (Intercept)  0.996048826  0.990635314  1.001462338 0.002706756
## pred.1      -0.996951096 -1.002813204 -0.991088988 0.002931054
## pred.2      -0.283919321 -0.288988340 -0.278850302 0.002534510
## pred.3      -0.053270674 -0.058263245 -0.048278103 0.002496286
## pred.4      -0.001503512 -0.006491230  0.003484206 0.002493859
## pred.5      -0.002010510 -0.006997800  0.002976780 0.002493645
## pred.6       0.002888832 -0.002096389  0.007874052 0.002492610
## pred.7       0.003518572 -0.001470509  0.008507653 0.002494540
## pred.8       0.052924447  0.047935407  0.057913487 0.002494520
## pred.9       0.282086252  0.277024854  0.287147649 0.002530699
## pred.10      0.996187328  0.990320936  1.002053719 0.002933196
##                         p
## (Intercept)  0.000000e+00
## pred.1       0.000000e+00
## pred.2       0.000000e+00
## pred.3      4.831928e-101
## pred.4       5.465847e-01
## pred.5       4.200968e-01
## pred.6       2.464731e-01
## pred.7       1.583894e-01
## pred.8      6.755386e-100
## pred.9       0.000000e+00
## pred.10      0.000000e+00
{% endhighlight %}



{% highlight r linenos %}
s1$rsq # R^2
{% endhighlight %}



{% highlight text %}
## [1] 0.1819429
{% endhighlight %}



{% highlight r linenos %}
s1$nullrss # Null deviance
{% endhighlight %}



{% highlight text %}
## [1] 1190900
{% endhighlight %}



{% highlight r linenos %}
# Extract coefficients
coef(bigglmMod)
{% endhighlight %}



{% highlight text %}
##  (Intercept)       pred.1       pred.2       pred.3       pred.4 
##  0.996048826 -0.996951096 -0.283919321 -0.053270674 -0.001503512 
##       pred.5       pred.6       pred.7       pred.8       pred.9 
## -0.002010510  0.002888832  0.003518572  0.052924447  0.282086252 
##      pred.10 
##  0.996187328
{% endhighlight %}



{% highlight r linenos %}
# AIC and BIC
AIC(bigglmMod, k = 2)
{% endhighlight %}



{% highlight text %}
## [1] 974246.3
{% endhighlight %}



{% highlight r linenos %}
AIC(bigglmMod, k = log(n))
{% endhighlight %}



{% highlight text %}
## [1] 974376.2
{% endhighlight %}



{% highlight r linenos %}
# Prediction works as usual
predict(bigglmMod, newdata = bigData2[1:5, ], type = "response")
{% endhighlight %}



{% highlight text %}
##        [,1]
## 1 0.4330916
## 2 0.9237983
## 3 0.2420483
## 4 0.9619891
## 5 0.5443102
{% endhighlight %}



{% highlight r linenos %}
# predict(bigglmMod, newdata = bigData2[1:5, -1]) # Error

# Update the model with training data
update(bigglmMod, moredata = bigData2[1:100, ])
{% endhighlight %}



{% highlight text %}
## Large data regression model: bigglm(formula = f, data = bigData2ff, family = binomial())
## Sample size =  1000100
{% endhighlight %}

Note that this is also a perfectly valid approach for linear models, we just need to specify `family = gaussian()` in the call to `bigglm.ffdf`.


{% highlight r linenos %}
f <- formula(paste("resp ~", paste(names(bigData1ff)[-1], collapse = " + ")))
bigglmMod <- bigglm.ffdf(formula = f, data = bigData1ff, family = gaussian())

# Comparison with the first lm
summary(bigglmMod)
{% endhighlight %}



{% highlight text %}
## Large data regression model: bigglm(formula = f, data = bigData1ff, family = gaussian())
## Sample size =  1e+06 
##                Coef    (95%     CI)     SE      p
## (Intercept)  1.0021  0.9939  1.0104 0.0041 0.0000
## pred.1      -0.9732 -1.0132 -0.9332 0.0200 0.0000
## pred.2      -0.2866 -0.2911 -0.2821 0.0022 0.0000
## pred.3      -0.0535 -0.0555 -0.0515 0.0010 0.0000
## pred.4      -0.0041 -0.0061 -0.0021 0.0010 0.0000
## pred.5      -0.0002 -0.0022  0.0018 0.0010 0.8398
## pred.6       0.0003 -0.0017  0.0023 0.0010 0.7740
## pred.7       0.0026  0.0006  0.0046 0.0010 0.0090
## pred.8       0.0521  0.0501  0.0541 0.0010 0.0000
## pred.9       0.2840  0.2801  0.2880 0.0020 0.0000
## pred.10      0.9867  0.9667  1.0066 0.0100 0.0000
{% endhighlight %}



{% highlight r linenos %}
summary(lmMod)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = resp ~ ., data = bigData1)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.8798 -0.6735 -0.0013  0.6735  4.9060 
## 
## Coefficients:
##               Estimate Std. Error  t value Pr(>|t|)    
## (Intercept)  1.0021454  0.0041200  243.236  < 2e-16 ***
## pred.1      -0.9732675  0.0199989  -48.666  < 2e-16 ***
## pred.2      -0.2866314  0.0022354 -128.227  < 2e-16 ***
## pred.3      -0.0534834  0.0009997  -53.500  < 2e-16 ***
## pred.4      -0.0040772  0.0009984   -4.084 4.43e-05 ***
## pred.5      -0.0002051  0.0009990   -0.205  0.83731    
## pred.6       0.0002828  0.0009989    0.283  0.77706    
## pred.7       0.0026085  0.0009996    2.610  0.00907 ** 
## pred.8       0.0520744  0.0009994   52.105  < 2e-16 ***
## pred.9       0.2840358  0.0019992  142.076  < 2e-16 ***
## pred.10      0.9866851  0.0099876   98.791  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.9993 on 999989 degrees of freedom
## Multiple R-squared:  0.5777,	Adjusted R-squared:  0.5777 
## F-statistic: 1.368e+05 on 10 and 999989 DF,  p-value: < 2.2e-16
{% endhighlight %}

Model selection of `bigglm` is not so straightforward. The trick that `regsubsets` employs for simplifying the model search in linear models does not apply for generalized linear models. However, there is a hack. We can do best subset selection in the *linear model associated to the last iteration of the IRLS algorithm* and then refine the search by computing the exact BIC/AIC from a set of candidate models. If we do so, we translate the model selection problem back to the linear case, plus the extra overhead of fitting several generalized linear models. Keep in mind that, albeit useful, this approach is an *approximation*.


{% highlight r linenos %}
# Model selection adapted to big data generalized linear models
library(leaps)
f <- formula(paste("resp ~", paste(names(bigData2ff)[-1], collapse = " + ")))
bigglmMod <- bigglm.ffdf(formula = f, data = bigData2ff, family = binomial())
reg <- regsubsets(bigglmMod, nvmax = p + 1, method = "exhaustive")
# This takes the QR decomposition, which encodes the linear model associated to
# the last iteration of the IRLS algorithm. However, the reported BICs are *not*
# the true BICs of the generalized linear models, but a sufficient 
# approximation to obtain a list of candidate models in a fast way

# Get the model with lowest BIC
plot(reg)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/bigglm-3-1.png)

{% highlight r linenos %}
subs <- summary(reg)
subs$which
{% endhighlight %}



{% highlight text %}
##    (Intercept) pred.1 pred.2 pred.3 pred.4 pred.5 pred.6 pred.7 pred.8
## 1         TRUE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 2         TRUE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 3         TRUE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 4         TRUE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
## 5         TRUE   TRUE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE  FALSE
## 6         TRUE   TRUE   TRUE   TRUE  FALSE  FALSE  FALSE  FALSE   TRUE
## 7         TRUE   TRUE   TRUE   TRUE  FALSE  FALSE  FALSE   TRUE   TRUE
## 8         TRUE   TRUE   TRUE   TRUE  FALSE  FALSE   TRUE   TRUE   TRUE
## 9         TRUE   TRUE   TRUE   TRUE  FALSE   TRUE   TRUE   TRUE   TRUE
## 10        TRUE   TRUE   TRUE   TRUE   TRUE   TRUE   TRUE   TRUE   TRUE
##    pred.9 pred.10
## 1   FALSE   FALSE
## 2   FALSE    TRUE
## 3   FALSE    TRUE
## 4    TRUE    TRUE
## 5    TRUE    TRUE
## 6    TRUE    TRUE
## 7    TRUE    TRUE
## 8    TRUE    TRUE
## 9    TRUE    TRUE
## 10   TRUE    TRUE
{% endhighlight %}



{% highlight r linenos %}
subs$bic
{% endhighlight %}



{% highlight text %}
##  [1]  -52129.65 -148334.01 -159890.96 -172139.53 -172579.77 -173015.19
##  [7] -173003.36 -172990.89 -172977.72 -172964.27
{% endhighlight %}



{% highlight r linenos %}
subs$which[which.min(subs$bic), ]
{% endhighlight %}



{% highlight text %}
## (Intercept)      pred.1      pred.2      pred.3      pred.4      pred.5 
##        TRUE        TRUE        TRUE        TRUE       FALSE       FALSE 
##      pred.6      pred.7      pred.8      pred.9     pred.10 
##       FALSE       FALSE        TRUE        TRUE        TRUE
{% endhighlight %}



{% highlight r linenos %}
# Let's compute the true BICs for the p models. This implies fitting p bigglm's
bestModels <- list()
for (i in 1:nrow(subs$which)) {
  f <- formula(paste("resp ~", paste(names(which(subs$which[i, -1])), 
                                     collapse = " + ")))
  bestModels[[i]] <- bigglm.ffdf(formula = f, data = bigData2ff, 
                                 family = binomial(), maxit = 20) 
}

# The approximate BICs and the true BICs are very similar (in this example)
exactBICs <- sapply(bestModels, AIC, k = log(n))
plot(subs$bic, exactBICs, type = "o", xlab = "Exact", ylab = "Approximate")
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/bigglm-3-2.png)

{% highlight r linenos %}
cor(subs$bic, exactBICs, method = "pearson") # Correlation
{% endhighlight %}



{% highlight text %}
## [1] 0.9985734
{% endhighlight %}



{% highlight r linenos %}
# Both give the same model selection and same order
subs$which[which.min(subs$bic), ] # Approximate
{% endhighlight %}



{% highlight text %}
## (Intercept)      pred.1      pred.2      pred.3      pred.4      pred.5 
##        TRUE        TRUE        TRUE        TRUE       FALSE       FALSE 
##      pred.6      pred.7      pred.8      pred.9     pred.10 
##       FALSE       FALSE        TRUE        TRUE        TRUE
{% endhighlight %}



{% highlight r linenos %}
subs$which[which.min(exactBICs), ] # Exact
{% endhighlight %}



{% highlight text %}
## (Intercept)      pred.1      pred.2      pred.3      pred.4      pred.5 
##        TRUE        TRUE        TRUE        TRUE       FALSE       FALSE 
##      pred.6      pred.7      pred.8      pred.9     pred.10 
##       FALSE       FALSE        TRUE        TRUE        TRUE
{% endhighlight %}



{% highlight r linenos %}
cor(subs$bic, exactBICs, method = "spearman") # Order correlation
{% endhighlight %}



{% highlight text %}
## [1] 1
{% endhighlight %}

## ASCII fun in `R`

### Text-based graphs with `txtplot`

When evaluating `R` in a terminal with no possible graphical outputs (e.g. in a supercomputing cluster), it may be of usefulness to, at least, visualize some simple plots in a rudimentary way. This is what the [`txtplot`](https://cran.r-project.org/web/packages/txtplot/index.html) and the [`NostalgiR`](https://cran.r-project.org/web/packages/NostalgiR/index.html) package do, by means of ASCII graphics that are equivalent to some `R` functions.

| `R` graph | ASCII analogue |
|:--------------|:-------------------|
| `plot` | `txtplot` |
| `boxplot` | `txtboxplot` |
| `barplot(table())` | `txtbarchart` |
| `curve` | `txtcurve` |
| `acf` | `txtacf` |
| `plot(density())` | `nos.density` |
| `hist` | `nos.hist` |
| `plot(ecdf())` | `nos.ecdf` |
| `qqnorm(); qqline()` | `nos.qqnorm` |
| `qqplot` | `nos.qqplot` |
| `contour` | `nos.contour` |
| `image` | `nos.image` |

Let's see some examples.


{% highlight r linenos %}
library(txtplot) # txt* functions

# Generate common data
x <- rnorm(100)
y <- 1 + x + rnorm(100, sd = 1)
let <- as.factor(sample(letters, size = 1000, replace = TRUE))

# txtplot
plot(x, y)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-1-1.png)

{% highlight r linenos %}
txtplot(x, y)
{% endhighlight %}



{% highlight text %}
##    +-----+---------+--------+---------+---------+---------++
##    |                                               *       |
##  4 +                                *                   *  +
##    |                            * * *                      |
##    |                          *    *    *  *               |
##    |                             * * *  *             *    |
##  2 +                  *   **** *** *    *  *      *        +
##    |       *          *  * *  * **   **  *                 |
##    |             * *  ** *  ***       *            *       |
##  0 +      ** * *   **** * ***  *      *                    +
##    |        * **   *  * ** *** * *         *               |
##    |  *                                                    |
##    |  *    *    **                                         |
## -2 +-----+---------+--------+---------+---------+---------++
##         -2        -1        0         1         2         3
{% endhighlight %}



{% highlight r linenos %}
# txtboxplot
boxplot(x, horizontal = TRUE)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-1-2.png)

{% highlight r linenos %}
txtboxplot(x)
{% endhighlight %}



{% highlight text %}
##       -2         -1         0         1          2          
##  |-----+----------+---------+---------+----------+---------|
##                      +------+------+                        
##     -----------------|      |      |--------------------    
##                      +------+------+
{% endhighlight %}



{% highlight r linenos %}
# txtbarchart
barplot(table(let))
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-1-3.png)

{% highlight r linenos %}
txtbarchart(x = let)
{% endhighlight %}



{% highlight text %}
##   ++---------+---------+----------+---------+---------+----+
## 5 +          *                                             +
##   |          * *                      *       *       *    |
## 4 +  * *   * * * * *   *       *      *       *       *    +
##   |  * * * * * * * *   * * *   *  *   * * * * * *   * * *  |
## 3 +  * * * * * * * *   * * *   *  * * * * * * * * * * * *  +
##   |  * * * * * * * * * * * * * *  * * * * * * * * * * * *  |
## 2 +  * * * * * * * * * * * * * *  * * * * * * * * * * * *  +
##   |  * * * * * * * * * * * * * *  * * * * * * * * * * * *  |
## 1 +  * * * * * * * * * * * * * *  * * * * * * * * * * * *  +
##   |  * * * * * * * * * * * * * *  * * * * * * * * * * * *  |
## 0 +  * * * * * * * * * * * * * *  * * * * * * * * * * * *  +
##   ++---------+---------+----------+---------+---------+----+
##    0         5        10         15        20        25     
## Legend: 
## 1=a, 2=b, 3=c, 4=d, 5=e, 6=f, 7=g, 8=h, 9=i, 10=j, 11=k, 12=
## l, 13=m, 14=n, 15=o, 16=p, 17=q, 18=r, 19=s, 20=t, 21=u, 22=
## v, 23=w, 24=x, 25=y, 26=z
{% endhighlight %}



{% highlight r linenos %}
# txtcurve
curve(expr = sin(x), from = 0, to = 2 * pi)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-1-4.png)

{% highlight r linenos %}
txtcurve(expr = sin(x), from = 0, to = 2 * pi)
{% endhighlight %}



{% highlight text %}
##      +-+-------+-------+-------+-------+------+-------+----+
##    1 +          *********                                  +
##      |       ***        ***                                |
##      |      **             **                              |
##  0.5 +    **                **                             +
##      |   **                  **                            |
##      |  *                      *                           |
##    0 + *                        **                     **  +
##      |                           **                   **   |
## -0.5 +                             **                *     +
##      |                              **             **      |
##      |                                ***        ***       |
##   -1 +                                  *********          +
##      +-+-------+-------+-------+-------+------+-------+----+
##        0       1       2       3       4      5       6
{% endhighlight %}



{% highlight r linenos %}
# txtacf
acf(x)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-1-5.png)

{% highlight r linenos %}
txtacf(x)
{% endhighlight %}



{% highlight text %}
##      +-+------------+-----------+-----------+-----------+--+
##    1 + *                                                   +
##      | *                                                   |
##  0.8 + *                                                   +
##      | *                                                   |
##  0.6 + *                                                   +
##      | *                                                   |
##  0.4 + *                                                   +
##      | *                                                   |
##  0.2 + *                 * *                               +
##    0 + *  * *  * *  * *  * * *  * *  * *  * *  * *  * * *  +
##      |    * *  * *    *         *    *              * *    |
## -0.2 +    *    *      *         *                     *    +
##      +-+------------+-----------+-----------+-----------+--+
##        0            5          10          15          20
{% endhighlight %}


{% highlight r linenos %}
library(NostalgiR) # nos.* functions

# Mexican hat
xx <- seq(-10, 10, l = 50)
yy <- xx
f <- function(x, y) {r <- sqrt(x^2 + y^2); 10 * sin(r)/r}
zz <- outer(xx, yy, f)

# nos.density
plot(density(x))
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-1.png)

{% highlight r linenos %}
nos.density(x)
{% endhighlight %}



{% highlight text %}
##       +-----------+------------+------------+------------+-+
##   0.4 +                      ~~~~~                         +
##       |                     ~~   ~~                        |
##       |                    ~~     ~~                       |
## D 0.3 +                   ~~       ~~                      +
## e     |                  ~~         ~~                     |
## n     |                 ~~           ~~                    |
## s 0.2 +               ~~~             ~~                   +
## i     |             ~~~                ~~                  |
## t     |            ~~                   ~                  |
## y 0.1 +          ~~~                     ~~                +
##       |        ~~~                        ~~~~~~~~         |
##     0 + ~~~~~~~~  oooooooooooooooooooooooo   oo o~~~~~~~~  +
##       +-----------+------------+------------+------------+-+
##                  -2            0            2            4
{% endhighlight %}



{% highlight r linenos %}
# nos.hist
hist(x)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-2.png)

{% highlight r linenos %}
nos.hist(x)
{% endhighlight %}



{% highlight text %}
##      +----+---------+--------+---------+---------+---------+
##      |                          o                          |
##   20 +                          o                          +
## F    |                     o    o                          |
## r    |                     o    o                          |
## e 15 +                o    o    o    o                     +
## q    |                o    o    o    o                     |
## u 10 +                o    o    o    o                     +
## e    |                o    o    o    o                     |
## n    |      o    o    o    o    o    o    o                |
## c  5 +      o    o    o    o    o    o    o                +
## y    | o    o    o    o    o    o    o    o    o    o   o  |
##    0 + o    o    o    o    o    o    o    o    o    o   o  +
##      +----+---------+--------+---------+---------+---------+
##          -2        -1        0         1         2         3
{% endhighlight %}



{% highlight r linenos %}
# nos.ecdf
plot(ecdf(x))
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-3.png)

{% highlight r linenos %}
nos.ecdf(x)
{% endhighlight %}



{% highlight text %}
##       +----+---------+--------+--------+---------+--------++
##     1 +                                     o~~~~~ooo~o~o  +
##       |                                oooo~~              |
##   0.8 +                             oooo                   +
##       |                          oooo                      |
## E 0.6 +                         oo                         +
## C     |                       ooo                          |
## D     |                      oo                            |
## F 0.4 +                    ooo                             +
##       |                 ooo~                               |
##   0.2 +              oooo                                  +
##       |         oooooo                                     |
##       | o~~~~ooo~                                          |
##     0 +----+---------+--------+--------+---------+--------++
##           -2        -1        0        1         2        3
{% endhighlight %}



{% highlight r linenos %}
# nos.qqnorm
qqnorm(x); qqline(x)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-4.png)

{% highlight r linenos %}
nos.qqnorm(x)
{% endhighlight %}



{% highlight text %}
##    3 +-------+--------+--------+--------+--------+---------+
##      |                                             o ~~o~  |
## S  2 +                                         ooo~~~      +
## a    |                                      ooo~~          |
## m  1 +                                  ~oooo              +
## p    |                              ~ooooo                 |
## l    |                          ooooo                      |
## e  0 +                    ooooooo                          +
##      |                 oooo~                               |
## Q -1 +             ~ooo~                                   +
## s    |       oo~oooo                                       |
##   -2 + o   o~~~                                            +
##      +-------+--------+--------+--------+--------+---------+
##             -2       -1        0        1        2         3
##                          Theoretical Qs
{% endhighlight %}



{% highlight r linenos %}
# nos.qqplot
qqplot(x, y)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-5.png)

{% highlight r linenos %}
nos.qqplot(x, y)
{% endhighlight %}



{% highlight text %}
##    +-----+---------+--------+---------+---------+---------++
##    |                                                    o  |
##  4 +                                               o  o    +
##    |                                       o      o        |
##    |                                  o oo          ~~~~~  |
##  2 +                                ooo        ~~~~~~      +
##    |                           oooooo    ~~~~~~~           |
##    |                        oooo   ~~~~~~~                 |
##    |                  ooooooo~~~~~~~                       |
##  0 +             o oooo~~~~~~~                             +
##    |        ooooo~~~~~~~                                   |
##    |  o   oo~~~~~~                                         |
## -2 +  o~~~~~                                               +
##    +-----+---------+--------+---------+---------+---------++
##         -2        -1        0         1         2         3
{% endhighlight %}



{% highlight r linenos %}
# nos.contour
contour(xx, yy, zz)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-6.png)

{% highlight r linenos %}
nos.contour(data = zz, xmin = min(xx), xmax = max(xx), 
            ymin = min(yy), ymax = max(yy))
{% endhighlight %}



{% highlight text %}
##     +-+------------+-----------+------------+-----------+--+
##  10 +       33  22   22222 3333333333 22222  222  33       +
##     |   33332222222233333444444444444443333322222222333    |
##     | 333222 222333444444              444444333222 22233  |
##     |  222222333444    444444444444444444    444333222222  |
##   5 + 2 22233444   44443333222222222233334444   4443322 2  +
##     |   2 3344   444332 1111111111111111 233444   4433 2   |
##     | 22 3 44   44332111112345555554321111123344   44 3 2  |
##     |   3 44   4332 111134555      555431111 2334   4433   |
##     |   3 4   4 32 111 245            542 11  2344   4 3   |
##   0 +   3 4   4 32 111 245            542 11  2344   4 3   +
##     |   3 44   4332 111134555      555431111 2334   4433   |
##     | 22 3 44   43322111112345555554321111122344   44 3 2  |
##     |  2233344   444332111111111111111111233444   4433322  |
##  -5 + 2 22233444   44443332222111122223334444   4443322 2  +
##     |  222222333444    444444444444444444    444333222222  |
##     | 333222 222333444444              444444333222 22233  |
##     |   3333222 22223333344444444444444333332222 222333    |
## -10 +       33 222   22222 3333333333 22222  2222 33       +
##     +-+------------+-----------+------------+-----------+--+
##      -10          -5           0            5          10   
## Legend: 1 ~ -2.02; 2 ~ -0.769; 3 ~ -0.082; 4 ~ 0.795; 5 ~ 1.74
{% endhighlight %}



{% highlight r linenos %}
# nos.image
image(zz)
{% endhighlight %}

![center](/figure/source/2018-05-10-misc-R-function/ascii-2-7.png)

{% highlight r linenos %}
nos.image(data = zz, xmin = min(xx), xmax = max(xx), 
          ymin = min(yy), ymax = max(yy))
{% endhighlight %}



{% highlight text %}
##     +-+------------+-----------+------------+-----------+--+
##  10 + o oooo........................................ooooo  +
##     | o oo....................oooo....................ooo  |
##     | . .............oooooooooooooooooooooo..............  |
##     | . .........oooooooooooooooooooooooooooooo..........  |
##   5 + . ......oooooooooo................oooooooooo.......  +
##     | . ....oooooooo........................oooooooo.....  |
##     | . ...oooooooo..........................oooooooo....  |
##     | . ..ooooooo..........oooxxxxooo..........ooooooo...  |
##     | . ..oooooo.........ooxXX####XXxoo.........oooooo...  |
##   0 + . .ooooooo........ooxXX######XXxoo........ooooooo..  +
##     | . ..ooooooo........ooxxXXXXXXxxoo........ooooooo...  |
##     | . ..oooooooo..........oooooooo..........oooooooo...  |
##     | . ...oooooooo..........................oooooooo....  |
##  -5 + . .....oooooooo......................oooooooo......  +
##     | . .......ooooooooooo............ooooooooooo........  |
##     | . ..........oooooooooooooooooooooooooooo...........  |
##     | o ...............oooooooooooooooooo...............o  |
## -10 + o ooo..........................................oooo  +
##     +-+------------+-----------+------------+-----------+--+
##      -10          -5           0            5          10   
## Legend: 
## . ~ (-2.17,0.235); o ~ (0.235,2.64); x ~ (2.64,5.05); X ~ (5
## .05,7.45); # ~ (7.45,9.86)
{% endhighlight %}

### Cute animals with `cowsay`

[`cowsay`](https://cran.r-project.org/web/packages/cowsay/index.html) is a package for printing messages with ASCII animals. Although it has little practical use, it is way fun! There is only one function,`say`, that produces an animal with a speech bubble.


{% highlight r linenos %}
library(cowsay)

# Random fortunes
say("fortune", by = "random")
{% endhighlight %}



{% highlight text %}
## 
##  -------------- 
## I was actually reading it with some curiosity as to how they managed to find 5 locations that were close to everyone on R-help...
##  Peter Dalgaard
##  after XL Solutions announced courses 'R/Splus Programming Techniques, @ 5 locations near you!'
##  R-help
##  April 2004 
##  --------------
##     \
##       \
##          /\ /\
##          (O o)
##         =(:^:)=
##            U      [nosig]
## 
{% endhighlight %}



{% highlight r linenos %}

# All animals
# sapply(names(animals), function(x) say(x, by = x))

# How to annoy the users of your package
say(what = "It looks like you\'re writing a letter!", 
    by = "clippy", type = "warning")
{% endhighlight %}



{% highlight text %}
## Warning in say(what = "It looks like you're writing a letter!", by = "clippy", : 
## 
##  ----- 
## It looks like you're writing a letter! 
##  ------ 
##     \   
##      \
##    __
##    / \
##    | |
##    @ @
##   || ||
##   || ||
##   |\_/|
##   \___/ GB
{% endhighlight %}



{% highlight r linenos %}

# A message from Yoda
say("Contribute to the Coding Club UC3M you must!", by = "yoda")
{% endhighlight %}



{% highlight text %}
## 
## 
## 
##  ----- 
## Contribute to the Coding Club UC3M you must! 
##  ------ 
##     \   
##      \
##                    ____
##                 _.' :  `._
##             .-.'`.  ;   .'`.-.
##    __      / : ___\ ;  /___ ; \      __
##   ,'_ ""--.:__;".-.";: :".-.":__;.--"" _`,
##   :' `.t""--.. '<@.`;_  ',@>` ..--""j.' `;
##        `:-.._J '-.-'L__ `-- ' L_..-;'
##           "-.__ ;  .-"  "-.  : __.-"
##              L ' /.------.\ ' J
##              "-.   "--"   .-"
##              __.l"-:_JL_;-";.__
##          .-j/'.;  ;""""  / .'\"-.
##          .' /:`. "-.:     .-" .';  `.
##       .-"  / ;  "-. "-..-" .-"  :    "-.
##   .+"-.  : :      "-.__.-"      ;-._   \
##   ; \  `.; ;                    : : "+. ;
##   :  ;   ; ;                    : ;  : \:
##   ;  :   ; :                    ;:   ;  :
##   : \  ;  :  ;                  : ;  /  ::
##   ;  ; :   ; :                  ;   :   ;:
##   :  :  ;  :  ;                : :  ;  : ;
##   ;\    :   ; :                ; ;     ; ;
##   : `."-;   :  ;              :  ;    /  ;
##  ;    -:   ; :              ;  : .-"   :
##   :\     \  :  ;            : \.-"      :
##   ;`.    \  ; :            ;.'_..--  / ;
##   :  "-.  "-:  ;          :/."      .'  :
##    \         \ :          ;/  __        :
##     \       .-`.\        /t-""  ":-+.   :
##      `.  .-"    `l    __/ /`. :  ; ; \  ;
##        \   .-" .-"-.-"  .' .'j \  /   ;/
##         \ / .-"   /.     .'.' ;_:'    ;
##   :-""-.`./-.'     /    `.___.'
##                \ `t  ._  /  bug
##                 "-.t-._:'
## 
{% endhighlight %}

-->
