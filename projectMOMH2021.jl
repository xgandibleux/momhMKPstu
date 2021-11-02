# ==============================================================================
# Xavier Gandibleux - November 2021
#   Implemented in Julia 1.6

# ==============================================================================

println("""\nProject MOMH 2021" --------------------------------\n""")

const verbose = true
const graphic = true

include("parserMomkpZL.jl")
include("parserMomkpPG.jl")
include("vOptMomkp.jl")
include("displayGraphic.jl")


# ==============================================================================
# Datastructure of a generic bi-objective 0/1 IP where all coefficients are integer
#
#   Max  sum{j=1,...,n} C(k,j) x(j)                k=1,...,p
#   st   sum{j=1,...,n} A(i,j) x(j) <= b_{i}       i=1,...,m
#                       x(j) = 0 or 1

struct _bi01IP
    C  :: Matrix{Int} # objective functions, k=1..2, j=1..n
    A  :: Matrix{Int} # matrix of constraints, i=1..m, j=1..n
    b  :: Vector{Int} # right-hand side, i=1..m
end

# ==============================================================================

# Example ----------------------------------------------------------------------
fname = "instancesZL/knapsack.100.2"

# Read and load an instance of MO-01MKP from the collection of E. Zitzler / M. Laumanns
momkpZL = readInstanceMOMKPformatZL(verbose,fname)

# Reduce the MO-MKP instance to the two first objectives and store it as a generic Bi-01IP
dat1 = _bi01IP(momkpZL.P[1:2,:], momkpZL.W, momkpZL.ω)


# Example ----------------------------------------------------------------------
fname = "instancesPG/set1/ZL28.DAT"
#fname = "instancesPG/set2/kp28W-Perm.DAT"
#fname = "instancesPG/set3/W7BI-rnd1-1800.DAT"

# Read and load an instance of Bi-01BKP from the collection of O. Perederieieva / X. Gandibleux
momkpPG = readInstanceMOMKPformatPG(verbose,fname)

# Store it as a generic bi-01IP
dat2 = _bi01IP(momkpPG.P, momkpPG.W, momkpPG.ω)

# Example ----------------------------------------------------------------------
solverSelected = GLPK.Optimizer
#YN, XE = vSolveBi01IP(solverSelected, dat1.C, dat1.A, dat1.b)
YN, XE = vSolveBi01IP(solverSelected, dat2.C, dat2.A, dat2.b)

# ---- Displaying the results (XE and YN)
for n = 1:length(YN)
    X = value.(XE, n)
    print(findall(elt -> elt ≈ 1, X))
    println("| z = ",YN[n])
end

for n = 1:length(YN)
    println(YN[n])
end

# Example ----------------------------------------------------------------------
displayGraphics(fname,YN)
