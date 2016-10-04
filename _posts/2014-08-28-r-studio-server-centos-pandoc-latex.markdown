---
layout: post
title: "New Wine in an Old Bottle:  R Markdown v2 and R Studio on the Cent OS Server"
date: 2014-08-28 01:00:00
published: true
comments:  true
categories: [R, Tech Notes]
output:
  html_document:
    mathjax:  default
---



* will be replaced by TOC
{:toc}


## Introduction

R Markdown Version 2 is a boon to students:  with a single click one can convert an R Markdown file to either HTML, PDF or Word format.  However, getting this feature to work fully in the R Studio server environment may require a bit of work, especially if you running the Server on a Cent OS distribution.  Although I am sure that Cent OS has many virtues, an up-to-date repository is not among them.

This post is the record of an arm wrasslin' match with Cent OS and the R Studio Server version 0.98.932, from which I emerged more or less victorious.  If your IT department hosts RStudio on CentOS, then perhaps the following remarks will make your life a bit easier.  On the other hand,  if you know your way around Linux better than I do, please feel free to offer quicker or better solutions in the Comments.

Log on to the server, perhaps through `ssh` (secure shell).  Come armed with administrative privileges.

## New Pandoc

R Markdown v2 uses a newer version of the `pandoc`converter than the one available in the Cent OS repository.  Fortunately, R Studio comes bundled with the binaries of a sufficiently recent version of `pandoc`.  You obtain access to these files by establishing symbolic links in the `/usr/local/bin` directory to the `pandoc` and `pandoc-cite` binaries:

~~~ sh
sudo ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin
sudo ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin
~~~

## Installing LaTeX Packages

You can get Tex Live from the Cent OS repositories, but the release appears to date back to the year 2007.  Therefore it lacks a couple of packages needed by `pandoc`:

* Heiko Oberdiek's [ifluatex](http://www.ctan.org/pkg/ifluatex), and
* Donald Arsenau's [framed](http://www.ctan.org/pkg/framed).

Since you will download these packages from the Comprehensive Tex Archive Network, you'll want a web-fetch utility such as `wget`.  If it's not already installed on Cent OS, you can get it with:

~~~ sh
sudo yum install wget
~~~

Now you can grab the relevant files with `wget`:

~~~ sh
wget http://www.ctan.org/tex-archive/macros/latex/contrib/oberdiek/ifluatex.dtx
wget http://mirrors.ctan.org/macros/latex/contrib/framed.zip
~~~

Turning first to `ifluatex`, we begin by by unpacking the `.dtx` bundle.  This is accomplished with a `tex` command:

~~~ sh
tex ifluatex.dtx
~~~

Several files spill out into your Home directory.  You care only about `ifluatex.sty`.  Copy it as follows:

~~~ sh
sudo cp ifluatex.sty /usr/share/texmf/tex/generic/oberdiek
~~~

As for the `framed` package, you must first unzip the downloaded file into a directory:

~~~ sh
mkdir framed
unzip framed.zip -d framed
~~~

Now copy the `framed` directory as follows:

~~~ sh
sudo cp -rf framed /usr/share/texmf/tex/latex
~~~

Finally, you need to make tex aware of the existence of these new packages with `texhash`:

~~~ sh
sudo texhash
~~~

Now you may Knit to your heart's content!
