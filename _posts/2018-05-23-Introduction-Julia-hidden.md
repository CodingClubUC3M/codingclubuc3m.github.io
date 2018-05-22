---
layout: post
comments:  true
title: "An Introduction to the Julia Language"
author: "David García-Heredia"
date: 2018-05-23 20:30:00
published: true
visible: false
categories: [Julia]
excerpt_seperator: ""
output:
  html_document:
    mathjax:  default
---

## Intro.
In this occasion we will be learning some of the basic stuff to begin programming in [`Julia`](https://julialang.org/), a programming language developed at MIT. This language is getting more and more notorious among the scientific community because, besides being a free language orientated to scientific computation (like `R` or `Octave`), its developers claim to have speed performances similar to `C`, but without its "language complexity".

Nevertheless, when starting with this language, sometimes there might arise errors in the code that are difficult to read/solve, so the task of programming can become quite annoying. To avoid them and, more important, to learn how to solve them, it is why we make this introduction to the `Julia` language.

But first things first. Before starting programming, we need where to run our code. For that we have two possibilities: 1) Run it online in JuliaBox, or 2) Execute it on the interpreter that can be download from the official website (<https://julialang.org/>). When using this second option, it is also recommended to install the IDE extension (<http://junolab.org/>).

Now that this is clear, let's [start](https://github.com/CodingClubUC3M/codingclubuc3m.github.io/blob/master/scripts/JuliaIntro.ipynb)!

## 1 Comments & Strings.

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

```julia
# Strings
s = "this is a string"
s[2] # An string is an array of characters, so we can access to each element.
     # This is helpful when reading info contained in strings.

# Concatenating strings
intro = "Hello, my name is"
name  = "David"
s = "$intro $name" # we use $ symbol to concatenate the value of a variable
	 	   # inside a string.
```

```julia
# A couple of useful functions:
search("Goodbye",    'e') # it gives us the position of letter 'e' in the word Goodbye
search("Goodbye",  "dby") # it gives us the range of string "dby" in the word Goodbye
contains("Goodbye", "oo") # it returns true because the string "oo" is in Goodbye
```

In case we want to convert a string into a number, we have the following function:
```julia
# Convert a string to a number.
a = parse(Int, "1234") # we first indicate the type (e.g.: integer), and then the number.
a = parse(Float64, "1234.35")
```

Question: which are the outputs of this code?

```julia
search("Goodbye", 'i') 	
search("Goodbye", "dbh")
a = parse(Int, "1234.35") # here the error is because we are saying that we have
                          # an integer when it is not.
```

## 2 Algebra.

In any language, particularly in the interpreted ones like `R`, `Matlab` or `Julia`, algebra is one of the most used features. That is why we will start learning this part of the language.

### 2.1 Working with numbers.

#### 2.1.1 Basic operations.

As can be appreciated in the code below, the operations in `Julia` are like in other languages. However, we highly two important features:

* The multiplication of a number by a variable does not require the multiplication symbol.
* Operators with direct assignation are defined and should be preferred due to efficiency reasons (see in the code).

```julia
# Basics
a = 3;        # ';' does not print the result in the console.
b = 8a + a/3; # pay attention to the multiplication.
c = sqrt(b);
d = 5^4;
max(a,d)
min(a,d) # when working with vectors the syntax changes to maximum y minimum!!!

# Operators with direct assignation: really important!!!
a = 9;
b = 7;
a += b; # instead of a = a + b;
a -= b; # instead of a = a - b;
a *= b; # instead of a = a * b;
a /= b; # instead of a = a/b;
```

#### 2.1.2 Types of divisions and rational numbers.

In some occasions we might be interested in computing the remainder of a division or working with rational numbers. For that, we have the following commands in `Julia`:

```julia
# Division:
5/2 	   # common division.
div(5,2)   # quotient of the division.
5%2 	   # remainder of the division.

# Rational numbers
2//3 	    # it creates the number 2/3.
num(2//3)   # we obtain the numerator.
dem(2//3)   # we obtain the denominator.
```

#### 2.1.3 Infinite precision.

`Julia`, as other languages, has the possibility of working with infinite precision. However, the use of this feature, unless it is completely necessary, is highly discouraged due to efficiency reasons. Nevertheless, here is a block of code showing its use:

```julia
# We check the type of the number 34
typeof(34)
# Now we see which is the largest number to be held by that type.
typemax(Int)
# If we try to save a larger number, we obtain a result without any sense.
b = 2*typemax(Int)

# Using infinite precision...
b = parse(BigInt, "80");
b *= typemax(Int) # Now we do not obtain any error.

# Other examples:
big(2)^500
factorial(big(45))
```


### 2.2 Working with vectors.

#### 2.2.1 Creating one-dimensional arrays.

Here there are some examples of how to create arrays. In the code you can see that in `Julia`, opposite to other languages like `C++`, the first position in any array is 1 and not 0.

```julia
<<<<<<< HEAD
a = [1,47,7,4,55]   # It is important to use the comma separator to create a column vector.

a[1]                # We can access to each of the elements as in other languages.
=======
a = [1,47,7,4,55] # Use the comma separator to create a column vector!

a[1] 		  # We can access each of the elements as in other languages.
>>>>>>> 5a37e4bfe3be71095f6062843ef7507079fa0b6b
a[3]
a[end]
a[2:4]

a = ones(4) 	  # vector of 1's
a = zeros(5)	  # vector of 0's

a = rand(3) 	  # 3 numbers from a uniform (0,1)
b = rand(1:5,3)   # 3 numbers from a discrete uniform [1,5]

v = [a; b] 	  # Concatenating two vectors. Notice that we use ';' no ','.
```

There are other possibilities (no so used, but interesting) for creating an array such as:

```julia
v = [1,2,3];
repeat(v,inner=[2]) 	       # It repeats 2 times each element from 'v'
repeat(v,outer=[3]) 	       # It repeats 3 times vector 'v'
repeat(v,inner=[3],outer=[2])  # It repeats each element from v 3 times and then,
                               # it repeats that result 2 times.
```

When working with vectors, `Julia` creates references (a pointer to a part of the memory), so we must be cautious to avoid errors as the one shown below:

```julia
original = [1,2,3,4,5,6]
v = original # We are creating a reference no copying it!
v[1] = 22    # So, if we modify the first element in any reference...
original     # all the references notice it!

# To copy an array we have to use an specific function.
original = [1,2,3,4,5,6]
v = copy(original)
v [1] = 22
original # Now the original vector remains unchanged.
```

#### 2.2.2 Basic operations.

Now we list some code that is used when working with arrays. For instance, the next block is algebra-wise:

```julia
v = [1,4,7]
rand(v,6)   # Sampling from a vector

a' 	    # transpose vector
norm(a,2)   # norm p = 2
b = 2a
a.*b 	    # multiplication of the i-th element from 'a'  with the i-th element from b
vecdot(a,b) # dot product.

maximum(a)
minimum(b)    	
```

The block of code listed below is programming-oriented, i.e.: it shows functions to manipulate the elements of an array. It is important to notice that if we use a function in `Julia` which has the exclamation symbol (e.g.: function!(argument)), the argument is modified. This notation is the way that `Julia` uses to indicate that the argument is passed by reference.

```julia
a = rand(1:9,10);

sort(a)  # We sort the elements of a vector.
a        # However, the vector remains unchanged.
sort!(a) # If we used the function defined with '!'...
a        # Now the original vector has been modified!!!

push!(a,3)     # It sets a 3 at the end of vector a.
append!(a,b)   # It combines a and b in vector a.
pop!(b)        # It deletes the last element from b.
shift!(a)      # It deletes the first element from a.
unshift!(a,7)  # It adds a 7 at the beginning of vector a.
splice!(a,2)   # It deletes the 2nd element of a.
in(1, a)       # It checks if number 1 is in vector a.

pos = find(a .== 2) # It shows all the positions where 'a' has a 2.  
                    # Notice the '.' before the operator ==
```

Not all the functions have a version with '!'. This implies that if a function f(x), has not the f!(x) version, writing f!(x) will produce an error.

#### 2.2.3 A range is not a vector!

A really important characteristic in the `Julia` language is that there exists a distinction between a range and an array. It is pretty common to create vectors in `Matlab` or `R` using the notation *a:b*, where 'a' is the beginning point of the array and 'b' the end one. Julia does not consider this an array, but a range, i.e.: a type in which we only have two parameters 'a' and 'b'. This is really useful because it saves a lot of memory (if there is no necessity of creating the array, as happens in for loops, Julia does not create it).

```julia
range1 = 1:1000
typeof(range1)
# If we need to actually create the array of the range, we can:
array1 = collect(rango1); # Now we have an array as in R or Matlab.
```
An example of this is when creating *N* points equally spaced.

```julia
v = linspace(1,20,15) # v is a range not a vector. 15 is the number of points
collect(v) 	      # Again, we can transform it.
```



### 2.3 Working with matrices.

#### 2.3.1 Creating two-dimensional arrays.

There exist different ways to create multi-dimensional arrays. Now we list some code to do it.

```julia
A = [1 2 3 4;
     5 6 7 8;
     9 4 5 9]

A = rand(3,3)
B = rand(2,3)

eye(4)
ones(2,3)
zeros(4,4) # zeros(Int8, 4, 4); Specifying a particular type (e.g.: Int8)
           # we can save a lot of memory when the default type (Float64)
           # is not needed.
```

Related to the last comment in the code, we can also transform types to save memory once the matrix is already created (check the code below). However, it is recommended to avoid the transformation if possible and create the matrix directly with the type we want.

```julia
K = zeros(5,5)                # We create a matrix in Float64
K = convert(Array{Int8,2},K)  # Using the function 'convert' we transform it.

# Here there are some example using the function convert:
x = 7.0;
convert(Int8, x) # If we had, for example, 7.2, it would produce an error.
                 # When we have real numbers, we first need to round them
                 # if we want to create integers (see next code)
		 
x = round(rand(6)*10);
convert(Array{Int8,1}, x) # we write 1 because we have one-dimensional array.

# With function 'round' we can also make transformations:
K = round(Int8, K)
```

When creating matrices, an interesting feature of `Julia` is that it has the possibility of creating special matrices (e.g.: symmetric). Providing `Julia` with that information makes possible to solve larger problems than without specifying it. We now show a piece of code with a particular example, but much more can be found on the official website (e.g.: working with sparse matrices).


```julia
dl = [1; 2; 3]
du = [4; 5; 6]
d  = [7; 8; 9; 0]
M2 = Tridiagonal(dl, d, du) # We create a tridiagonal matrix.
typeof(M2)
```

#### 2.3.2 Basic operations.

Let's now go over some of the basic operations when working with matrices.

```julia
B*A	     # Matrix product
m = diag(A) 	
A*m 	     # Product of a matrix by a vector
norm(A,2)    # Matrix norm (in this case Frobenius norm).
det(A)       # Determinant of the matrix.

numRows, numCols = size(A) # getting the dimensions of the matrix.

x = A\y      # solving a linear system of equations.

d = eig(A)   # It saves in 'd' the eigenvalues and eigenvectors of A
d[1]	     # We access to the first element (eigenvalues)
d[2]	     # We access to the first element (eigenvectors)

autoVal, autoVec = eig(A) # I can save them separately from the beginning.
autoVal
autoVec

s = svd(A) # Singular-value decomposition. Here we have three elements s[1], s[2], s[3]

# Check eigs and svds for Lanczos and Arnoldi iterations.

lu(A) # PLU decomposition
qr(A) # QR decomposition.

# Other more efficient functions:
d = eigfact(A) # It provides an struct.
# We use methods to access to each of the elements:
eigvals(d)
eigvecs(d)
# It would also be possible to use d.values and d.vector

s = svdfact(A) # Again it provides an struct.
```

## 3 Programming sentences.

### 3.1 Conditionals and loops.

Apart from algebra, other of the most important things when programming is the use of conditionals as well as for and while loops. The code presented in this section shows how this works in `Julia`.

#### 3.1.1 Conditionals.

Notice that brackets are not required, so do not use them (it is more efficient).

```julia
x = 7;
if x < 0
  println("negative")
elseif x > 0
  println("positive")
else
  println("zero")
end

a = -2;
if x < 0 && a < 0       # an AND condition
  println("both are negative")
elseif x > 0 || a > 0   # an OR condition
  println("at least one is positive")
end

```


#### 3.1.2 For loops.

There are different ways of working with a for loop in `Julia`. First, we introduce some examples similar to other languages like `R` o `Matlab`.

```julia
# Classic form 1: using a range
x = 0;
for i = 1:500  
  x+=1;
end

# Classic form 2: using a vector
for i in [1,4,6]
  println(i)
end
```

Another interesting way of using a for loop is with strings, because it allows us, for example, to automatize the reading of files.

```julia
# Classic form 3: using a vector of strings
for s in ["madrid","valencia","bilbao"]
  println(s, " is a city")
end
```
A more sophisticated way of using for loops is related to the creation of arrays. As can be seen in the next code, we are creating a 2-dimensional array in which each entry is the sum of the indexes.

```julia
<<<<<<< HEAD
[i+j for i=1:2, j=1:3]  # Obviously, we can add more dimensions
                        # e.g.: i=1:2, j=1:3, k=1:6, d=1:4,....
=======
[i+j for i=1:2, j=1:3] # Obviously, we can add more dimensions
		       # e.g.: i=1:2, j=1:3, k=1:6, d=1:4,....
>>>>>>> 5a37e4bfe3be71095f6062843ef7507079fa0b6b
```

Instead of using the sum, we can also employ our own functions as it shown below (we will see later on how to create functions).

```julia
function f(x,y) return x*y end

[f(i,j) for i=1:2, j=1:3] # we use our own function.
```

To conclude the part of using for loops, we show an interesting feature of the `Julia` language that allows us to write code in a more compact way.

```julia
A = zeros(5,7)

for i=1:5
  for j=1:7
    A[i,j] = i+j; # Notice that this is equal to [i+j for i=1:5, j=1:7]
  end
end

# The previous operation is equivalent to:
B = zeros(5,7)
for i=1:5, j=1:7 # We are writing all the loops in one line.
	B[i,j] = i+j;
end
```

#### 3.1.3 While loops.

```julia
i=1
while i<=5
  println(i)
  i+=1
end
```

#### 3.1.4 Sentences break and continue.

Also related to for and while loops, there are the sentences *continue* and *break*. Now we show a couple of example about how to use them.

```julia
totalOddsNum = 0;
for i=1:10
  if i%2 == 0   # the number is even
    continue;   # I do not continue the rest of the loop and jump to the next step.
  end
  totalOddsNum +=1;
end

totalSum = 0;
for i=1:1000
  if totalSum == 1275 # A condition in which we want to scape from the for loop
    break;
  end
  totalSum += i;
end
```

#### 3.1.5 Speed using for loops.

Opposite to other languages, in Julia for loops are not discouraged. To measure the time employed in an operation and the number of allocations done, we write '@time' before the code.

```julia
@time sum(1:2000) 

a = 0;
@time for i=1:2000
  a+=i;
end
```

### 3.2 Functions.

Now let's see how we define functions in `Julia`. We will learn how to make the return of elements, how to evaluate several arguments for different scenarios at once and how to import functions from other files.

The syntax of a function is shown in the next code, where 'function' is a keyword, 'fsum' how we name our function, and '(x,y)' the arguments that have our function.

```julia
function fsum(x,y)
  return x+y # we return the sum of the two elements
end

# We test our function
fsum(2,3)
```

Sometimes it might be interesting to use the following idea of establishing default values:

```julia
function fsum2(x, y = 1)
  return x+y
end

fsum2(2)  # When we do not provide a second argument, it just add y = 1.
fsum2(2,8)
```

`Julia`, as other languages, has the option of returning several results. Check the following code to see how this is done.

```julia
function f_several_returns(x,y)
  return x+y, x*y # Notice the comma to separate returns.
end

f_several_returns(2,4)
s,p = f_several_returns(3,5); # we save the sum in 's' and the product in 'p'
s
p
```

Another interesting idea is the used of the function 'map', a predefine function which allows evaluating any function 'f' in several arguments simultaneously.

```julia
function f(x)
  x^2
end
map(f, [1,2,3]) # we evaluate 3 different inputs in 'f'.

# If the function is simple, there is no necessity of implementing it.
map((x) -> x^2, [1,2,3,7])

# Another example, but with several arguments
function f2(x,y)
  2(x+y)
end
map(f2, [1,2,3], [10,11,12])
```

Notice that `Julia`, as far as the code is coherent, does not ask to specify if the argument is a number, a vector or another element.

```julia
function fvect(v) # I can pass a vector or a Matrix
  v +=1;
  return v
end

v1 = [1,2,3,4]
fvect(v1)
v1 # Notice that v1 remains unchanged. If we want it to be modified: v1 = fvect(v1)
A = ones(3,3)
fvect(A)
```

We must pay attention when the variable that we pass as an argument is going to be modified. For instance, in the previous code, we saw that the variable 'v1' remained equal after the operation. An example in which this does not happen is the next one:

```julia
function fmatriz!(X)
  dimF, dimC = size(X)
  for i=1:dimF, j=1:dimC
    X[i,j] = i+j;
  end
end

A = zeros(2,3)
fmatriz!(A);
A
```

The exclamation symbol in the name of the function is for us to remember (in the future) that this code modifies the variable.

Finally, to conclude this section about functions, we are going to learn how to import a file in which we have several functions that we want to use in a program.

```julia
include("FileWithFunctions.jl")

# When  using Parallel Computing, we include the functions in all the processors using:
@everywhere include("FileWithFunctions.jl")
```


### 3.3 Other programming ideas.

In addition to the commands presented before, there are some other ideas that are good to know and that we introduce in this section.

#### 3.3.1 Dictionaries.

In order to carry out searching operations, dictionaries provide a fast way to do it. Let see how we work with them in `Julia`.

```julia
# The way of creating a dictionary is:  Dict(key1 => value1, key2 => value2, ...)
months = Dict("January" => 31, "February" => 28, "March" => 31)


# To check the existence of elements in the dictionary, we use:
haskey(months, "March")       # To see if the dictionary contains a key
in(("January"  => 55),months) # To check for the existence of a key/value pair:
in(("February" => 28),months) # To check for the existence of a key/value pair:

# We access elements by the key.
months["January"]
months["May"] # May is not in the dictionary so we obtain an error.

# To avoid the error, we can use the following function which provides
# a fail-safe default value if there's no value for that particular key
get(months, "May", 0) # this is useful when using conditionals.

# Dictionaries, opposite to arrays, are not sequential containers, that is, the
# following idea does not make sense (and produce an error)
months[1]

# We can add and delete elements of the dictionary
months["April"] = 30;
months["May"]   = 31;
months
delete!(months, "February") # to delete.


# We can obtain an array of the keys and the values, which can be used in
# for loops (recall that we cannot access elements as in arrays).
values(months)
keys(months)

for i in keys(months)
  println(months[i])
end

for i in months
  println(i)
end
```

Dictionaries can be applied in different situations, for example, when modeling an optimization problem. An intelligent way of working with constraints is:

```julia
# constraints = Dict("NameConst1" => equation1, "NameConst2" => equation2, ...)
```

Where equation can be a type as it is shown in the subsection below.

#### 3.3.2 Defining your own types.

Now we show how can you define your own types in Julia.

```julia
type Person
  age::Int
  name::AbstractString
  Salary::Float64
end
s = 2550.58
p1 = Person(32, "Julian", s)
p1.name

vectorPeople = Person[]; # We can create an array of that type.
push!(vectorPeople, Person(21, "Pedro", 554)); # and add elements
push!(vectorPeople, Person(25, "Maria", 1554));
vectorPeople
# We can modify the fields that we need
newSalary = 5000.0;
vectorPeople[end].Salary = newSalary;
```


#### 3.3.3 Packages.

Besides the default functions that are available in Julia, the user can download packages developed by the community as in R. Here we list some commands to install and work with packages.

```julia
Pkg.add("NameOfPackage") # This command downloads the package.
Pkg.update() 		 # It updates the packages installed
Pkg.installed() 	 # It lists the packages installed
using NombreDelPaquete 	 # We load the package we want to use.
```

Now we will some examples to work with the package 'DataFrames' (see more info in <https://juliadata.github.io/DataFrames.jl/stable/>). Related to this, packages about Machine Learning or Big data (check JuliaDB) are available.

```julia
using  DataFrames # We should have installed the package before
using  RDatasets

iris = dataset("datasets", "iris")
head(iris)
tail(iris)

names(iris)

iris[3]        # It gives us the 3rd column.
iris[1,3]      # It gives us the first element of the 3rd column.
iris[:Species] # It gives me the column named 'Species'


sort!(iris, cols = [:SepalWidth, :SepalLength]);
sort!(iris, cols = (:Species, :SepalLength, :SepalWidth),
                    rev = (true, false, false)); # rev = true -> from Z to A.

unique(iris[:Species])


df = DataFrame(a = repeat([1, 2, 3, 4], outer=[2]),
               b = repeat([2, 1], outer=[4]),
               c = randn(8))
colwise(sum, df) # It applies the function to each column.
		 # Be aware of applying a function to all columns when having
		 # heterogeneous data (e.g.: strings, integers, NA...)
		 
colwise([sum, length], df)
colwise([minimum, maximum], df)

# We can use our own functions:
function fPrueba (x) sum(x) end
colwise(fPrueba, df)

# If all the elements are numbers (e.g.: in a matrix of constraints),
# it might be interesting to transform the DataFrame to a matrix.
A = Array(iris);
A[1:5,:]

Datos = readtable("NameOfFile.csv"); # Read the data.
writetable("NameOfFile.csv", df)     # Export the data.

```


#### 3.3.4 Tips.

To end this introduction, we expose some code that can be useful when programming in Julia.

```julia
# In Julia there is no function to delete variables, and sometimes this is needed
# to save a lot of memory, (e.g.: you have a matrix M of size 1E6x1E6 what you
# have used, but you don't need anymore). To free memory you do as follows:
M = true; # You transform M to type boolean (which is the less memory consuming).
gc() 	  # You update the system to actually make the transformation.


# These are some commands about the working directory:
homedir() 	# the default working directory
pwd() 		# the current working directory
readdir(pwd()) 	# to see the files of the current working directory

# This is how we change the working directory
route = "$(homedir())/Documents/Folder1/.../FolderK";
cd(route);

# As an advice, if you create a variable that is going to have float values,
# do not initialize it as an integer.
a = 2;
typeof(a) # For Julia this value will be an integer

# The posterior transformation to float values will be inefficient (time consuming).
a /= 3
typeof(a)

# What is correct to do is:
b = 2.0 # Now we are telling Julia that 'b' will take float values.
b /= 3  # Now there is not type transformation.

# To download data from Internet
nm = tempname() # It generates a unique temporary file path.
url = "https://raw.githubusercontent.com/plotly/datasets/master/2014_us_cities.csv"
download(url, nm)
df = readtable(nm)
rm(nm)
```

## 4 References.
An important part of the content/ideas of this document come from:

* The official [documentation](https://docs.julialang.org/en/release-0.6/index.html).
* Examples from [JuliaBox](https://auth.juliacomputing.io/dex/auth?response_type=code&client_id=dev-juliabox&state=5c5584f238e4938173139328a01adce8&redirect_uri=https%3A%2F%2Fwww.juliabox.com%2Fauth%2Flogin&nonce=a01cca2216badb2d2a43940cead5a59f&scope=openid%20email%20profile%20offline_access).
* The website [LearnXinYminutes](https://learnxinyminutes.com/docs/julia/).
