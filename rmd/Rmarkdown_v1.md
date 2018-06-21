---
layout: post
comments:  true
title: "Custom Print Methods"
author: "Yihui Xie"
date: 2018-05-10
published: true
visible: true
categories: [R, markdown]
excerpt_seperator: ""
output:
  html_document:
    mathjax:  default
    number_sections: no
    toc: yes
    toc_float:
      collapsed: no
      smooth_scroll: no
    code_folding: show
---


Before **knitr** v1.6, printing objects in R code chunks basically emulates the R console. For example, a data frame is printed like this^[Note R prints an object without an explicit `print()` call when it is _visible_; see `?invisible`]:


```r
head(mtcars)
```



```text
                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

The text representation of the data frame above may look very familiar with most R users, but for reporting purposes, it may not be satisfactory -- often times we want to see a table representation instead. That is the problem that the chunk option `render` and the S3 generic function `knit_print()` try to solve.

## Customize Printing

After we evaluate each R expression in a code chunk, there is an object returned. For example, `1 + 1` returns `2`. This object is passed to the chunk option `render`, which is a function with two arguments, `x` and `options`, or `x` and `...`. The default value for the `render` option is `knit_print`, an S3 function in **knitr**:


```r
library(knitr)
knit_print  # an S3 generic function
```



```text
## function (x, ...) 
## {
##     if (need_screenshot(x, ...)) {
##         html_screenshot(x)
##     }
##     else {
##         UseMethod("knit_print")
##     }
## }
## <environment: namespace:knitr>
```



```r
methods(knit_print)
```



```text
##  [1] knit_print.data.frame*     knit_print.default*       
##  [3] knit_print.grouped_df*     knit_print.html*          
##  [5] knit_print.knit_asis*      knit_print.knitr_kable*   
##  [7] knit_print.rowwise_df*     knit_print.shiny.tag*     
##  [9] knit_print.shiny.tag.list* knit_print.tbl_sql*       
## see '?methods' for accessing help and source code
```



```r
getS3method('knit_print', 'default')  # the default method
```



```text
## function (x, ..., inline = FALSE) 
## {
##     if (inline) 
##         x
##     else normal_print(x)
## }
## <environment: namespace:knitr>
```



```r
normal_print
```



```text
## function (x, ...) 
## if (isS4(x)) methods::show(x) else print(x)
## <environment: namespace:evaluate>
```

As we can see, `knit_print()` has a `default` method, which is basically `print()` or `show()`, depending on whether the object is an S4 object. This means it does nothing special when printing R objects:


```r
knit_print(1:10)
```



```text
##  [1]  1  2  3  4  5  6  7  8  9 10
```



```r
knit_print(head(mtcars))
```



```text
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

S3 generic functions are extensible in the sense that we can define custom methods for them. A method `knit_print.foo()` will be applied to the object that has the class `foo`. Here is quick example of how we can print data frames as tables:


```r
library(knitr)
# define a method for objects of the class data.frame
knit_print.data.frame = function(x, ...) {
  res = paste(c('', '', kable(x)), collapse = '\n')
  asis_output(res)
}
```

We expect the print method to return a character vector, or an object that can be coerced into a character vector. In the example above, the `kable()` function returns a character vector, which we pass to the `asis_output()` function so that later **knitr** knows that this result needs no special treatment (just write it as is), otherwise it depends on the chunk option `results` (`= 'asis'` / `'markup'` / `'hide'`) how a normal character vector should be written. The function `asis_output()` has the same effect as `results = 'asis'`, but saves us the effort to provide this chunk option explicitly. Now we check how the printing behavior is changed. We print a number, a character vector, a list, a data frame, and write a character value using `cat()` in the chunk below:


```r
1 + 1
```



```text
## [1] 2
```



```r
head(letters)
```



```text
## [1] "a" "b" "c" "d" "e" "f"
```



```r
list(a = 1, b = 9:4)
```



```text
## $a
## [1] 1
## 
## $b
## [1] 9 8 7 6 5 4
```



```r
head(mtcars)
```



