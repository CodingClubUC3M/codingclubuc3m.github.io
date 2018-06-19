---
layout: post
comments:  true
title: "An introduction to Tensorflow"
author: Hoang Nguyen
date: 2018-07-03
published: true
visible: false
categories: [R, tensorflow]
excerpt_seperator: ""
output:
  html_document:
    mathjax:  default
    number_sections: no
    toc: yes
    toc_float:
      collapsed: no
      smooth_scroll: no
    code_folding: show
---



## Introduction 

```Tensorflow``` is a machine learning framework of Google. It is developed by ```Google Brain``` team since 2015 and released publicly in 02.2017. It is now implemented for many applications in machine learning and deep learning. It has ```API``` for ```Python```, ```R```, ```C```. 

```Tensorflow``` is not only used for deep learning. As statistician, there are a lot of features that we can take advantages.

- ```Tensorflow``` = general purpose computing library
- ```Tensorflow``` in ```R``` = Interface to ```tensorflow``` library
- Computations are implemented as input data (tensor/ generalized matrix/ multidimensional array) flow through nodes (mathematical operators) to the output data.

Tensorflow features:

- Reverse-mode auto differentiation.
- Multicore CPU, GPU supports.
- Official ```Python``` API and ```C``` API, third party packages for ```Julia```, ```R```.
- Ecosystem with numbers of machine learning algorithm ```tfestimators```, ```keras```.
- Graphical probabilistic modelling with ```TensorFlow Probability```.
- Monitor and metrics with ```tensorboard```.

![tensorflow](/figure/source/2018-07-03-introduction-tensorflow/pic0.png "Tf framework")

### Install tensorflow in R

I summary the main steps for installing tensorflow package in R. 
For full instruction, please go to:

