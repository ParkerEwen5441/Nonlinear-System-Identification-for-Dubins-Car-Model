[![](https://images.squarespace-cdn.com/content/54c13d0ee4b0fa18586fb6c0/1422482207564-1WZSP2IEYEYVGT9IBYMO/ROAHMLABicon-01.png?format=1000w&content-type=image%2Fpng=100x)](http://google.com.au/)

# Nonlinear System Identification for Dubins' Car Model
[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

A method adapted from the paper ***Nonlinear System Identification of Soft Robot Dynamics Using Koopman Operator Theory*** by D. Bruder et al to identify the nonlinear model of Dubins' car. The method for this is given below along with a descirption of the requisite files used for each step.

# Running the Code
To identify the nonlinear dynamics of the Dubin's Car model, we use Koopman Operator Theory to first lift the data from a simulation of the system, use this lifted data to identify the linear system in Koopman space, and then recover the nonlinear vector field of our original dynamics.

The entire process can be run using the ***main.m*** file which also sets up and runs a simulation of the Dubins' Car model. Parameters for this simulation can be changed in the *Setup* portion of the file.

# Method to Identify Nonlinear System

### 1. Simulate Dubin's Car Using Known Model
We assume a-prior knowledge about the nonlinear dynamics of Dubins' car which are given below:

![state](https://latex.codecogs.com/png.latex?\inline&space;\vec{x}&space;=&space;[x,&space;y,&space;\theta])

![input](https://latex.codecogs.com/png.latex?\inline&space;u&space;=&space;[v,&space;\omega])

![dynamics](https://latex.codecogs.com/png.latex?\inline&space;\dot{x}&space;=&space;\begin{bmatrix}&space;v&space;cos(\theta)\\&space;v&space;sin(\theta)\\&space;\omega&space;\end{bmatrix})

With this model, we simulate the dynamics of the car along a trajectory given randomized inputs. This simulation is run using ***simulate.m*** in the repo.

### 2. Lift Simulation Data into Koopman Space
With the data from the simulation recorded, we lift this data into Koopman space. To do so, we specify some basis vector (with bases we decide on) and then lift the *(x,u)* and *(y,u)* data pairs, where *x* is the input state to the system, *y* is the output state, and *u* is the control input.

The bases are specifieds in ***lift.m***, a function which also lifts one set of *(x,u)* *(y,u)* data pairs, as well as analytical computes the Jacobian for the *(x,u)* lifted data point used in Eq. 21 of the paper.

The function ***lift_data.m*** is responsible for taking the entire set of datapoints from the simulation and outputing the entire set of lifter data points.

### 3. Calculate the Koopman Operator
After lifting the data from the simulation, we can now calculate the discrete-time Koopman operator, *K*, and the continuous-time Koopman Operator, *A*. This is accomplished using Eq. 17 and Eq. 18 in the paper and done in the ***main.m*** file.

### 4. Calculate the Nonlinear Vector Field
With the continuous-time Koopman Operator, *A*, we estimate the nonlinear vector field of the system, *F*, using Eq. 21 in the paper. This is done in ***main.m***.

### 5. Validate the Identified System
With the estimated Koopman operators and the estimated nonlinear vector field, we need to validate the results of the system identification. We start with the initial condition used in the original Dubins' car simulation and then iteratively advance the dynamics of the car in Koopman space. The lifted states of the Koopman dynamics are then used to recover the states of our nonlinear system (given knowledge about our basis functions) and then this sequence of states of our estimated nonlinear system is compared against the actual dynamics of the system. This is done in ***validate.m***.
 
