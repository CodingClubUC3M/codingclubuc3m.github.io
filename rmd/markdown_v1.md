<!---
Here is the standard html comment tags.
You can write all your comments here.
We start with the abstract of the talk 
-->

**Abstract**: `Markdown` is a lightweight markup language. It has a simple text format syntax which can be easily converted to `html`, `pdf`, `doc`. It allows for a universal text format which you can edit using any text editor and to be rendered in different web frameworks. This document is prepared by [`@CodingClubUC3M`](https://twitter.com/CodingClubUc3m) to introduce fundamental elements of `Markdown` and serves as a reference template for contributors.


## Introduction

`Markdown` is a useful language for writing contents for email, comments, blog post, tutorial,... 
It allows for a universal text format to be rendered in different web frameworks.
`Markdown` is easy to read and write as other word processing applications.

This document will guide you through some fundamental elements and language of `Markdown`.
A `Markdown` file is a plain text file with a few symbols to format text such as
asterisks (*), and back-ticks (`).

We advise you to visit https://stackedit.io/ and copy and paste this file into the editor.
Or you can open RStudio and compile the `Markdown` file using `Preview` button (Or `knit` button if you use Rmarkdown).

## Text format

To emphasize a snippet of text with bold font face, we use double asterisks, for example:
```
**Here is an important sentence.**
```
will be rendered to:  
**Here is an important sentence.**

Similarly, we can create italic or strike-through text:
```
We introduce *a new syntax*
*You can~~not~~ combine them*
```
will be rendered to:  
We introduce *a new syntax*  
*You can~~not~~ combine them*

Moreover, you can use the back-tick to create an inline code format, or programming languages such as `R`, `C`, `Matlab`, `Julia`,...
```
We introduce a new `R` package where you can add two big numbers.
```
will be rendered to:  
We introduce a new `R` package where you can add two big numbers.

## Line break

In order to create a line break in `Markdown`, you can choose one of these syntaxes:

1. Add the backslash (`\`) at the end of the line (in the first paragraph).
2. Add an empty line to separate two paragraphs (in the second paragraph).
3. Add two or more spaces at the end of the line (in the third paragraph).

Note that, the single line break (using enter button) in the plain `Markdown` file does not translate into a line break in the compiled output file.
For example:
```
This is the first paragraph.\
This is the second paragraph.

This is the third paragraph.  
This is the fourth paragraph.
```
will be rendered to:

This is the first paragraph.\
This is the second paragraph.

This is the third paragraph.  
This is the fourth paragraph.

## Blockquotes

In `Markdown`, it is easy to quote a sentence or a paragraph using `>` symbol:
```
As Box once said
> "All models are wrong, but some are useful."
```
will be rendered to:  

As Box once said:

> "All models are wrong, but some are useful."

## Header

Like Microsoft office word, we separate the post using six header levels:
```
# Intronduction
## Motivation
### Applications
#### More headers
##### More tiny headers
##### Supper tiny headers
```

will be rendered to: 

# Intronduction
## Motivation
### Applications
#### More headers
##### More tiny headers
##### Supper tiny headers

## Links and embedded elements

`Markdown` also allows for a convenient syntax for website links and other embedded elements such as photos, video,... Note that, you can also use html tag to embed videos.

### Hyperlink

Web links are automatically rendered, you can paste the website address directly or label it. For example:
```
For more information, please visit http://codingclubuc3m.github.io.  
please visit [Coding club website](https://http://codingclubuc3m.github.io)
```
will be rendered to: 

For more information, please visit http://codingclubuc3m.github.io.  
please visit [Coding club website](https://http://codingclubuc3m.github.io)

### Image and video

For images, you cannot configure image sizes, so it is better to resize it before embedded:
```
![Coding club is awesome](https://github.com/CodingClubUC3M/codingclubuc3m.github.io/raw/master/public/logos/UC3M_logo_cc.png "Put your title here")
```
will be rendered to:  
![Coding club is awesome](https://github.com/CodingClubUC3M/codingclubuc3m.github.io/raw/master/public/logos/UC3M_logo_cc.png "Put your title here")

For videos, you can embed an image which links to the video clip. 
```
[![UC3M](http://img.youtube.com/vi/-qZzK5KhwSs/0.jpg)](http://www.youtube.com/watch?v=-qZzK5KhwSs)
```
will be rendered to:  
[![UC3M](http://img.youtube.com/vi/-qZzK5KhwSs/0.jpg)](http://www.youtube.com/watch?v=-qZzK5KhwSs)

## List

Here are several ways to write ordered lists and unordered lists:
```
1. Use a number to label an ordered list
    a. Or you could use a letter
        - while an unordered list could start with a minus sign (hyphen)
        + an unordered list with a plus sign
        * an unordered list with an asterisks
            * a tab for a lower level
2. The second ordered list label
```
will be rendered to:

1. Use a number to label an ordered list
    a. Or you could use a letter
        - while an unordered list could start with a minus sign (hyphen)
        + an unordered list with a plus sign
        * an unordered list with an asterisks
            * a tab for a lower level
2. The second ordered list label
    
## Syntax highlighting
In order to insert a code chunk into a `Markdown` file, we use three back-ticks (```) and the language of the code chunk. 
You can specify many programming languages.

### `R` code

```r
library(tensorflow)
sess <- tf$Session()
hello <- tf$constant("Hello, TensorFlow!")
sess$run(hello)
```

Note that, the `Markdown` file does not calculate the output. If you write in `R`, you are better with `R Markdown` file.

```
> sess$run(hello)
## b'Hello, TensorFlow!'
```

### `Julia` code

```julia
# The comments in Julia are like in R language.
# Print text in console
print("Hello"),   print("Goodbye")	# to print without a line break.
println("Hello"), println("Goodbye")	# to print with line break.
println("a") # it prints character 'a'
println(a)   # it prints the value of the variable 'a'.
```

### `Python` code

```python
s = "Python syntax highlighting"
print s
```

### `C++` code

```cpp
#include <iostream>
using namespace std;

int main() 
{
    cout << "Hello, World!";
    return 0;
}
```

### `Matlab` code

```Matlab
n = input('Enter a number:');
for sentence = n:1
   n = fprintf('%d. Hello world!', n);
    disp(n:1)
end
```

## Math expressions

The syntax of math expressions in `Markdown` is similar to that of $\LaTeX$,
for example:
```
$$
X = \begin{bmatrix}1 & x_{1}\\
1 & x_{2}\\
1 & x_{3}
\end{bmatrix}
$$
```
would become

$$X = \begin{bmatrix}1 & x_{1}\\
1 & x_{2}\\
1 & x_{3}
\end{bmatrix}$$

You can also use inline math mode as $\LaTeX$ syntax. For example, `$1+1 = 2$` will be rendered to $1+1 = 2$

## Inline HTML

In case that you are familiar with html tag, you can write down the html code in the `Markdown` file.
For example,
```
 <table style="width:100%">
  <tr>
    <th>First Header</th>
    <th>Second Header</th>
  </tr>
  <tr>
    <td>Content from cell 1</td>
    <td>Content from cell 2</td>
  </tr>
  <tr>
    <td>Content in the first column</td>
    <td>Content in the second column</td>
  </tr>
</table> 
```

will be rendered to: 

First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column

## Examples

Some blog post examples that contributors had written for Coding Club Uc3m:

a. [An Introduction to the Julia language](https://raw.githubusercontent.com/CodingClubUC3M/codingclubuc3m.github.io/master/_posts/2018-05-23-Introduction-Julia.md)
b. [Useful one-function R packages, big data solutions, and a message from Yoda](https://raw.githubusercontent.com/CodingClubUC3M/codingclubuc3m.github.io/master/rmd/2018-05-10-misc-R-function.Rmd)

## Reference

1. [Markdown cheatsheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)
2. [Markdown syntax](https://bookdown.org/yihui/bookdown/markdown-syntax.html)

## Credits

The document is proposed by [Hoang Nguyen](https://hoanguc3m.github.io) and [Eduardo García-Portugués](https://egarpor.github.io). The material in this document is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).