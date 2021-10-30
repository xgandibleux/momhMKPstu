# ==============================================================================
# Xavier Gandibleux - October 2021
#   Implemented in Julia 1.6

# ==============================================================================
include("parserMOMKPzitzler.jl")

# ==============================================================================
# Datastructure of a generic bi-objective 0/1 IP where all coefficients are integer
struct _bi01IP
    C  :: Matrix{Int} # objective functions, o=1..2, j=1..n
    A  :: Matrix{Int} # matrix of constraints, i=1..k, j=1..n
    b  :: Vector{Int} # right-hand side, i=1..k
end

# ==============================================================================

fname = "instancesZitzler/knapsack.100.3"
verbose = true

# Read and load an instance of MO-MKP from the collection of E. Zitzler
momkpZitzler = readInstanceMOMKPformatZitzler(verbose,fname)

# Reduce the MO-MKP instance to the two first objectives and manage it as a generic bi-01IP
dat = _bi01IP(momkpZitzler.P[1:2,:], momkpZitzler.W, momkpZitzler.ω)
