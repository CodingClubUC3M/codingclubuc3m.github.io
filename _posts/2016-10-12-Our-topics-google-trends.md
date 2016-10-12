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
someuser<-'youruser'
somepassword<-'yourpassword'
gconnect(someuser, somepassword)
{% endhighlight %}
Lets see how is the interest in markdown, rmarkdown and knitr by google searchs,

{% highlight r %}
result <- gtrends(c('Rmarkdown','Markdown'))
plot(result, type='trend')
{% endhighlight %}

![center](/figure/source/2016-10-12-Our-topics-google-trends/pressure-1.png)

{% highlight r %}
head(result$BÃºsquedas.principales.de.markdown)
{% endhighlight %}



{% highlight text %}
## NULL
{% endhighlight %}



{% highlight r %}
head(result$BÃºsquedas.principales.de.rmarkdown)
{% endhighlight %}



{% highlight text %}
## NULL
{% endhighlight %}



{% highlight r %}
result <- gtrends(c('Knitr'))
plot(result, type='trend')
{% endhighlight %}

![center](/figure/source/2016-10-12-Our-topics-google-trends/pressure-2.png)

{% highlight r %}
head(result$BÃºsquedas.principales.de.markdown)
{% endhighlight %}



{% highlight text %}
## NULL
{% endhighlight %}
