---
title: "Contributors"
layout: page
images:
- description: Assistant professor at the Department of Statistics of Carlos III University of Madrid. Enthusiast of coding since his early days as a student fighting against `FORTRAN`. Now with a reasonable expertise in `R` and its evolving ecosystem. His developed software is available at <https://github.com/egarpor>. 
  image_path: /public/contributor/edu.png
  link: http://egarpor.github.io/
  title: Eduardo García Portugués
- description: Short bio
  image_path: /public/contributor/antonio.jpeg
  link: https://www.linkedin.com/in/antonio-el%C3%ADas-fern%C3%A1ndez-656ab495/
  title: Antonio Elías Fernández
- description: Short bio
  image_path: /public/contributor/hoang.jpg
  link: http://hoanguc3m.github.io/
  title: Hoang Nguyen
- description: Short bio
  image_path: /public/contributor/person.png
  link: null
  title: David García Heredia
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
