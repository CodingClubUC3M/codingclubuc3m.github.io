---
layout: post 
comments:  true
title: "A brief introduction to parallel computing in Julia"
author: "David García-Heredia"
date: 2018-06-06 20:30:00
published: true
visible: false
categories: [Julia, parallel]
excerpt_seperator: ""
output:
  html_document:
    mathjax:  default
---

In this post we will be learning how to take advantage of a multi-core PC through the use parallel computing in Julia. It is worthy to mention that several of the examples provided here come from Julia [website](<https://julialang.org/>), that is why we have decided to preserve the structure of the contents developed in there. Comparing with the information that can be found there, the reader may appreciate that when using the same examples, we have detailed a little bit more the explanation such that the ideas exposed can be easily understood. As a result, this post turns out to be a mix of examples: ones coming from the official documentation, and others coming from our own. Hopefully this approach will help the reader with the task of parallel computing.

## First approach

The basic idea of parallel computing is: there are several independent tasks that, instead of being done sequentially, they could be carried out at the same time (improving performance) by different processes. There can exist some sort of dependence between tasks and these still could be parallelized (with caution), but they cannot be completely dependent (meaning that for one to start the previous one had to be finished). Examples of tasks that can be parallelized are: generation of random numbers, matrix multiplication, Branch and Bound algorithm etc.

When using parallel computing, there are some commands that we will need most of the time:

```julia
Sys.CPU_CORES # Number of logical CPU cores available in the system.
nprocs()      # Number of available processes.
nworkers()    # Number of available worker processes. nworkers() = nprocs() - 1.
procs()       # An array of the processes.
workers()     # An array of the workers.
addprocs(3)   # Number of processes added (e.g.: 3).
rmprocs(2)    # Removes the specified workers, in this case the 2nd.
              # rmprocs(1) does not work because procs = 1 is not a worker.
```

The previous code brings some new notation that must be explained. "Workers" is the name given to the processes used for parallel operations. Each worker has an identifier that we will employ to refer to it. For instance, in the code above we have removed the second worker using its id. It is important to know that the process providing the interactive Julia prompt always has an id equal to 1. To clarify these commands let's run the next code:

```julia
# Before adding workers.
nprocs()
nworkers() # when there is no extra workers, nprocs() = nworkers().

# After adding them.
addprocs(Sys.CPU_CORES - 1)
nprocs()
nworkers()
workers()
```

To carry out parallel operations, besides adding the required workers, we must learn how to communicate with them, i.e.: how to send them work to do. In our case, the communication flow will be established through remote references and remote calls. A remote reference is for the exchange of information between processes, while a remote call is to make the request to execute a function. To get more information about how the communication is established, we encourage the reader to have a look at the official documentation. As for us, let's see these ideas with code examples.

First, imagine that we want to generate two matrices formed by random numbers in worker number 2. One of the matrices is going to be of real numbers, while the other one of integers between 1 and 8.

```julia
# addprocs(Sys.CPU_CORES - 1)  # Run this line if needed.
r1 = remotecall(rand, 2, 2, 2) # Function, id of the worker, args of the function.
r2 = remotecall(rand, 2, 1:8, 3, 4) # We obtain a 'Future'.
```

With the code above, we have told the second worker to do two different tasks. For both cases, the function "remotecall" has immediately returned a "Future", i.e.: a special type of remote reference. With that reference, we will be able to get the result of the operation afterward using the function "fetch":

```julia
fetch(r1) # We get the value.
fetch(r2)

# Notice what happens once the value is fetched:
r1
r1[2, 2]
```

There are other ways, besides the function remotecall(), of sending work to the different processes. Check for instance the next code in which we create a random matrix and then we add 1 to all its elements.

```julia
# Option 1: using remotecall and spawnat.
r1 = remotecall(rand, 2, 2, 2)
s1 = @spawnat 2 1 .+ fetch(r1) # id process, expression: 1 .+ fetch(r1)
fetch(s1)

# Option 2: using only spawnat.
s2 = @spawnat 2 rand(2, 2)
s3 = @spawnat 3 1 .+ fetch(s2)
fetch(s3) # The result changes because we are using random numbers.

# Option 3: Letting Julia to select the process for us.
s2 = @spawn rand(2, 2)     # Notice that there is no "at", so we do not specify the worker.
s3 = @spawn 1 .+ fetch(s2) # It is Julia who select it.
fetch(s3)
```

```julia
# Tip: due to efficiency reasons, use
remotecall_fetch(rand, 2, 2, 2) # instead of fetch(remotecall())
```

In the same way that we use predefined functions from Julia (e.g.: rand), we can use our own functions to make computations in parallel. Let's see how:

```julia
# We create a function that returns the sum of the eigenvalues.
function eig_sum(A)
    autoVal, autoVec = eig(A);
    return sum(autoVal)
end

# We test the function as usual... and it works fine.
eig_sum(rand(2, 2))

# We use it at process 1.
s1 = @spawnat 1 eig_sum(rand(2, 2))
fetch(s1)

# We use it at process 2.
s2 = @spawnat 2 eig_sum(rand(2, 2))
fetch(s2) # returns an error.
```
The error in the last piece of code is because the 2nd process does not know about the function! It has only been declared at process 1. To overcome this problem we have to use the macro "@everywhere":

```julia
@everywhere function eig_sum(A) # Now all the processes know about the function.
    autoVal, autoVec = eig(A);
    return sum(autoVal)
end

s3 = @spawnat 2 eig_sum(rand(2, 2))
fetch(s3) # Now everything works fine.

# When having the functions in an external file:
@everywhere include("FileWithFunctions.jl")
```

## Data movements

Recall that the goal in parallel computing is to improve performance, and to that end, it is important to pay attention to all the steps involved. In particular, everything related to the quantity of information sent between processes and the scope of the variables is crucial. For instance, we will see later how parallel for loops are not efficient when the workload is not large, because the amount of data movements required does not make up for it.

To better understand the idea of data movements, consider the following example from the official documentation.

```julia
A = rand(10, 10);   # We construct the matrix locally.
Bref1 = @spawn A^2; # We move the data to another process, where the operation is performed.

Bref2 = @spawn rand(10, 10)^2; # Less data movement since everything is done in the same process.
```

As can be seen, the same operation can be done in two different ways. The use of one approach or another will depend on the necessities (e.g.: if the first process needs matrix A, the first approach might be better). We encourage the reader to check the official documentation for more information about this example.

Related to the scope of the variables, the use of global variables in remote calls can lead to a duplicity of them, consuming extra memory without necessity. In the next code we clearly expose that problem and a solution using "let blocks".


```julia
A = rand(2, 2)
whos()            # We see that A is created locally.
@spawnat 2 whos() # We see that there is nothing in the second process.

s3 =  @spawnat 2 eig_sum(A) # We perform an operation in the second process.
fetch(s3)
@spawnat 2 whos() # Now A is also in the second process! What can be really memory-consuming.

# Solution to the problem.
X = rand(4, 4) # We create a new Matrix X.
whos()         # We see how it is in the first process, but not in the second one.
@spawnat 2 whos()

# With this code, we will be able to use X in another process, but without duplicating it.
let B = X
    s3 = @spawnat 2 eig_sum(B)
end
@spawnat 2 whos() # Now X has not been saved in the 2nd process!
```

## Parallel map and loops

So far we have seen how to communicate with different processes and which are the things to pay attention when doing parallel computing. Now we are going to learn two common things employed in parallel computing: parallel for loops and parallel mapping (the use of the "map" function in parallel).

We will be interesting in using a parallel for loop when we have a **really big** number of **easy** and **independent** tasks to do. Let us explain why we emphasized the previous words. We need a big number of operations to do because parallel for loops require more data/messages movements than ordinary for loops, so the number of operations must be big enough to be worthwhile. We need easy operations because the idea is that the number of operations, and not the operations themselves, are the time-consuming factor. When this is the other way around: few operations, but really time-consuming, we will use parallel maps instead. Finally, independence is needed because iterations do not happen in a specified order.

To better understand all this, let's see the next code.

```julia
n = 200000000;
nheads = @parallel (+) for i = 1:n
    Int(rand(Bool))
end
```

In the code above, we are counting the number of successes when generating 200 million of independent observations from a Bernoulli random variable with parameter $p=0.5$. Notice how all the requirements for the use of a parallel for loop are fulfilled: a **really big** number of **easy** and **independent** operations. In the code, "(+)" is called the reduction operator and it serves to merge the results of each iteration. Although the use of a reduction operator is not mandatory, it is commonly use. However, if for any reason you do not use it, you have to know that then the parallel for loop is executed asynchronously, so you will probably want to add the macro "@sync" at the beginning (we will explain this macro and the meaning of asynchronously later on with an example).

Let's see another example where a parallel for loop is employed.

```julia
# Approximating \pi through Monte Carlo method (area of the circle).
piAprox = 0.0; # Recall, pi = 3.1415926...
piAprox = @parallel (+) for i = 1:n
    Int(rand()^2 + rand()^2 <= 1);
end
piAprox /= n/4 # Equivalent to piAprox = piAprox*4/n.
```

The important thing to remember when using parallel for loops is that they **do not work** as ordinary for loops. This implies that we CANNOT modify arrays as it is exemplified in the next code:

```julia
a = zeros(100000);
@parallel for i = 1:100000
    a[i] = i;
end
a # Nothing has changed.
```

The reason why the assignation operation did not take place is because the array belongs to the first process, while the iterations take place in different ones. Therefore, to modify an array we have to make it visible from all processes, something that we will learn to do at the end of this post.

Nevertheless, although we cannot modify ordinary arrays, we can read from them without any problem:

```julia
# Another implementation to compute an approximation for \pi.
# In this case, reading the data from local arrays.
n = 100000;
x = rand(n);
y = rand(n);

# We will also use an external function to exemplify how to use them in
# parallel for loops.
@everywhere function inside(x, y) return Int(x^2 + y^2 <= 1) end

piAprox = 0.0;
piAprox = @parallel (+) for i=1:n
            inside(x[i], y[i]);
end

piAprox /= n/4
```

To conclude this part about the use of parallel for loops, let's see what is the performance when the amount of work is not really big. We will compare it with an ordinary for loop and predefined functions.

```julia
# Ordinary for loop.
a = 0;
@time for i = 1:20000
     a += Int(rand(Bool));
end
# Parallel for loop
@time @parallel (+) for i = 1:20000
    Int(rand(Bool));
end
# Predefined function.
@time sum(rand(0:1, 20000))

# For no so small amount of work:
@time @parallel (+) for i = 1:n
    Int(rand(Bool))
end

# DO NOT run sum(rand(0:1, n)) or the ordinary for loop with 'n': You can have
# a run out of memory problem.
```

As we said before, parallel for loops makes sense under some conditions. When there are a few tasks to do, but really time-consuming (e.g.: computing the eigenvalues for different matrices), then it is better to use the function "map", but in parallel, that is, to evaluate each input in a different process at the same time. Check the next code for an example.

```julia
# We create an array of matrices.
M = Matrix{Float64}[rand(1000, 1000) for i = 1:10];
pmap(svd, M); # Compute the svd for each of them.
```

## Dynamic scheduling

When parallelizing tasks, sometimes the time required by each of them might be different, so we will be interested in sending new work to each process as they finish (like in a FIFO system). Working like this is what is going to make parallel computation to become efficient. To better understand this example, let's go to discuss some code provided in the official documentation.

Consider the previous situation with the "map" function, but now with the following matrices:

```julia
M = Matrix{Float64}[rand(800, 800), rand(600, 600), rand(800, 800), rand(600, 600)];
```
It is clear that if we had two processes, it would not make any sense that one of them compute the Single Value Decomposition for the two big matrices ($800 \times 800$), and the other one for the two small ones. In this case the problem could be solved by "manually" assigning the matrices to the processes, but what would it happen if we did not know which matrices (the first one, the second one...) will be the big ones in advance?

To see how to solve this problem, let's discuss the following "easy" implementation of a parallel map function. As mentioned, the code (except for the comments) is from the official documentation, and it will serve us to introduce new functions to work with parallel computing.

```julia
# The arguments are: 1) a function 'f' and 2) a list with the input.
function f_pmap(f, lst)
    np = nprocs()            # Number of processes available.
    n  = length(lst)         # Number of elements to apply the function.
    results = Vector{Any}(n) # Where we will write the results. As we do not know
                             # the type (Integer, Tuple...) we write "Any"
    i = 1
    nextidx() = (idx = i; i += 1; idx) # Function to know which is the next work item.
                                       # In this case it is just an index.
    @sync begin # See below the discussion about all this part.
        for p=1:np
            if p != myid() || np == 1
                @async begin
                    while true
                        idx = nextidx()
                        if idx > n
                            break
                        end
                        results[idx] = remotecall_fetch(f, p, lst[idx])
                    end
                end
            end
        end
    end
    results
end
```

The difficult and important part to understand in the function is the one with "@sync" and "@async". Let's analyze everything:

1. The "@sync" block is saying "it is forbidden to skip this block and continue executing code until all the jobs are done". As we are parallelizing task that might need different times to be completed, we want to ensure that we do not continue running the program until everything is finished. You usually employ "@sync" when using an "@async" block.

2. It is clear that we are using the for loop to go through all the processes, but what is the purpose of the if conditional? Well, it is establishing that the first process is only used if there are no other processes. This is because the function myid() is returning 1: the number of the process in which we are executing the function. If the function were executed in worker number 4, the process would return 4.

3. Once we are inside the condition, we start the "@async" block. The idea of this block is to launch several tasks at the same time, but not in a synchronous way, i.e.: we do not care which task starts or ends earlier, we just want to finish work as quick as we can. Thanks to the first block "@sync" we will achieve to synchronize everything at the end. Notice that "@async" is launching tasks, but **not** in different processes. We achieve to send work to each process $p$ through the use of the remotecall_fetch() function.

4. Everything that it is inside the "@async" block is the task to execute. Notice that in this case we have an infinite while loop from which we can escape thanks to the the break statement. The while loop works as follows: We get the position (using nextidx()) of the input to evaluate. Then we execute the function 'f' in process $p$ and save the result (as the task are launched locally, there is no problem when working with an ordinary array). As we are in an infinite while loop we repeat again the operation. Imagine that the last input element is being evaluated at process $p=3$. Then, the task associated with process $p=2$ will leave the while loop because of the break statement. The block "@async" will also be abandoned, but "@sync" will not. For that, it will be necessary that the task associated with $p=3$ ends too.


VER DIBUJO QUE HICE DE LA FUNCION en las hojas del paper... para la presentacion

## Channels

In the previous part we have seen how to launch different task simultaneously and how to manage them asynchronously. We did not have any problem related to sharing information because all the tasks were executed in process $1$, although the functions were evaluated in a different one. Sometimes this will not be so easy because each task will be also executed in a different process. To establish communication in that situation one of the options is to use "Channels". A channel can be thought a queue in a supermarket: you start adding elements in the back, but you take them from the front. Channels allow to easily implement parallelization when we need to read some data, process it, and write it.

Let's check the code below (coming from the official documentation) for a better understanding. In there, it is simulated the following situation: There is a list of jobs to do and we want to initialize 4 simultaneous task to complete them. Every single time a job is finished, we write the total time employ in another list (a channel in our case).

```julia
# The first parameter of a channel is the Type (e.g.: Int) and the second one,
# the maximum number of elements allowed in the channel.
const jobs    = Channel{Int}(32); # Here we can save at maximum 32 integers.
const results = Channel{Tuple}(32);

function do_work()
   for job_id in jobs
       exec_time = rand()
       sleep(exec_time)  # Simulates elapsed time doing actual work.
                         # Typically performed externally.
       put!(results, (job_id, exec_time)) # To write elements in a channel we "put" them.
   end
end;

function make_jobs(n)
   for i in 1:n
       put!(jobs, i)
   end
end;

n = 12;

@schedule make_jobs(n); # Feed the jobs channel with "n" jobs.

for i in 1:4 # Start 4 tasks to process requests in parallel.
   @schedule do_work()
end

@elapsed while n > 0 # Print out results.
   job_id, exec_time = take!(results) # To get elements from a channel we "take" them.
   println("$job_id finished in $(round(exec_time, 2)) seconds")
   n = n - 1
end
```

Let's read the code:

1. We start declaring the channels and functions that we will use. The function "do_work" simulates the time required to complete the work and writes the result in the corresponding channel. The function "make_jobs" just initializes the channel jobs. In this case we will simulate 12 different jobs.

2. The macro "@schedule" is transforming the function to a task and executing it. If we had written "make_jobs(n)", it would also have worked.

3. In the for loop, we are launching 4 tasks simultaneously. This implies that at the same moment, job $1$, $2$, $3$ and $4$ start to be executed. Thanks to the macro "@schedule", which is converting the function to a task (as "@async" does), we can keep the track of the index in the for loop of the do_work function.

4. The last part of the code serves to see which job has *finished* before and which has been the time required for its execution. If you execute the code, you will notice that the total amount of time required by the jobs is larger than the time employed (because of parallelization). This is easy to see if you multiply by $5$ the rand time and run the code again.


To better understand this code we propose to the reader the following two exercises:

* Check what would be the difference if instead of initializing $4$ tasks, we just call the function as we do when not performing parallel computing.

* Instead of using less than a second for the sleep function, use larger amount of time (e.g.: a mean of 2 seconds) and analyze what happens in the while loop when the task has not been completed and we take the output from channel "results".

* Check more examples involving channels and the way you work with them in the official documentation.

Notice that in the last example, all the tasks were running in the same process. However, we started motivating the use of channels saying that we might be interested in launching the tasks in different processes. To do that, we would need to communicate different processes in the reading/writing operations, so an especial type of channels is needed: Remote Channels. Let's see an implementation of the previous code using them. The difference, in this case, is that the jobs will be executed in different processes and not in the first one as before.

```julia
addprocs(4); # Add worker processes.

const jobs    = RemoteChannel(()->Channel{Int}(32));
const results = RemoteChannel(()->Channel{Tuple}(32));

@everywhere function do_work(jobs, results) # Define work function everywhere.
   while true
       job_id = take!(jobs)
       exec_time = rand()
       sleep(exec_time)
       put!(results, (job_id, exec_time, myid()))
   end
end

function make_jobs(n)
   for i in 1:n
       put!(jobs, i)
   end
end;

n = 12;

@schedule make_jobs(n); # Feed the jobs channel with "n" jobs.

for p in workers() # Start tasks on the workers to process requests in parallel.
   @async remote_do(do_work, p, jobs, results) # Similar to remotecall.
end

@elapsed while n > 0 # Print out results.
   job_id, exec_time, where = take!(results)
   println("$job_id finished in $(round(exec_time,2)) seconds on worker $where")
   n = n - 1
end
```

As you can see, the code is exactly the same as before, except that in this case we had to take care bout how we established communication between processes.

## Shared Arrays

In the previous examples, the reader might have appreciated that the use of channels, though helpful, might not be proper for all the situation. Sometimes we might be interested in working with usual arrays, but in parallel (e.g.: for a matrix multiplication algorithm). For those situations there exists a type name Shared Array. This turns out to be just an array, but that can be accessed from any process. Furthermore,  although the type Shared Array is different from Array, functions that ask for an Array they usually also work with Shared Arrays. And if not, there exists a function call "sdata()" that transform a Shared Array to an Array.

Let's see a quick example of how Shared Arrays work. More information and examples can be found in the official documentation.

First, let's see how we create Shared Arrays.

```julia
SharedArray{T, N}(dims::NTuple, init = false, pids = Int[])
```
Where, T stands for the type (e.g.: Float64) and N for the dimension of the array (e.g.: 2 for a 2-dimensional array). Inside brackets, "dims" collects the number of elements in each dimension (e.g.: (3,2) for a matrix $3\times 2$), "init" is the function used to initialize the array, and "pids" is a vector with the workers that can access to the Shared Array. These last two arguments are voluntary. For instance, if nothing is specify in "pids", all the workers can access to the Shared Array. Let's see this with examples.

```julia
S = SharedArray{Int, 2}((3, 4)) # We do not specify neither init nor pids.
S = SharedArray{Int, 2}((3, 4), init = S -> S[Base.localindexes(S)] = 1)
S = SharedArray{Int, 2}((4, 4), init = S -> S[collect(1:5:16)] = 1)
S[3, 2] = 7 # We can work with a Shared Array as with ordinary ones.
S
```

Recall that when we introduced parallel for loops we said that we could not modify the elements of the array. Now, using Shared Arrays this is not a problem anymore. Check for instance the following example, in which we are performing a dot product in parallel.

```julia
x = rand(0:5, 1000);
c = rand(0:1, 1000);
output = SharedArray{Int, 1}(1000);

@parallel (+) for i = 1:1000
  output[i] = x[i]*c[i];
end

output # We have been able to modify the array.
```

Notice that for the dimension of the problem a parallel for does not make sense, but it is okay for teaching purposes.

Besides Shared Array, there also exist Distributed Arrays. These arrays also allow to work in parallel, but opposite to Shared Array, they do not allow any worker to access to any part of the array. What this type does is to chunk the array so each process has access to a limited portion of it. The advantage of this division is that it avoids the potential error of accessing to the same cell of the array by a different workers, so one modify what the previous did (supposing this is not desired). To work with Distributed Arrays it is necessary to install a package, so we will not work with them in this occasion. Nevertheless, on this [link](https://github.com/JuliaParallel/DistributedArrays.jl) can be found an extensive documentation about how to work with them.

## Last example

To conclude this post dedicated to parallel computing, we provide a last example which is a parallel implementation of the k-nearest neighbors (knn) algorithm. The performance of the algorithm will be tested using the famous Fisher's iris dataset, so we will need to install some packages to execute it (DataFrames and RDatasets). Recall that in this dataset there are 3 groups of flowers: setosa, virginica and versicolor, and the goal will be to classify within a group a new one from which we just know its characteristics. Be aware that this is an example for teaching purposes, so it is probably no the more efficient implementation. Furthermore, due to these teaching purposes, at the end of the example we have formulated some questions to better understand all the details of the code.

With all these ideas in mind, let's start seeing the code we need. First, we will introduce everything related with the input employed in the functions.

```julia
addprocs(5); # We have to add the processes before using @everywhere.

@everywhere using DataFrames # We will need all the process to use this type.
using RDatasets

# We read the dataset and pick "npoints" to classify.
df_data = dataset("datasets", "iris");
npoints = 10; # In this case we will classify only 10 points.
sample  = rand(1:size(df_data)[1], npoints);
sample  = unique(sample); # Just in case there are elements repeated.

# We save the characteristics of the points to classify in a new dataset "df_clas"
# and delete them from the original one.
df_clas = df_data[sample, :];
deleterows!(df_data, sample);
```

So far we have a dataset named "df_data" with information to use for the classification process, and another dataset "df_clas" with the points we want to classify.

Now, we are going to create a type "Point" so we can save all together information about:

1. To which group (setosa, virginica or versicolor) belongs a point "p" from df_data which is a candidate to be one of nearest neighbors.

2. And the distance from the point "p" to the point "x", which belongs to df_clas, to classify.

```julia
@everywhere type Point
    d::Float64;            # distance.
    g::AbstractString;     # group.
end
```

Now, we create some functions that we will need in the algorithm.

```julia
# We need this function to sort Points.
@everywhere function getdist(x::Point)
    return x.d
end

# We CANNOT use a dot product because we have DataFrames NO arrays!
# In the function, 'n' is the number of the columns in the dataset.
@everywhere function distance(df_data::DataFrame, df_clas::DataFrame, n::Int)
    d = 0.0;
    for k = 1:(n-1)
        d += (df_data[1, k] - df_clas[1, k])^2
    end
    return d; # We return the square of the euclidean distance.
end
```

Now we create the main function to perform the algorithm. In the input of the function, 'K' stands for the number of neighbors to use in the classification process. Notice that this functions, for simplicity, is not as general as it should, because we are going to assume that the information about the group is in the last column (what is true for the iris dataset).

```julia
@everywhere function knn(df_data::DataFrame, df_clas::DataFrame, K::Int)
    neighbors = Array{Point, 1}(K); # Where we save the K nearest neighbors.

    lastelem  = ncol(df_data);
    dist      = 0.0;  # Variable to save the distances.
    maxdist   = 0.0;  # Variable to save the larger distance within array "neighbors".
    namegroup = "";

    vnames    = Array{AbstractString, 1}(K);  # Vector of names to make the final count.
    groups    = unique(df_data[:, lastelem]); # We collect which are the groups.
    gcount    = zeros(Int, length(groups));   # Number of times each group appears.

    # To keep this simple, we assume that nrow(df_data) > K.
    # We select the first K neighbors.
    for j = 1:K
        dist         = distance(df_data[j, :], df_clas[1, :], lastelem);
        namegroup    = df_data[j, lastelem];
        neighbors[j] = Point(dist, namegroup);
    end

    # We sort by distance and get the MAXIMUM value
    sort!(neighbors, by = getdist);
    maxdist = neighbors[K].d;

    # We compare with the rest of the points.
    for j = K:nrow(df_data)
        dist = distance(df_data[j, :], df_clas[1, :], lastelem);
        if dist < maxdist
            neighbors[K].d = dist;
            neighbors[K].g = df_data[j, lastelem];
            sort!(neighbors, by = getdist);
            maxdist = neighbors[K].d;
        end
    end

    # We classify the point.
    # First, we get the names of the groups in the array "neighbors".
    for j = 1:K
        vnames[j] = neighbors[j].g;  
    end

    # Second, we count how many times appears each of them.
    for j = 1:length(groups)
        gcount[j] = count(s->(s == groups[j]), vnames);
    end
    pos = find(gcount .== maximum(gcount));
    pos = rand(pos, 1); # We sample vector pos in case of draws.

    # Third, we return the result.
    return groups[pos[1]];
end
```

So far, we can perform the knn algorithm without using parallel computing:

```julia
result = Array{AbstractString, 1}(nrow(df_clas)); # Vector with the solution.
@time for i = 1:nrow(df_clas)
    result[i] = knn(df_data, df_clas[i, :], 5); # We use K = 5.
end
result
df_clas
```

Now, let's implement the parallelization:

```julia
function knn_parallel(df_data::DataFrame, df_clas::DataFrame, counter::Int,
                      output::Array{AbstractString, 1})
  @sync begin
     for p in workers()
         @async begin
             while true
                 idx = counter - 1;
                 counter -= 1; # Why do not we need a Shared Array?
                 if idx <= 0
                     break;
                 end
                 output[idx] = remotecall_fetch(knn, p, df_data, df_clas[idx,:], 5);
             end
         end
     end
  end
end
```


```julia
# Input required.
counter = nrow(df_clas) + 1;
output  = Array{AbstractString, 1}(nrow(df_clas));

# Function.
@time knn_parallel(df_data, df_clas, counter, output)

# The result.
output
df_clas
```

The first time you run the parallel implementation the execution time is not really good. Try to run it again and answer the following questions:

1. Why the first time you run the parallel implementation is slower than the second one?

2. Is it worthy to use the parallel implementation to classify 10 points?

3. Can you modify the code so Channels are used instead of arrays?

4. Why the use of other functions as remotecall will provide faster running times than remotecall_fetch?

## References

* The official [documentation](https://docs.julialang.org/en/release-0.6/manual/parallel-computing/#Parallel-Computing-1) is a mandatory reference.

* In this [link](https://stackoverflow.com/questions/37287020/how-and-when-to-use-async-and-sync-in-julia) you will find more info about the use of macros "@sync" and "@async". You will also find an answer to the last question proposed.
