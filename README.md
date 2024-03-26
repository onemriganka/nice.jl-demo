# NICE.JL-demo

 Hello community, I am Mriganka , in order to improve and contribute to the project " GSoC 2024: Add exact solvers" i made this repo. I made this from the NICE.jl repo and added a demo ExactSolver.jl file to complete the goals of the project. I do not know much about the code base of QC-devs repos as I am a beginner. but if i got the opportunity to contribute to this amazing project I will do my best for it .it's generally good practice to avoid directly modifying core files in an official repository. so I created a separate file within the src directory for the exact solver code.


## 1. Objective and Jacobian Functions
The core of the exact solver is the definition of the objective function and its Jacobian. These functions represent the system of nonlinear equations that define the equilibrium state.


Objective Function:

The objective function measures the difference between the current state of the system and the equilibrium state. One common choice is the sum of squared residuals of the equilibrium constant expressions for each reaction
This function takes the ReactionSystem and a vector of reaction extents as input. It calculates the concentrations at the given extent and computes the residuals for each equilibrium constant expression. The sum of squared residuals is returned as the objective function value.

Jacobian Function:

The Jacobian matrix contains the partial derivatives of the objective function with respect to each reaction extent. This matrix is crucial for efficient numerical optimization.This function calculates the Jacobian matrix based on the current concentrations and stoichiometry matrix.

## 2. Nonlinear Optimization

With the objective and Jacobian functions defined, we can utilize a nonlinear optimization library to find the equilibrium extent. One popular choice in Julia is the NLsolve.jl package.This function takes the ReactionSystem as input and uses NLsolve.jl to find the equilibrium extent. It then updates the system's concentrations and iteration count.

## 3. Hybrid KMC-Exact Solver

We can combine the existing KMC functionality with the exact solver to improve efficiency. The KMC method can provide a good initial guess for the exact solver, reducing the number of iterations required for convergence.
This function first runs the KMC method for a specified number of iterations and then uses the resulting concentrations as the initial guess for the exact solver.


## 4. Testing and Integration
The new functions and methods should be thoroughly tested with various reaction systems and compared against the existing KMC implementation. Once validated, these functions can be integrated into the NICE.jl module, providing users with the option to perform exact equilibrium calculations.


### Contributions are welcome, happy to improve the code. To contribute just clone the repo and make PR :)

## License

[MIT](https://choosealicense.com/licenses/mit/)