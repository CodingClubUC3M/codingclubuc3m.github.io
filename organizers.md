---
title: "Organizer"
layout: page
images:
    

  - name: Hoang Nguyen
    image_path: /public/contributor/hoang.jpg
    link: http://hoanguc3m.github.io/
    description: . 

  - name: Antonio Elías Fernández
    image_path: /public/contributor/antonio.jpeg
    link: https://www.linkedin.com/in/antonio-el%C3%ADas-fern%C3%A1ndez-656ab495/
    description:  Entering the final stretch of the PhD program in Statistics at Carlos III University of Madrid. <code class="highlighter-rouge">gretl</code> was his first contact with the open-source world and got stunned by the <code class="highlighter-rouge">R</code> community. His codes are devoted to complex data analysis.
  
  - name: David García Heredia
    image_path: /public/contributor/david.png
    link: https://github.com/DavidGarHeredia
    description: PhD student at the Department of Statistics at Carlos III University of Madrid, his research interests have led him to have programming as an essential part of his daily work. Although most of his code is made in <code class="highlighter-rouge">C++</code>, he is also fan of other languages as <code class="highlighter-rouge">Julia</code>, <code class="highlighter-rouge">R</code> or <code class="highlighter-rouge">MATLAB</code>.
    
  - name: Eduardo García Portugués
    image_path: /public/contributor/edu.png
    link: http://egarpor.github.io/  
    description: Assistant professor at the Department of Statistics of Carlos III University of Madrid. Enthusiast of coding since his early days as a student fighting against <code class="highlighter-rouge">FORTRAN</code>. Now with a reasonable expertise in <code class="highlighter-rouge">R</code> and its evolving ecosystem. His developed software is available at <a href="https://github.com/egarpor/">https://github.com/egarpor/</a>

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
        <img src="{{ image.image_path }}" width="200" alt="{{ image.name}}" class="avatar"/> 
        <h4>{{ image.name}}</h4>
      </a> 
</td>
<td>     
      <p>{{ image.description }}</p>
</td>
</tr>
{% endfor %}
</tbody>
</table>
