---
layout: post
title: "Workflow for Rmd to blog post in coding club"
author: hoanguc3m
date: "May 1, 2018"
categories: [Rmarkdown, jekyll, Knitr]
published: true
visible: false
output:
  html_document:
    mathjax:  default
fontsize: 12pt 
linestretch: 1.5
---



# Prepare the Rmd file
a. You need to create the contend of the Rmd file.
b. You need to change the name of the file to ```date-shortTitle.Rmd``` for example ```2016-10-1-Blogging-with-Rmarkdown-and-knitr.Rmd```
c. You need to add the header to the Rmd file such that it could be translated later by Jekyll.


{% highlight r %}
layout: post
comments:  true
title: "Title of your talk"
author: YourName
date: 2016-10-01 20:30:00
published: true
visible: false
categories: [R, tag name]
excerpt_seperator: <!--more-->
output:
  html_document:
    mathjax:  default
{% endhighlight %}

where you can change ```title, author, date, categories``` as the description of the talk. 
The field ```published``` and ```visible``` say that if you want to publish the article and put it visible.
If ```published: fasle ```, the article can not be viewed in the website.
If ```published: true ``` and ```visible: false``` the article can be viewed in the website only when you know the link to access it.


# Compile ```Rmd``` file to ```md``` file

a. You need to install ```knitr``` package and add this function to R environment.


{% highlight r %}
KnitPost <- function(input, base.url = "/") {
    require(knitr)
    opts_knit$set(base.url = base.url)
    fig.path <- paste0("figure/source/", sub(".Rmd$", "", basename(input)), "/")
    opts_chunk$set(fig.path = fig.path)
    opts_chunk$set(fig.cap = "center")
    render_jekyll()
    knit(input, envir = parent.frame())
}
{% endhighlight %}

b. Then compile the Rmd file that you created, for example

{% highlight r %}
KnitPost("2016-10-1-Blogging-with-Rmarkdown-and-knitr.Rmd")
{% endhighlight %}
c. For making md nicely in the post, edit the  ```md``` file
- Line count: You can find and replace `{% highlight r %}` with `{% highlight r linenos %}`


d. Copy the output figure folder to ```codingclubuc3m``` main folder and the ```md``` file to ```post``` folder. 
- Then upload to github folder. 


{% highlight r %}
git add -A
git commit -m "New post 10/2016"
git push
{% endhighlight %}
