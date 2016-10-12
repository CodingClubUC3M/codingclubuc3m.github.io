---
title: "GoogleTrend"
author: "Antonio Elías"
date: "12 de octubre de 2016"
output: html_document
layout: post
categories: [Rmarkdown, jekyll, Knitr, GoogleTrends]
---


Firstly install package 'gtrendsR' and load the library,

Then get logged in your google account, 

{% highlight r %}
someuser<-'user'
somepassword<-'password'
gconnect(someuser, somepassword)
{% endhighlight %}
Let see how is the interest in markdown, rmarkdown and knitr by google searchs,
![center](/figure/source/2016-10-12-Our-topics-google-trends/pressure-1.png)

![center](/figure/source/2016-10-12-Our-topics-google-trends/pressure-2.png)
