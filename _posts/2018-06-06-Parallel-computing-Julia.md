---
layout: post
comments:  true
title: "A brief introduction to parallel computing in Julia"
author: David García-Heredia
date: 2018-06-06
published: true
categories: [Julia, parallel]
excerpt_seperator: <!--more-->
output:
  html_document:
    mathjax:  default
---

**Abstract**

In this session, we will be learning how to parallelize code in ```Julia```. Through different examples, we will cover from the most basic ideas (e.g.: sending work to different processes) to more advanced ones (e.g.: automatically sequence tasks in parallel). The tutorial ends with a parallel implementation of the $k$-nearest neighbors algorithm.