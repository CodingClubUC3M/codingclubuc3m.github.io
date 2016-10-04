---
layout: post
comments:  true
title: "An Easy Start with Jekyll, for R-Bloggers"
date: 2015-12-15 20:00:00
published: true
categories: [R]
output:
  html_document:
    mathjax:  default
---

I would like my upper-level students to get more practice in writing about their data analysis work (well, to get get more practice in writing, generally).  Blogging is one device by which students can be motivated to write carefully, with a particular audience in mind. So why not have students blog about aspects of their R-work?

Students need cheap hosting:  as long as they know their way around git and Git Hub, then Git Hub Pages are a great (free) solution for that.  But then of course they have to use Jekyll, think about web design issues, etc., and on top of that if they plan to blog seriously about R they are probably going to want to write from an R Markdown source document rather than from Markdown.

All of this requires a lot of thinking about technical tools, at a time when students should focus as much as possible on fundamentals.  Learning R is already enough of a technical challenge!  Hence I decided to cobble together a framework that flattens the learning curve for students as much as possible.

Yihui Xie's [`servr`](https://github.com/yihui/servr) package and [knitr-jekyll](https://github.com/yihui/knitr-jekyll) code are a great way to address the R Markdown issue and to keep Jekyll in the background.

The remaining concern is site layout and styling.  For this I chose to work from Mark Otto's excellent [Hyde project](https://github.com/poole/hyde).

I added a few bells and whistles in the form of options for Disqus commenting and a couple of social media share buttons.  It ain't much but it will get the students going, I hope.

And it occurs to me that if you yourself are not yet a blogger then you might want to give my system a try.  The project repository is [here](https://github.com/homerhanumat/knitr-hyde),  The resulting site (with directions for use) is [here](https://homerhanumat.github.io/knitr-hyde).

In the future it would be interesting to investigate more modular ways of hooking Xihui's `knitr-jekyll` to other Jekyll projects, e.g., [Octopress](http://octopress.org/).  If you are aware of any efforts along these lines, please let me know.
