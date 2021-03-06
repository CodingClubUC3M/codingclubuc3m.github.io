---
title: "Contributors"
layout: page

contributorsY2:
  - name: Juan Miguel Marín Diazaraque
    image_path: /public/contributor/JMiguel.png
    link: http://portal.uc3m.es/portal/page/portal/dpto_estadistica/personal/juan_miguel_marin_diazaraque
    description: TBA.

  - name: Stefano Cabras
    image_path: /public/contributor/StefanoCabras.jpg
    link: https://stefano-cabras.webnode.es/
    description: Stefano Cabras born in Cagliari (Sardinia, Italy) in 1974. In 1999 and in 2004 he obtained his PhD in Statistics at the University of Florence. During this period he visited the Department of Statistics at the Carnegie Mellon University (Pittsburgh-PA, USA) where he obtained in 2003 the Master in Statistics. Since 2005 he is Associate Professor at University of Cagliari (in leave) and since 2018 at Universidad Carlos III de Madrid after being Ramón y Cajal Professor. His research topics in Statistics concern either theoretical aspects along with applications to several scientific fields.
  
  - name: Miguel Ángel Daza Arbolí
    image_path: /public/contributor/MiguelAngel.jpg
    link: 
    description: Miguel obtained his 5-year degree in Statistical Sciences and Techniques by the University of Valencia (2002). Nowadays, he is linked to the Carlos III University of Madrid as a part-time professor. In 2007, in a congress of the SEIO, he acceded to the Working Group - Teaching and Learning of Statistics and Operation Research (GENAEIO). Since then, he has been working with <code class="highlighter-rouge">R</code>, some authoring tools (<code class="highlighter-rouge">Jclic</code>, <code class="highlighter-rouge">Geogebra</code>, <code class="highlighter-rouge">eXeLearning</code>), educational platforms (<code class="highlighter-rouge">MOODLE</code>) and software for surveys (<code class="highlighter-rouge">LimeSurvey</code>). Enthusiast of the <code class="highlighter-rouge">GNU</code> philosophy and online resources, lately, he has been adding some gamification in work (using <code class="highlighter-rouge">Kahoot</code>)".
      
  - name: Antonio Elías Fernández
    image_path: /public/contributor/antonio.jpeg
    link: https://www.linkedin.com/in/antonio-el%C3%ADas-fern%C3%A1ndez-656ab495/
    description:  Entering the final stretch of the PhD program in Statistics at Carlos III University of Madrid. <code class="highlighter-rouge">gretl</code> was his first contact with the open-source world and got stunned by the <code class="highlighter-rouge">R</code> community. His codes are devoted to complex data analysis.
  
  - name: Pedro Vicente Gómez 
    image_path: /public/contributor/pedro.jpg
    link: https://github.com/pedrovgs
    description: Pedro is a Software Engineer focused on new technologies, open source, clean code, and testing. Right now he's working as a Senior Software Engineer at <code class="highlighter-rouge">Karumi</code>, a little software development studio. <code class="highlighter-rouge">Tuenti</code> and <code class="highlighter-rouge">Droiders</code> alumni, Pedro tries to write the best possible code every day to build excellent tech products.

  - name:
    image_path: /public/contributor/TBA2.jpg
    link: 
    description: Many more contributors to be announced! <br />

contributorsY1:
    
  - name: Hoang Nguyen
    image_path: /public/contributor/hoang.jpg
    link: http://hoanguc3m.github.io/
    description: Hoang is on his final year of the PhD program in Statistics at Carlos III University of Madrid. He enjoys Bayesian inference and statistical computation. He contributes to several <code class="highlighter-rouge">R</code> packages in his <a href="https://github.com/hoanguc3m/">repositories</a>. 

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
<col width="35%" />
<col width="65%" />
</colgroup>
<thead>
<tr class="header">
<th>Contributors 2018-2019</th>
<th>Biography</th>
</tr>
</thead>
<tbody>
{% for image in page.contributorsY2 %}
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

<br />
<br />

<table>
<colgroup>
<col width="35%" />
<col width="65%" />
</colgroup>
<thead>
<tr class="header">
<th>Contributors 2017-2018</th>
<th>Biography</th>
</tr>
</thead>
<tbody>
{% for image in page.contributorsY1 %}
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
