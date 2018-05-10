# ---
# "Useful one-function R packages, big data solutions, and a message from Yoda"
# Eduardo García-Portugués
# ---

### Abstract

# As the title reads, in this heterogeneous session we will see three topics of 
# different interest. The first is a collection of three simple and useful 
# one-function R packages that I use regularly in my coding workflow. The 
# second collects some approaches to handling and performing linear regression 
# with big data. The third brings in the freaky component: it presents tools to 
# display graphical information in plain ASCII, from bivariate contours to 
# messages from Yoda!

### Required packages

install.packages(c("viridis", "microbenchmark", "multcomp", "manipulate", 
                   "ffbase", "biglm", "leaps", "txtplot", "NostalgiR",
                   "cowsay"), 
                 dependencies = TRUE)

# 1. Some simple and useful R packages

## 1.2 Color palettes with viridis

### Chunk 1

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


### Chunk 2

library(viridisLite)
# Color palettes comparison
par(mfrow = c(2, 3))
res <- sapply(c("viridis", "magma", "inferno", "plasma", "cividis"), 
              testPalette)

### Chunk 3

# Reverse palette
par(mfrow = c(1, 2))
testPalette("viridis", direction = 1)
testPalette("viridis", direction = -1)

# Truncate color range
par(mfrow = c(1, 2))
testPalette("viridis", begin = 0, end = 1)
testPalette("viridis", begin = 0.25, end = 0.75)

# Asjust transparency
par(mfrow = c(1, 2))
testPalette("viridis", alpha = 1)
testPalette("viridis", alpha = 0.5)

### Chunk 4

library(viridis)
library(ggplot2)

# Using scale_color_viridis
ggplot(mtcars, aes(wt, mpg)) + 
  geom_point(size = 4, aes(color = factor(cyl))) +
  scale_color_viridis(discrete = TRUE) +
  theme_bw()

