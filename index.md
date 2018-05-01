---
layout: default
title: Home
---
<!-- HTML elements for search -->
<input type="text" id="search-input" placeholder="Type / to search...">
<br/>
<div id="results-container"></div>


<script>
SimpleJekyllSearch({
  search-input: document.querySelector('.search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/search.json',
  searchResultTemplate: '<li><a href="{{ site.url }}{url}">{title}</a></li>'
})
</script>

<section id="archive">
  <h3>This year's posts</h3>
  {% for post in site.posts %}
    {% unless post.next %}
      <ul class="this">
    {% else %}
      {% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
      {% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
      {% if year != nyear %}
        </ul>
        <h3>{{ post.date | date: '%Y' }}</h3>
        <ul class="past">
      {% endif %}
    {% endunless %}
      <li><time>{{ post.date | date:"%d %b" }}: </time><a class = "post-title" href="{{ site.baseurl }}{{ post.url | remove_first: '/' }}">{{ post.title }}</a></li>
  {% endfor %}
  </ul>
</section>
