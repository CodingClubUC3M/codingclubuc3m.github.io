---
layout: post
title: "Notes on LaTeX Installation for R Studio"
date: 2015-12-19 20:00:00
published: true
comments:  true
categories: [Tech Notes]
output:
  html_document:
    mathjax:  default
---



* will be replaced by TOC
{:toc}


## Introduction

These are notes to myself and for colleagues in IT.  May they also prove helpful to those who land upon from Google.

From time to time I have to set up R and the R Studio server, configured in such a way that all users can knit their R Markdown documents to PDF with minimal chance of problems.  I assume also that some of those users may wish to use LaTeX for other purposes, so I need to start with a reasonably complete distribution of LaTeX and to be able to install or update specific LateX packages as I discover the need for them.

The notes below are based upon experience with Debian Jesse 8.2.  With minor modifications they should apply to other major Linux distributions.

I assume that you have R and R Studio installed and working to your satisfaction.

## R Packages to Remember

We want:

* `rmarkdown` (for conversion)
* `caTools` (forconversion)
* `bitopts` (for conversion)
* `knitr` (in case users need it in their R Markdown sources)

So log on to the server and run:

~~~ sh
sudo R
~~~

Then, in R:

~~~ r
install.packages(c("knitr", ,"caTools", "bitops","rmarkdown"))
~~~

## Pandoc

(This might be needed.)  Make sure that users call a version of Pandoc that R Studio likes.  To do this make sym links to the version that comes with R Studio:

~~~ sh
sudo ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin
sudo ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin
~~~


## Installing LaTeX Packages

You can get Tex Live from the Debian repositories, but for long-term maintenance the best thing is probably to install it directly from a CTAN mirror.  You won't get automatic updates through Debian, but updates from CTAN will be easy using the `tlmgr` package that comes with LaTeX.

So consult the [Tex Live Guide](https://www.tug.org/texlive/doc/texlive-en/texlive-en.html).  Go to [http://mirror.ctan.org/systems/texlive/tlnet](http://mirror.ctan.org/systems/texlive/tlnet) and be directed automatically to an appropriate mirror. Then download `install-tl-unx.tar.gz`.  Extract and cd into the directory.  Then run:

~~~ sh
sudo perl install-tl
~~~

You get the text-only installer.

Study the options in the Guide.  If space is a consideration (as it was in Debian VM that I used to do the research for this post), then under Schemes (`<S>`) you might go for **medium**.

Under Options make sure to select `<L>` to create sym links to the binaries.  You can just click through to accept the suggested values for the three sym link locations.

Now you can proceed with the installation.


If you did not perform a full installation of LaTeX, then you are probably missing a few packages.  As of the time of writing, the medium installation was missing  `framed` and `titling` for basic knitting, and `inconsolata` for those users who run checks on R packages.  This is where `tlmgr` comes in:

~~~ sh
sudo tlmgr install framed titling inconsolata
~~~

In the long run you can use `tlmgr` for updating packages as well.

## Test

Log on to the Server as a regular user, create a new R Markdown file (the sample should do), save it and Knit to PDF.  The smaller your installation of LateX, the more packages you will be missing.  Go through your error messages one by one, using `sudo tlmgr` to install each required package as its absence is made known to you.


