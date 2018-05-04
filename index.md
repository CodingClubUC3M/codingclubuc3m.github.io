---
layout: default
title: Home
---
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

<section id="archive">
  <h3>This year's posts</h3>
  {% for post in site.posts reversed %}
        <ul class="this">
    {% unless post.next %}
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
