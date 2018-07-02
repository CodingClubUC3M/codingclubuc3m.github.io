---
layout: post
comments:  true
title: "An introduction to Tensorflow"
author: Hoang Nguyen
date: 2018-07-03 20:30:00
published: true
categories: [R, tensorflow]
excerpt_seperator: <!--more-->
output:
  html_document:
    mathjax:  default
---

**Abstract:** ```Tensorflow``` has been widely used for many applications in machine learning and deep learning. However, ```Tensorflow``` is more than that, it is a general purpose computing library. Based on that, people have created a rich ecosystem for quickly developing models. In this talk, I will show how statisticians can get most of the main features in ```Tensorflow``` such as automatic differentiation, optimization and Bayesian analysis through a simple linear regression example.  

### Install ```TensorFlow``` in R

We summary the main steps for installing ```TensorFlow``` package in R. 
For the full instruction, please go to:

- [Windows](https://www.tensorflow.org/install/install_windows)
- [Ubuntu](https://www.tensorflow.org/install/install_linux)
- [macOS](https://www.tensorflow.org/install/install_mac)

#### Windows

1. Install python, pip3 and ```TensorFlow```, 

a. Download [Python](https://www.python.org/downloads/release/python-354/) and install (Choose add path and install pip3).

b. Open cmd with administration role and execute,

{% highlight bash %}
pip3 install tensorflow==1.9.0rc1
pip3 install tfp-nightly==0.1.0rc1.dev20180702    # depends on tensorflow (CPU-only)
{% endhighlight %}



#### Ubuntu
1. Install python, pip3 and ```TensorFlow```,

{% highlight bash %}
sudo apt-get install python3-pip python3-dev
pip3 install tensorflow==1.9.0rc1
pip3 install tfp-nightly==0.1.0rc1.dev20180702    # depends on tensorflow (CPU-only)
{% endhighlight %}


#### macOS

Check pip3 version:

{% highlight bash %}
pip3 -V # for Python 3.n 
{% endhighlight %}

If pip or pip3 8.1 or later is not installed, issue the following commands to install or upgrade:


{% highlight bash %}
sudo easy_install --upgrade pip
sudo easy_install --upgrade six 
pip3 install tensorflow==1.9.0rc1
pip3 install tfp-nightly==0.1.0rc1.dev20180702    # depends on tensorflow (CPU-only)
{% endhighlight %}

Once you have installed `TensorFlow`, we go to `Rstudio` and intall the R API package.

#### Install ```R``` package ```TensorFlow```


{% highlight r %}
install.packages("tensorflow", "reticulate")
tensorflow::install_tensorflow()
{% endhighlight %}

### Hello ```TensorFlow```

Test your installation with this trunk of codes


{% highlight r %}
library(tensorflow)

sess <- tf$Session()

hello <- tf$constant("Hello, TensorFlow!")
sess$run(hello)
{% endhighlight %}



{% highlight text %}
## [1] "Hello, TensorFlow!"
{% endhighlight %}