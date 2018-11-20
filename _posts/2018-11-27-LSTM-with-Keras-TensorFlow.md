---
layout: post
comments: true
title: "LSTM with Keras TensorFlow"
author: Stefano Cabras
date: 2018-11-27
published: true
visible: true
categories: [Deep Learning, Keras, LSTM]
bibliography: deeplearning.bib
excerpt_seperator: ""
output:
 html_document:
 mathjax: default
 number_sections: no
 toc: yes
 toc_float:
 toc_depth: 3
 collapsed: no
 smooth_scroll: no
 code_folding: show
 keep_md: true
---



<!---
Here is the standard html comment tags.
You can write all your comments here.
We start with the abstract of the talk .
-->

**Abstract**: This is the contribution to the [Coding Club UC3M](https://twitter.com/CodingClubUC3M). The aim is to show the use of TensorFlow with KERAS for classification and prediction in Time Series Analysis. The latter just implement a Long Short Term Memory (LSTM) model (an instance of a Recurrent Neural Network which avoids the vanishing gradient problem). 

# Introduction

The code below has the aim to quick introduce Deep Learning analysis with TensorFlow using the Keras back-end in R environment. Keras is a high-level neural networks API, developed with a focus on enabling fast experimentation and not for final products. Keras and in particular the ```keras```  R package allows to perform computations using also the GPU if the installation environment allows for it.

## Installing KERAS and TensorFlow in Windows ... otherwise it will be more simple

1. Install Anaconda: [https://www.anaconda.com/download/](https://www.anaconda.com/download/)

2. Install Rtools(34): [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/)

## GPU-TensorFlow

To use the option GPU-TensorFlow, you need CUDA Toolkit that matches the version of your GCC compiler: [https://developer.nvidia.com/cuda-toolkit](https://developer.nvidia.com/cuda-toolkit)



If you have Python (i.e. Anaconda) just


{% highlight r %}
install.packages("keras")
library(keras)
install_keras()
{% endhighlight %}

and this will install the Google Tensorflow module in Python.

If you want it working on GPU and you have a suitable CUDA version, you can install it with ```tensorflow = "gpu"``` option


{% highlight r %}
install_keras(tensorflow = "gpu")
{% endhighlight %}


## Simple check


{% highlight r %}
library(keras)
to_categorical(0:3)
{% endhighlight %}



{% highlight text %}
##      [,1] [,2] [,3] [,4]
## [1,]    1    0    0    0
## [2,]    0    1    0    0
## [3,]    0    0    1    0
## [4,]    0    0    0    1
{% endhighlight %}
