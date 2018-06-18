---
layout: post 
comments:  true
title: "An Introduction to the Julia language"
author: "David García-Heredia"
date: 2018-05-23
published: true
visible: true
categories: [Julia]
excerpt_seperator: ""
output:
  html_document:
    mathjax:  default
---
[comment]: <> (We advice you to visit https://stackedit.io/ and  compile the markdown file (copy and paste this file into the editor).  Just change the header section above to suit with your talk and ignore the output, it will be used for jekell (the content creator) at https://codingclubuc3m.github.io )

**Abstract**

The first time you read about the ```Julia``` language, the idea that sticks in your mind is "A speed **similar** to ```C```, with a simplicity **similar** to ```MATLAB``` or ```R```". And in that sentence, the key point is the word "similar", because the differences in the language with ```MATLAB``` or ```R``` might be quite stressful when things do not work as expected. This talk is just a summary of ideas and code with which I would have wished to be introduced into this language to avoid some headaches and scary error messages.

## Introduction

In this occasion we will be learning some of the basic stuff to begin programming in [`Julia`](https://julialang.org/), a programming language developed at MIT. This language is getting more and more notorious among the scientific community because, besides being a free language orientated to scientific computation (like `R` or `Octave`), its developers claim to have speed performances similar to `C`, but without its "language complexity".

1. Run it online in [JuliaBox](https://auth.juliacomputing.io/dex/auth?response_type=code&client_id=dev-juliabox&state=5c5584f238e4938173139328a01adce8&redirect_uri=https%3A%2F%2Fwww.juliabox.com%2Fauth%2Flogin&nonce=a01cca2216badb2d2a43940cead5a59f&scope=openid%20email%20profile%20offline_access).

2. Execute it on the interpreter that can be download from the official [website](<https://julialang.org/>). When using this second option, it is also recommended to install the IDE [extension](<http://junolab.org/>).

Now that this is clear, let's [start](https://github.com/CodingClubUC3M/codingclubuc3m.github.io/blob/master/scripts/JuliaIntro.ipynb)!

## 1 Comments & strings

One of the most important things when programming is to add comments to the code we write. In `Julia`, comments work as follows:

```julia
# The comments in Julia are like in R language.
```

```julia
#=
However, we also have the possibility of adding a multi-line comments
using the syntax shown here.
=#
```

Another important feature, especially when working with input and output files, is working with strings. In the code below we show some basic operations with them.

```julia
# Print text in console
print("Hello"),   print("Goodbye")	# to print without a line break.
println("Hello"), println("Goodbye")	# to print with line break.
println("a") # it prints character 'a'
println(a)   # it prints the value of the variable 'a'.
```

## 2 Algebra

In any language, particularly in the interpreted ones like `R`, `Matlab` or `Julia`, algebra is one of the most used features. That is why we will start learning this part of the language.

### 2.1 Working with numbers

#### 2.1.1 Basic operations

As can be appreciated in the code below, the operations in `Julia` are like in other languages. However, we highly two important features:

* The multiplication of a number by a variable does not require the multiplication symbol.
* Operators with direct assignation are defined and should be preferred due to efficiency reasons (see in the code).

```julia
# Basics
a = 3;        # ';' does not print the result in the console.
b = 8a + a/3; # pay attention to the multiplication.
c = sqrt(b);
d = 5^4;
max(a, d)
min(a, d)     # when working with vectors the syntax changes to maximum y minimum!!!
```

## 3 References
An important part of the content/ideas of this document come from:

* The official [documentation](https://docs.julialang.org/en/release-0.6/index.html).
* Examples from [JuliaBox](https://auth.juliacomputing.io/dex/auth?response_type=code&client_id=dev-juliabox&state=5c5584f238e4938173139328a01adce8&redirect_uri=https%3A%2F%2Fwww.juliabox.com%2Fauth%2Flogin&nonce=a01cca2216badb2d2a43940cead5a59f&scope=openid%20email%20profile%20offline_access).
* The website [LearnXinYminutes](https://learnxinyminutes.com/docs/julia/).

## 4  Markdown Cheatsheet
===================

- - - - 

# Heading 1 #

    Markup :  # Heading 1 #

    -OR-

    Markup :  ============= (below H1 text)

## Heading 2 ##

    Markup :  ## Heading 2 ##

    -OR-

    Markup: --------------- (below H2 text)

### Heading 3 ###

    Markup :  ### Heading 3 ###

#### Heading 4 ####

    Markup :  #### Heading 4 ####


Common text

    Markup :  Common text

_Emphasized text_

    Markup :  _Emphasized text_ or *Emphasized text*

~~Strikethrough text~~

    Markup :  ~~Strikethrough text~~

__Strong text__

    Markup :  __Strong text__ or **Strong text**

___Strong emphasized text___

    Markup :  ___Strong emphasized text___ or ***Strong emphasized text***

[Named Link](http://www.google.fr/) and http://www.google.fr/ or <http://example.com/>

    Markup :  [Named Link](http://www.google.fr/) and http://www.google.fr/ or <http://example.com/>

Table, like this one :

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell

```
First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell
```

`code()`

    Markup :  `code()`

```javascript
    var specificLanguage_code = 
    {
        "data": {
            "lookedUpPlatform": 1,
            "query": "Kasabian+Test+Transmission",
            "lookedUpItem": {
                "name": "Test Transmission",
                "artist": "Kasabian",
                "album": "Kasabian",
                "picture": null,
                "link": "http://open.spotify.com/track/5jhJur5n4fasblLSCOcrTp"
            }
        }
    }
```

    Markup : ```javascript
             ```

* Bullet list
    * Nested bullet
        * Sub-nested bullet etc
* Bullet list item 2

~~~
 Markup : * Bullet list
              * Nested bullet
                  * Sub-nested bullet etc
          * Bullet list item 2
~~~

1. A numbered list
    1. A nested numbered list
    2. Which is numbered
2. Which is numbered

~~~
 Markup : 1. A numbered list
              1. A nested numbered list
              2. Which is numbered
          2. Which is numbered
~~~

- [ ] An uncompleted task
- [x] A completed task

~~~
 Markup : - [ ] An uncompleted task
          - [x] A completed task
~~~

> Blockquote
>> Nested blockquote

    Markup :  > Blockquote
              >> Nested Blockquote

_Horizontal line :_
- - - -

    Markup :  - - - -

_Image with alt :_

![picture alt](http://www.brightlightpictures.com/assets/images/portfolio/thethaw_header.jpg "Title is optional")

    Markup : ![picture alt](http://www.brightlightpictures.com/assets/images/portfolio/thethaw_header.jpg "Title is optional")

Foldable text:

<details>
  <summary>Title 1</summary>
  <p>Content 1 Content 1 Content 1 Content 1 Content 1</p>
</details>
<details>
  <summary>Title 2</summary>
  <p>Content 2 Content 2 Content 2 Content 2 Content 2</p>
</details>

    Markup : <details>
               <summary>Title 1</summary>
               <p>Content 1 Content 1 Content 1 Content 1 Content 1</p>
             </details>

Hotkey:

<kbd>⌘F</kbd>

<kbd>⇧⌘F</kbd>

    Markup : <kbd>⌘F</kbd>

Hotkey list:

| Key | Symbol |
| --- | --- |
| Option | ⌥ |
| Control | ⌃ |
| Command | ⌘ |
| Shift | ⇧ |
| Caps Lock | ⇪ |
| Tab | ⇥ |
| Esc | ⎋ |
| Power | ⌽ |
| Return | ↩ |
| Delete | ⌫ |
| Up | ↑ |
| Down | ↓ |
| Left | ← |
| Right | → |

Emoji:

:exclamation: Use emoji icons to enhance text. :+1:  Look up emoji codes at [emoji-cheat-sheet.com](http://emoji-cheat-sheet.com/)

    Markup : Code appears between colons :EMOJICODE:
