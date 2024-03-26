module ExactSolver
using NLsolve

#Objective Function:

function objective(rxn_system::ReactionSystem, extent::Vector{Float64})
    concs = rxn_system.concs .+ rxn_system.stoich * extent
    residuals = [prod(concs .^ s) - K for (s, K) in zip(eachcol(rxn_system.stoich), rxn_system.keq_vals)]
    return sum(residuals.^2)
end

#Jacobian Function:
function jacobian(rxn_system::ReactionSystem, extent::Vector{Float64})
    concs = rxn_system.concs .+ rxn_system.stoich * extent
    J = zeros(Float64, rxn_system.n_reaction, rxn_system.n_reaction)
    for i in 1:rxn_system.n_reaction
        for j in 1:rxn_system.n_reaction
            s_i = rxn_system.stoich[:, i]
            s_j = rxn_system.stoich[:, j]
            K = rxn_system.keq_vals[i]
            J[i, j] = 2 * (prod(concs .^ s_i) - K) * sum(s_i .* s_j .* concs .^ (s_i .- 1))
        end
    end
    return J
end
#Nonlinear Optimization

using NLsolve

function solve_equilibrium(rxn_system::ReactionSystem)
    initial_guess = zeros(Float64, rxn_system.n_reaction) # Initial guess for extents
    
    # Define the optimization problem
    problem = NonlinearProblem(
        (extent) -> objective(rxn_system, extent),
        (extent) -> jacobian(rxn_system, extent),
        initial_guess
    )
    
    # Solve the problem
    solution = nlsolve(problem)
    
    # Update the system with the equilibrium concentrations
    rxn_system.concs .+= rxn_system.stoich * solution.zero
    rxn_system.n_iter += 1
    
    return solution
end
#Hybrid KMC-Exact Solver
function solve_hybrid(rxn_system::ReactionSystem, n_kmc_iter::Int)
    run_kmc(rxn_system, n_kmc_iter) # Run KMC for initial guess
    solve_equilibrium(rxn_system) # Use KMC result as initial guess for exact solver
end

end