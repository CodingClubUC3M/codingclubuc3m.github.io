---
layout: page
title: Contributors
images:
  - image_path: /public/contributor/edu.png
    title: Eduardo García Portugués
    link: http://egarpor.github.io/
  - image_path: /public/contributor/antonio.jpeg
    title:  Antonio Elías Fernández 
    link: https://www.linkedin.com/in/antonio-el%C3%ADas-fern%C3%A1ndez-656ab495/
  - image_path: /public/contributor/hoang.jpg
    title: Hoang Nguyen
    link: http://hoanguc3m.github.io/
  - image_path: /public/contributor/person.png
    title: David García Heredia
    link:   
---



<ul class="photo-gallery">
  {% for image in page.images %}
    <li>
      <a href="{{ image.link }}">
        <img src="{{ image.image_path }}" width="200" alt="{{ image.title}}"/> {{ image.title}}
      </a>
    </li>
  {% endfor %}
</ul>