- [Windows](https://www.tensorflow.org/install/install_windows)
- [Ubuntu](https://www.tensorflow.org/install/install_linux)
- [MacOS](https://www.tensorflow.org/install/install_mac)

#### Windows

1. Install python, pip3 and tensorflow 

a. Download [Python](https://www.python.org/downloads/release/python-354/) and install (Choose add path and install pip3)

b. Open cmd with administration role and execute

{% highlight bash %}
pip3 install --upgrade tensorflow
pip3 install --upgrade tfp-nightly    # depends on tensorflow (CPU-only)
{% endhighlight %}



#### Ubuntu
1. Install python, pip3 and tensorflow 

{% highlight bash %}
sudo apt-get install python3-pip python3-dev
pip3 install tensorflow
pip3 install --upgrade tfp-nightly    # depends on tensorflow (CPU-only)
{% endhighlight %}


#### MacOS

Check pip3 version:

{% highlight bash %}
pip3 -V # for Python 3.n 
{% endhighlight %}

If pip or pip3 8.1 or later is not installed, issue the following commands to install or upgrade:


{% highlight bash %}
sudo easy_install --upgrade pip
sudo easy_install --upgrade six 
pip3 install tensorflow
pip3 install tfp-nightly    # depends on tensorflow (CPU-only)
{% endhighlight %}

2. Install r package tensorflow


{% highlight r %}
install.packages("tensorflow", "reticulate")
tensorflow::install_tensorflow()
{% endhighlight %}

#### Hello tensorflow

Test your installation with this trunk of codes


{% highlight r %}
library(tensorflow)

sess = tf$Session()

hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)
{% endhighlight %}



{% highlight text %}
## b'Hello, TensorFlow!'
{% endhighlight %}



{% highlight r %}
a <- tf$constant(10)
b <- tf$constant(32)
sess$run(a + b)
{% endhighlight %}



{% highlight text %}
## [1] 42
{% endhighlight %}



{% highlight r %}
sess$close()
{% endhighlight %}

If everything works, we are ready to go.


## TensorFlow API from R 

We start with how to declare variable, constant, placeholder in ```tensorflow```.
We assign an object (```sess```) point to ```tf$Session()``` 
and close a session with ```sess$close()```. Here top level API is ```tf``` which provides access to Tensorflow modules.  

There are several ways to evaluate a tensorflow variable. 

- Temporary use ```tf$Session()```

{% highlight r %}
tensor_0D = tf$constant(42, name='tensor_0D')       # Declare a constant 
tensor_0D                                           # Print tensor 
{% endhighlight %}



{% highlight text %}
## Tensor("tensor_0D:0", shape=(), dtype=float32)
{% endhighlight %}



{% highlight r %}
with(tf$Session() %as% sess, {      # temporary use tf$Session()
    sess$run(tensor_0D)             # Get the value of a tensor
})
{% endhighlight %}



{% highlight text %}
## [1] 42
{% endhighlight %}

- ```tf$Session()$run()``` in ```tf$Session()``` 

{% highlight r %}
sess = tf$Session()                 # Start a sesssion with tensorflow

tensor_1D = tf$Variable( c(1,2,3), name='tensor_1D' ) # vector of variables as a place holder
sess$run(tf$global_variables_initializer())   # Initiate the value of tensor_1D
sess$run(tensor_1D)
{% endhighlight %}



{% highlight text %}
## [1] 1 2 3
{% endhighlight %}



{% highlight r %}
sess$close()                # Close a session
{% endhighlight %}

- ```object_name$eval()``` in ```tf$InteractiveSession()``` 

{% highlight r %}
sess <- tf$InteractiveSession()     # An interactive session

tensor_2D = tf$placeholder(tf$float32, c(NULL, 4), name='tensor_2D' ) # Data 2D : (samples, features)
# tensor_2D$initializer$run()             # Initialize tensor_2D

tensor_3D = tf$Variable(tf$ones(c(3,2,2)))         # 3D tensor variable
sess$run(tf$global_variables_initializer())     # Initialize  all variables
tensor_3D$eval()                                # Instead of: sess$run(tensor_3D)
{% endhighlight %}



{% highlight text %}
## , , 1
## 
##      [,1] [,2]
## [1,]    1    1
## [2,]    1    1
## [3,]    1    1
## 
## , , 2
## 
##      [,1] [,2]
## [1,]    1    1
## [2,]    1    1
## [3,]    1    1
{% endhighlight %}



{% highlight r %}
sess$close()                # Close a session
tf$reset_default_graph()
{% endhighlight %}




## Linear regression 

### Gradient descent algorithm
We analyze an example of simple linear regression to see how to use ```tensorflow``` to optimize over a loss function. 
Then we use ```tensorboard``` to monitor the loss function in each iteration. 
For a simple linear regression, we fit a linear function 

$$y = A x + b + \epsilon$$

such that it minimize the distance between the predicted values ($\hat{y_i}$) and the observed values ($y_i$) in term of mean square error.

$$MSE = \frac{1}{n} \sum_{i = 1}^n (y_i - \hat{y}_i)^2$$

In order to illustrate how to solve for this optimization, we use the ```iris``` data. 
We want to define a linear model between ```Petal.Length``` and ```Petal.Width```.
We first create a placeholder (```x_data```, ```y_data```) for (```Petal.Length```, ```Petal.Width```),
Then, we derive the prediction $\hat{y} = A x + b$.


{% highlight r %}
data(iris)              # We model the relationship between Petal.Width and Petal.Length
#head(iris)

sess = tf$Session()

x_data <- tf$placeholder(dtype = "float", 
                         shape = (length(iris$Petal.Length)), 
                         name = "Petal.Length") # Placeholder for Petal.Length
y_data <- tf$placeholder(dtype = "float",
                         shape = (length(iris$Petal.Width)), 
                         name = "Petal.Width") # Placeholder for Petal.Width


A <- tf$Variable(0.0,	name="Coefficient")
b <- tf$Variable(1.0,	name="Intercept")

y_hat <- A * x_data + b
{% endhighlight %}

Secondly, we define a loss function (MSE) and a submodule optimizer ```tf$train$GradientDescentOptimizer```
with a learning rate $\gamma = 0.03$. There are several other submodules such as ```AdagradOptimizer```, ```MomentumOptimizer```, ```RMSPropOptimizer``` which based on the problem of interest. The ```GradientDescentOptimizer``` will update the parameters $A$ and $b$ in each iteration by eg.

$$A_{n+1} = A_{n} - \gamma \nabla MSE(A_n)$$


{% highlight r %}
MSE <- tf$reduce_mean((y_data - y_hat)^2) 

optimizer <- tf$train$GradientDescentOptimizer(0.03)

train <- optimizer$minimize(MSE)
{% endhighlight %}

Finally, fetch data to placeholder using ```feed_dict``` and move paramters along the gradient few thousand times.

{% highlight r %}
sess$run(tf$global_variables_initializer()) # To init all the variables

for (epoch in 1:2000) {
        sess$run(train, feed_dict=dict(x_data=iris$Petal.Length, 
                                       y_data= iris$Petal.Width))
}
cat("Coefficient: ", sess$run(A), "\n Intercept: ", sess$run(b), "\n")
{% endhighlight %}



{% highlight text %}
## Coefficient:  0.4157551 
##  Intercept:  -0.363074
{% endhighlight %}



{% highlight r %}
sess$close()
tf$reset_default_graph()
{% endhighlight %}


{% highlight r %}
# Compare to linear regression
lm(Petal.Width ~ Petal.Length, data = iris)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = Petal.Width ~ Petal.Length, data = iris)
## 
## Coefficients:
##  (Intercept)  Petal.Length  
##      -0.3631        0.4158
{% endhighlight %}

### Monitoring with ```tensorboard```
```tensorboard``` is a metrics module that helps to monitor the learning process. In the complex model, ```tensorboard``` not only visualizes but also debug, optimize tensorflow graph. Most of the codes in this section are inherited from the previous section with few line for adding variables to our watch list.


{% highlight r %}
data(iris)              # We model the relationship between Petal.Width and Petal.Length
#head(iris)

sess = tf$Session()

x_data <- tf$placeholder(dtype = "float", 
                         shape = (length(iris$Petal.Length)), 
                         name = "Petal.Length") # Placeholder for Petal.Length
y_data <- tf$placeholder(dtype = "float",
                         shape = (length(iris$Petal.Width)), 
                         name = "Petal.Width") # Placeholder for Petal.Width


A <- tf$Variable(0.0,	name="Coefficient")
b <- tf$Variable(1.0,	name="Intercept")

y_hat <- A * x_data + b

MSE <- tf$reduce_mean((y_data - y_hat)^2) 
optimizer <- tf$train$GradientDescentOptimizer(0.03)
train <- optimizer$minimize(MSE)

###########################################
# Add variable to summary #
###########################################
MSE_hist <- tf$summary$scalar("MSE", MSE)           # save all values of MSE 
A_hist <- tf$summary$scalar("Coefficient", A)       
b_hist <- tf$summary$scalar("Intercept", b)         
merged <- tf$summary$merge_all()        # Merges all summaries collected in the default graph.

train_writer <- tf$summary$FileWriter(logdir="/home/hoanguc3m/logs")  
train_writer$add_graph(sess$graph)              # add a graph structure

###########################################
# End of summary #
###########################################

sess$run(tf$global_variables_initializer())


for (epoch in 1:2000) {
    result <- sess$run(list(merged, train), # remenber to run merged
                       feed_dict=dict(x_data=iris$Petal.Length, 
                                      y_data= iris$Petal.Width))
    summary <- result[[1]]          # extract the summary result of merged 
    train_writer$add_summary(summary, epoch) # write summary to disk
}

# cat("Coefficient: ", sess$run(A), "\n Intercept: ", sess$run(b), "\n")
sess$close()
tf$reset_default_graph()
{% endhighlight %}


{% highlight r %}
tensorboard(log_dir = "/home/hoanguc3m/logs") # Play with tensorboard
{% endhighlight %}

Here are few thing that we summary in ```tensorboard```
![tensor_board](/figure/source/2018-07-03-introduction-tensorflow/pic1.jpg "Scalar")

![tensor_board](/figure/source/2018-07-03-introduction-tensorflow/pic2.jpg "Graph")

## Maximum likelihood with ```tensorflow```

Tensorflow contains a large collection of probability distributions. ```tf$contrib$distributions``` provides some common distribution such as Bernoulli, binomial, uniform, normal, student,... The interesting feature of these function is automatic differentiation. Thus, we just need to sepecify the likelihood function of the model and let ```tensorflow``` takes care of the likelihood. ```tensorflow``` uses reserve mode automatic differentiation.

In general, we have a workflow 

- Define the graph (variables, placeholders for data)
- The flow of the graph and operation on graph.
- Calculate the loss function and choose the optim engine. 
- Graph is executed 


{% highlight r %}
data(iris)              # We model the relationship between Petal.Width and Petal.Length
#head(iris)

sess = tf$Session()

x_data <- tf$placeholder(dtype = "float", 
                         shape = (length(iris$Petal.Length)), 
                         name = "Petal.Length") # Placeholder for Petal.Length
y_data <- tf$placeholder(dtype = "float",
                         shape = (length(iris$Petal.Width)), 
                         name = "Petal.Width") # Placeholder for Petal.Width


A <- tf$Variable(0.0,	name="Coefficient")
b <- tf$Variable(1.0,	name="Intercept")


sigma <- tf$Variable(1,	name="Sigma")

y_hat <- A * x_data + b

#############################################################
# MLE #
#############################################################

# define a Gaussian distribution with mean = y_hat and sd = sigma
gaussian_dist = tf$contrib$distributions$Normal(loc=y_hat, scale=sigma)
# log_likelihood (y_data | A,b,sigma)
log_prob = gaussian_dist$log_prob(value=y_data)
# negative_log_likelihood (y_data | A,b,sigma)
neg_log_likelihood = -1.0 * tf$reduce_sum(log_prob)

# gradient of neg_log_likelihood wrt (A,b,sigma)
grad = tf$gradients(neg_log_likelihood,c(A, b, sigma))


# optimizer
optimizer = tf$train$AdamOptimizer(learning_rate=0.0001)
train_op = optimizer$minimize(loss=neg_log_likelihood)

#############################################################
# End of MLE #
#############################################################

sess$run(tf$global_variables_initializer())

for (epoch in 1:2000) {
    result <- sess$run(list(train_op,            # Min neg_log_likelihood
                            neg_log_likelihood,  # neg_log_likelihood
                            grad),               # Gradient
                       feed_dict=dict(x_data=iris$Petal.Length, 
                                      y_data= iris$Petal.Width))
}

cat("Coefficient: ", sess$run(A), "\n Intercept: ", sess$run(b), "\n Sigma: ", sess$run(sigma))
{% endhighlight %}



{% highlight text %}
## Coefficient:  0.1379263 
##  Intercept:  0.8474575 
##  Sigma:  0.7824487
{% endhighlight %}



{% highlight r %}
cat("Gradient wrt: d.A ", result[[3]][[1]], "\n d.b: ", result[[3]][[2]], "\n d.sigma: ", result[[3]][[3]], " \n")
{% endhighlight %}



{% highlight text %}
## Gradient wrt: d.A  -57.50495 
##  d.b:  40.762 
##  d.sigma:  95.03106
{% endhighlight %}



{% highlight r %}
sess$close()
tf$reset_default_graph()
{% endhighlight %}


## Bayesian with ```tensorflow_probability```
```tensorflow_probability``` contains the most recent innovated Bayesian inference algorithm used in machine learning and deep learning. ```tensorflow``` package in R does not support for API to ```tensorflow_probability``` yet, so we can run python code through ```reticulate``` package who helps to connect R and python.
In this section, we will work with a graphical probabilistic model using ```tfp$edward2``` and making inference with variational inference ```tfp.vi```


{% highlight r %}
# For Ubuntu due to both python2 and python3
# Sys.setenv(TENSORFLOW_PYTHON="/usr/bin/python3")
# use_python("/usr/bin/python3", required = T)
    # reticulate::use_python("/opt/local/tools/python/Python-3.6.5/bin/python3.6")
library(reticulate)
library(tensorflow)


# Import tensorflow probability module
tfp <- import( module = "tensorflow_probability" )
ed <- tfp$edward2
sess = tf$Session()

# Data 
data(iris)              # We model the relationship between Petal.Width and Petal.Length
x_data <- tf$placeholder(dtype = "float", 
                         shape = (length(iris$Petal.Length)), 
                         name = "Petal.Length") # Placeholder for Petal.Length
y_data <- tf$placeholder(dtype = "float",
                         shape = (length(iris$Petal.Width)), 
                         name = "Petal.Width") # Placeholder for Petal.Width

# Define a prior
A <- ed$Normal(loc = 0, scale = 10, name="Coefficient")
b <- ed$Normal(loc = 0, scale = 10, name="Intercept")
sigma <- ed$InverseGamma( concentration= 1, rate = 1 , name="Sigma") 

# Define parameter transformations
mu <- A * x_data + b

# Define likelihood
y <- ed$Normal(loc=mu, scale=sigma, name="Petal.Width")

# Define posterior
log_joint <- ed$make_log_joint_fn(y)
target_log_prob_fn <- function(theta){
    return( log_joint(A = theta[1], b = theta[2], sigma = theta[3]) )
}

sess$run(tf$global_variables_initializer())


# MCMC setup
num_results = 5000L
num_burnin_steps = 3000L

kernel_results <- tfp$mcmc$sample_chain(
                                    num_results=num_results,
                                    num_burnin_steps=num_burnin_steps,
                                    current_state = tf$zeros(shape = 3),
                                    kernel = tfp$mcmc$HamiltonianMonteCarlo(
                                                target_log_prob_fn=target_log_prob_fn,
                                                step_size=0.4,
                                                num_leapfrog_steps=3))



sess$run(tf$global_variables_initializer())
result <- sess$run(  )
{% endhighlight %}

Reference:

- [MLE with tensorflow](http://kyleclo.github.io/maximum-likelihood-in-tensorflow-pt-1/)
- [Machine Learning with R and TensorFlow](https://www.youtube.com/watch?v=atiYXm7JZv0)
- [Tensorflow probability](https://medium.com/tensorflow/introducing-tensorflow-probability-dca4c304e245)
- [Using tensorflow Api](https://tensorflow.rstudio.com/tensorflow/articles/using_tensorflow_api.html)