# Using scale_fill_viridis
dat <- data.frame(x = rnorm(1e4), y = rnorm(1e4))
ggplot(dat, aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()

## 1.2 Benchmarking with microbenchmark

### Chunk 1

# Using proc.time
time <- proc.time()
for (i in 1:100) rnorm(100)
time <- proc.time() - time
time # elapsed is the 'real' elapsed time since the process was started

# Using system.time - a wrapper for the above code
system.time({for (i in 1:100) rnorm(100)})

### Chunk 2

# Data and mean
n <- 3
m <- 10
X <- matrix(1:(n * m), nrow = n, ncol = m)
mu <- colMeans(X)
# We assume mu is given in the time comparisons

### Chunk 3

# Some approaches:

# 1) sweep
Y1 <- sweep(x = X, MARGIN = 2, STATS = mu, FUN = "-")

# 2) apply (+ transpose to maintain the arrangement of X)
Y2 <- t(apply(X, 1, function(x) x - mu))

# 3) scale
Y3 <- scale(X, center = mu, scale = FALSE)

# 4) loop
Y4 <- matrix(0, nrow = n, ncol = m)
for (j in 1:m) Y4[, j] <- X[, j] - mu[j]
  
# 5) magic (my favourite!)
Y5 <- t(t(X) - mu)

### Chunk 4

# Test speed
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
# Notice the last column. It is only present if the package multcomp is present.
# It provides a statistical ranking (accounts for which method is significantly 
# slower or faster) using multcomp::cld
 
# Adjusting display
print(bench, unit = "ms", signif = 2)
# unit = "ns" (nanosecs), "us" ("microsecs"), "ms" (millisecs), "s" (secs)

# Graphical methods for the microbenchmark object
# Raw time data
par(mfrow = c(1, 1))
plot(bench, names = c("sweep", "apply", "scale", "for", "recycling"))
# Employs time logarithms
boxplot(bench, names = c("sweep", "apply", "scale", "for", "recycling")) 
# Violin plots
autoplot(bench)

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

## 1.3 Quick animations with manipulate

### Chunk 1

library(manipulate)

# A simple example
manipulate({
  plot(1:n, sin(2 * pi * (1:n) / 100), xlim = c(1, 100), ylim = c(-1, 1),
       type = "o", xlab = "x", ylab = "y")
  lines(1:100, sin(2 * pi * 1:100 / 100), col = 2)
}, n = slider(min = 1, max = 100, step = 1, ticks = TRUE))

### Chunk 2

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

### Chunk 3

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

# 2. Handling big data in R

## 2.1 The ff and ffbase packages

### Chunk 1

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
print(object.size(bigData2), units = "Mb")

# Save files to disk to emulate the situation with big data
write.csv(x = bigData1, file = "bigData1.csv", row.names = FALSE)
write.csv(x = bigData2, file = "bigData2.csv", row.names = FALSE)

# Read files using ff
library(ffbase) # Imports ff
bigData1ff <- read.table.ffdf(file = "bigData1.csv", header = TRUE, sep = ",")
bigData2ff <- read.table.ffdf(file = "bigData2.csv", header = TRUE, sep = ",")

# Recall: the *.csv are not copied into RAM!
print(object.size(bigData1ff), units = "Kb")
print(object.size(bigData2ff), units = "Kb")

# Delete the csv files in disk
file.remove(c("bigData1.csv", "bigData2.csv"))

### Chunk 2

# Operations on ff objects "almost" as with regular data.frames
class(bigData1ff)
class(bigData1ff[, 1])
bigData1ff[1:5, 1] <- rnorm(5)
# See ?ffdf for more allowed operations

# Filter of data frames
ffwhich(bigData1ff, bigData1ff$resp > 5)

## 2.2 Regression using biglm and friends

### Chunk 1

library(biglm)
# bigglm.ffdf has a very similar syntax to glm - but the formula interface does 
# not work always as expected:
# bigglm.ffdf(formula = resp ~ ., data = bigData1ff) # Does not work
# bigglm.ffdf(formula = resp ~ pred.1 + pred.2, data = bigData1ff) # Does work, 
# but not very convenient for a large number of predictors

# Hack for automatic inclusion of all the predictors
f <- formula(paste("resp ~", paste(names(bigData1ff)[-1], collapse = " + ")))

# bigglm.ffdf's call
biglmMod <- bigglm.ffdf(formula = f, data = bigData1ff, family = gaussian())
class(biglmMod)

# lm's call
lmMod <- lm(formula = resp ~ ., data = bigData1)

# The reduction in size of the resulting object is more than notable
print(object.size(biglmMod), units = "Kb")
print(object.size(lmMod), units = "Mb")

# Summaries
s1 <- summary(biglmMod)
s2 <- summary(lmMod)
s1
s2
# The summary of a biglm object yields slightly different significances for the
# coefficients than for lm. The reason is that biglm employs N(0, 1) 
# approximations for the distributions of the t-tests instead of the exact 
# t distribution. Obviously, if n is large, the differences are inappreciable.

# Extract coefficients
coef(biglmMod)

# AIC
AIC(biglmMod, k = 2)

# Prediction works "as usual"
predict(biglmMod, newdata = bigData1[1:5, ])
# newdata must contain a column for the response!
# predict(biglmMod, newdata = bigData2[1:5, -1]) # Error

# Update the model with more training data - this is key for chunking the data
update(biglmMod, moredata = bigData1[1:100, ])

### Chunk 2

# Model selection adapted to big data models
library(leaps)
reg <- regsubsets(biglmMod, nvmax = p, method = "exhaustive")
plot(reg) # Plot best model (top row) to worst model (bottom row). Black color 
# means that the predictor is included, white stands for excluded predictor

# Get the model with lowest BIC
subs <- summary(reg)
subs$which
subs$bic
subs$which[which.min(subs$bic), ]

### Chunk 3

# Same comments for the formula framework - this is the hack for automatic
# inclusion of all the predictors
f <- formula(paste("resp ~", paste(names(bigData2ff)[-1], collapse = " + ")))

# bigglm.ffdf's call
bigglmMod <- bigglm.ffdf(formula = f, data = bigData2ff, family = binomial())

# glm's call
glmMod <- glm(formula = resp ~ ., data = bigData2, family = binomial())

# Compare sizes
print(object.size(bigglmMod), units = "Kb")
print(object.size(glmMod), units = "Mb")

# Summaries
s1 <- summary(bigglmMod)
s2 <- summary(glmMod)
s1
s2

# AIC
AIC(bigglmMod, k = 2)

# Prediction works "as usual"
predict(bigglmMod, newdata = bigData2[1:5, ], type = "response")
# predict(bigglmMod, newdata = bigData2[1:5, -1]) # Error

# 3. ASCII fun in R

## 3.1 Text-based graphs with txtplot

### Chunk 1

library(txtplot) # txt* functions

# Generate common data
x <- rnorm(100)
y <- 1 + x + rnorm(100, sd = 1)
let <- as.factor(sample(letters, size = 1000, replace = TRUE))

# txtplot
plot(x, y)
txtplot(x, y)

# txtboxplot
boxplot(x, horizontal = TRUE)
txtboxplot(x)

# txtbarchart
barplot(table(let))
txtbarchart(x = let)

# txtcurve
curve(expr = sin(x), from = 0, to = 2 * pi)
txtcurve(expr = sin(x), from = 0, to = 2 * pi)

# txtacf
acf(x)
txtacf(x)

### Chunk 2

library(NostalgiR) # nos.* functions

# Mexican hat
xx <- seq(-10, 10, l = 50)
yy <- xx
f <- function(x, y) {r <- sqrt(x^2 + y^2); 10 * sin(r)/r}
zz <- outer(xx, yy, f)

# nos.density
plot(density(x)); rug(x)
nos.density(x)

# nos.hist
hist(x)
nos.hist(x)

# nos.ecdf
plot(ecdf(x))
nos.ecdf(x)

# nos.qqnorm
qqnorm(x); qqline(x)
nos.qqnorm(x)

# nos.qqplot
qqplot(x, y)
nos.qqplot(x, y)

# nos.contour
contour(xx, yy, zz)
nos.contour(data = zz, xmin = min(xx), xmax = max(xx), 
            ymin = min(yy), ymax = max(yy))

# nos.image
image(zz, col = viridis(50))
nos.image(data = zz, xmin = min(xx), xmax = max(xx), 
          ymin = min(yy), ymax = max(yy))

## 3.2 Cute animals with cowsay

### Chunk 1

library(cowsay)

# Random fortune
set.seed(363)
say("fortune", by = "random")

# All animals
# sapply(names(animals), function(x) say(x, by = x))

# Annoy the users of your package with good old clippy
say(what = "It looks like you\'re writing a letter!", 
    by = "clippy", type = "warning")

# A message from Yoda
say("Participating in the Coding Club UC3M you must. Yes, hmmm.", by = "yoda")

