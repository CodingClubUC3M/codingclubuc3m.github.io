---
layout: default
title: Home
image_sliders:
  - slider1
---
<h1>Welcome to Coding Club UC3M!</h1>

{% include slider.html selector="slider1" %}



<section id="archive">
  <h3>Sessions</h3>

<!-- Html Elements for Search -->
<div id="search-container">
<input type="text" id="search-input" placeholder="search...">
<ul id="results-container"></ul>
</div>


<!-- Script pointing to search-script.js -->
<script src="/public/js/simple-jekyll-search.js" type="text/javascript"></script>


<!-- Configuration -->
<script>
SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/search.json'
})
</script>

  {% for post in site.posts reversed %}
    {% if post.visible != false  %}
    {% unless post.next %}

    {% else %}
      {% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
      {% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
      {% if year != nyear %}
        <ul class="this"> </ul>
        <h3>{{ post.date | date: '%Y' }}</h3>
        <ul class="past">  </ul>
      {% endif %}
    {% endunless %}
      <li><time>{{ post.date | date:"%d %b" }}: </time><a class = "post-title" href="{{ site.baseurl }}{{ post.url | remove_first: '/' }}">{{ post.title }}</a></li>
     {% endif %}   
  {% endfor %}
</section>

### How to join?

Just show up. But it would be nice if you let us know in advance to adapt the logistics by filling the confirmation form (if you have received it) or by dropping us a line at <coding.club.uc3m@gmail.com>.

Check out the lastest news at <a href="https://twitter.com/CodingClubUC3M?ref_src=twsrc%5Etfw" class="twitter-follow-button" data-size="small" data-show-count="true">CodingClubUC3M</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

If you want to contribute a session, then please fill in [this form](https://goo.gl/forms/CIj7hxkAeEA4VjZR2). 