|                  |  mpg| cyl| disp|  hp| drat|    wt|  qsec| vs| am| gear| carb|
|:-----------------|----:|---:|----:|---:|----:|-----:|-----:|--:|--:|----:|----:|
|Mazda RX4         | 21.0|   6|  160| 110| 3.90| 2.620| 16.46|  0|  1|    4|    4|
|Mazda RX4 Wag     | 21.0|   6|  160| 110| 3.90| 2.875| 17.02|  0|  1|    4|    4|
|Datsun 710        | 22.8|   4|  108|  93| 3.85| 2.320| 18.61|  1|  1|    4|    1|
|Hornet 4 Drive    | 21.4|   6|  258| 110| 3.08| 3.215| 19.44|  1|  0|    3|    1|
|Hornet Sportabout | 18.7|   8|  360| 175| 3.15| 3.440| 17.02|  0|  0|    3|    2|
|Valiant           | 18.1|   6|  225| 105| 2.76| 3.460| 20.22|  1|  0|    3|    1|

```r
cat('This is cool.')
```



```text
## This is cool.
```

We see all objects except the data frame were printed "normally"^[The two hashes `##` were from the chunk option `comment`; you can turn them off by `comment = ''`.]. The data frame was printed as a real table. Note you do not have to use `kable()` to create tables -- there are many other options such as **xtable**. Just make sure the print method returns a character string.

In the future, I may provide a companion package with **knitr** that includes appropriate printing methods so that users only need to load this package to get attractive printed results. A major factor to consider when defining a printing method is the output format. For example, the table syntax can be entirely different when the output is LaTeX vs when it is Markdown.

It is strongly recommended that your S3 method has a `...` argument, so that your method can safely ignore arguments that are passed to `knit_print()` but not defined in your method. At the moment, a `knit_print()` method can have two optional arguments:

- the `options` argument takes a list of the current chunk options;
- the `inline` argument indicates if the method is called in code chunks or inline R code;

Depending on your application, you may optionally use these arguments. Here are some examples:


```r
knit_print.classA = function(x, ...) {
  # ignore options and inline
}
knit_print.classB = function(x, options, ...) {
  # use the chunk option out.height
  asis_output(paste(
    '<iframe src="https://yihui.name" height="', options$out.height, '"></iframe>',
  ))
}
knit_print.classC = function(x, inline = FALSE, ...) {
  # different output according to inline=TRUE/FALSE
  if (inline) {
    'inline output for classC'
  } else {
    'chunk output for classC'
  }
}
knit_print.classD = function(x, options, inline = FALSE, ...) {
  # use both options and inline
}
```

## A Low-level Explanation

You can skip this section if you do not care about the low-level implementation details.

### The `render` option

As mentioned before, the chunk option `render` is a function that defaults to `knit_print()`. We can certainly use other render functions. For example, we create a dummy function that always says "I do not know what to print" no matter what objects it receives:


```r
dummy_print = function(x, ...) {
  cat("I do not know what to print!")
  # this function implicitly returns an invisible NULL
}
```

Now we use the chunk option `render = dummy_print`:


```r
1 + 1
```



```text
## I do not know what to print!
```



```r
head(letters)
```



```text
## I do not know what to print!
```



```r
list(a = 1, b = 9:4)
```



```text
## I do not know what to print!
```



```r
head(mtcars)
```



```text
## I do not know what to print!
```



```r
cat('This is cool.')
```



```text
## This is cool.
```

Note the `render` function is only applied to visible objects. There are cases in which the objects returned are invisible, e.g. those wrapped in `invisible()`.


```r
1 + 1
```



```text
## [1] 2
```



```r
invisible(1 + 1)
invisible(head(mtcars))
x = 1:10  # invisibly returns 1:10
```

### Metadata

