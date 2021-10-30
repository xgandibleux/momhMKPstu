include("parserMKPzitzler.jl")

# ==============================================================================
# Datastructure of a generic bi-objective 0/1 IP
struct _bi01IP
    C  :: Matrix{Int} # objective functions, o=1..2, j=1..n
    A  :: Matrix{Int} # matrix of constraints, i=1..k, j=1..n
    b  :: Vector{Int} # right-hand side, i=1..k
end

# ==============================================================================

fname = "instancesZitzler/knapsack.100.3"
verbose = true

zitzler = readInstanceMOMKPformatZitzler(verbose,fname)

dat = _bi01IP(zitzler.P[1:2,:], zitzler.W, zitzler.ω)
