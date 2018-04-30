---
layout: page
title: Contributors
images:
  - image_path: /public/contributor/edu.png
    title: Eduardo García
    link: http://egarpor.github.io/
    description: Short bio
  - image_path: /public/contributor/antonio.jpeg
    title:  Antonio Elías 
    description: Short bio    
    link: https://www.linkedin.com/in/antonio-el%C3%ADas-fern%C3%A1ndez-656ab495/
  - image_path: /public/contributor/hoang.jpg
    title: Hoang Nguyen
    description: Short bio
    link: http://hoanguc3m.github.io/
  - image_path: /public/contributor/person.png
    title: David García
    link:   
    description: Short bio
---

<table>
<colgroup>
<col width="30%" />
<col width="70%" />
</colgroup>
<thead>
<tr class="header">
<th>Contributors</th>
<th>Biography</th>
</tr>
</thead>
<tbody>
{% for image in page.images %}
<tr>
<td align="center">
      <a href="{{ image.link }}">
        <img src="{{ image.image_path }}" width="200" alt="{{ image.title}}" class="avatar"/> 
        <h4>{{ image.title}}</h4>
      </a> 
</td>
<td>     
      <p>{{ image.description }}</p>
</td>
</tr>
{% endfor %}
</tbody>
</table>