The print function can have a side effect of passing "metadata" about objects to **knitr**, and **knitr** will collect this information as it prints objects. The motivation of collecting metadata is to store external dependencies of the objects to be printed. Normally we print an object only to obtain a text representation, but there are cases that can be more complicated. For example, a [**ggvis** ](http://ggvis.rstudio.com/) graph requires external JavaScript and CSS dependencies such as `ggvis.js`. The graph itself is basically a fragment of JavaScript code, which will not work unless the required libraries are loaded (in the HTML header). Therefore we need to collect the dependencies of an object beside printing the object itself.

One way to specify the dependencies is through the `meta` argument of `asis_output()`. Here is a pseudo example:


```r
# pseudo code
knit_print.ggvis = function(x, ...) {
  res = ggvis::print_this_object(x)
  knitr::asis_output(res, meta = list(
    ggvis = list(
      version = '0.1.0',
      js  = system.file('www', 'js',  'ggvis.js',  package = 'ggvis'),
      css = system.file('www', 'www', 'ggvis.css', package = 'ggvis')
    )
  ))
}
```

Then when **knitr** prints a **ggvis** object, the `meta` information will be collected and stored. After knitting is done, we can obtain a list of all the dependencies via `knit_meta()`. It is very likely that there are duplicate entries in the list, and it is up to the package authors to clean them up, and process the metadata list in their own way (e.g. write the dependencies into the HTML header). We give a few more quick and dirty examples below to see how `knit_meta()` works.

Now we define a print method for `foo` objects:


```r
library(knitr)
knit_print.foo = function(x, ...) {
  res = paste('**This is a `foo` object**:', x)
  asis_output(res, meta = list(
    js  = system.file('www', 'shared', 'shiny.js',  package = 'shiny'),
    css = system.file('www', 'shared', 'shiny.css', package = 'shiny')
  ))
}
```

See what happens when we print `foo` objects:


```r
new_foo = function(x) structure(x, class = 'foo')
new_foo('hello')
```

**This is a `foo` object**: hello

Check the metadata now:


```r
str(knit_meta(clean = FALSE))
```



```text
## List of 2
##  $ js : chr "/home/hoanguc3m/R/x86_64-pc-linux-gnu-library/3.4/shiny/www/shared/shiny.js"
##  $ css: chr "/home/hoanguc3m/R/x86_64-pc-linux-gnu-library/3.4/shiny/www/shared/shiny.css"
##  - attr(*, "knit_meta_id")= chr [1:2] "unnamed-chunk-9" "unnamed-chunk-9"
```

Another `foo` object:


```r
new_foo('world')
```

**This is a `foo` object**: world

Similarly for `bar` objects:


```r
knit_print.bar = function(x, ...) {
  asis_output(x, meta = list(head = '<script>console.log("bar!")</script>'))
}
new_bar = function(x) structure(x, class = 'bar')
new_bar('**hello** world!')
```

**hello** world!

```r
new_bar('hello **world**!')
```

hello **world**!

The final version of the metadata, and clean it up:


```r
str(knit_meta())
```



```text
## List of 6
##  $ js  : chr "/home/hoanguc3m/R/x86_64-pc-linux-gnu-library/3.4/shiny/www/shared/shiny.js"
##  $ css : chr "/home/hoanguc3m/R/x86_64-pc-linux-gnu-library/3.4/shiny/www/shared/shiny.css"
##  $ js  : chr "/home/hoanguc3m/R/x86_64-pc-linux-gnu-library/3.4/shiny/www/shared/shiny.js"
##  $ css : chr "/home/hoanguc3m/R/x86_64-pc-linux-gnu-library/3.4/shiny/www/shared/shiny.css"
##  $ head: chr "<script>console.log(\"bar!\")</script>"
##  $ head: chr "<script>console.log(\"bar!\")</script>"
##  - attr(*, "knit_meta_id")= chr [1:6] "unnamed-chunk-9" "unnamed-chunk-9" "unnamed-chunk-11" "unnamed-chunk-11" ...
```



```r
str(knit_meta()) # empty now, because clean = TRUE by default
```



```text
##  list()
```

### For package authors

If you are implementing a custom print method in your own package, here are two hints:

1. `knit_print()` is an S3 generic function in **knitr**, so in theory you need to import it in your namespace via `importFrom(knitr, knit_print)`, but due to the "lack of rigor" of the S3 system, you can choose not to import **knitr**, and just do `export(knit_print.foo)` in the namespace, then R will find the S3 "method" after your package is attached via `library()`, because it is essentially a normal R function;
1. `asis_output()` is simply a function that marks an object with the class `knit_asis`, and you do not have to import this function to your package, either -- just let your print method return `structure(x, class = 'knit_asis')`, and if there are additional metadata, just put it in the `knit_meta` attribute; here is the source code of this function:
    
    ```r
    knitr::asis_output
    ```
    
    
    
    ```text
    ## function (x, meta = NULL, cacheable = NA) 
    ## {
    ##     structure(x, class = "knit_asis", knit_meta = meta, knit_cacheable = cacheable)
    ## }
    ## <environment: namespace:knitr>
    ```

If you are worried about possible future changes in `asis_output()`, you can put **knitr** in the `Suggests` field in DESCRIPTION, and use `knitr::asis_output()`, so that you can avoid the "hard" dependency on **knitr**.


