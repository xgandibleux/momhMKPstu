# ==============================================================================
# Xavier Gandibleux - November 2021
#   Implemented in Julia 1.6

# ==============================================================================
include("parserMomkpZL.jl")
include("parserMomkpPG.jl")

# ==============================================================================
# Datastructure of a generic bi-objective 0/1 IP where all coefficients are integer
struct _bi01IP
    C  :: Matrix{Int} # objective functions, k=1..2, j=1..n
    A  :: Matrix{Int} # matrix of constraints, i=1..m, j=1..n
    b  :: Vector{Int} # right-hand side, i=1..m
end

# ==============================================================================

fname = "instancesZL/knapsack.100.3"
verbose = true

# Read and load an instance of MO-01MKP from the collection of E. Zitzler / M. Laumanns
momkpZL = readInstanceMOMKPformatZL(verbose,fname)

# Reduce the MO-MKP instance to the two first objectives and store it as a generic Bi-01IP
dat1 = _bi01IP(momkpZL.P[1:2,:], momkpZL.W, momkpZL.ω)


fname = "instancesPG/set1/ZL28.DAT"
#fname = "instancesPG/set2/kp28W-Perm.DAT"
#fname = "instancesPG/set3/W7BI-tube1-1800.DAT"
verbose = true

# Read and load an instance of Bi-01BKP from the collection of O. Perederieieva / X. Gandibleux
momkpPG = readInstanceMOMKPformatPG(verbose,fname)

# Store it as a generic bi-01IP
dat2 = _bi01IP(momkpPG.P, momkpPG.W, momkpPG.ω)
