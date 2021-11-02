# ==============================================================================
# Xavier Gandibleux - November 2021
#   Implemented in Julia 1.6

using PyPlot

# ==============================================================================

# ------------------------------------------------------------------------------
# kung Algorithm for extracting SN from a static set S of points
function kungAlgorithm(S1, S2)
    S = []
    for i=1:length(S1)
        push!(S, (S1[i] , S2[i]) )
    end
    sort!(S, by = x -> x[1])
    SN=[] ; push!(SN, S[1]) ; minS2 = S[1][2]
    for i=2:length(S1)
        if S[i][2] < minS2
            push!(SN, S[i]) ; minS2 = S[i][2]
        end
    end
    return SN
end

# ------------------------------------------------------------------------------
# compute the corner points of a set (S1,S2) and its lower envelop
function computeCornerPointsLowerEnvelop(S1, S2)
    # when all objectives have to be maximized
    Env1=[]; Env2=[]
    for i in 1:length(S1)-1
        push!(Env1, S1[i]); push!(Env2, S2[i])
        push!(Env1, S1[i]); push!(Env2, S2[i+1])
    end
    push!(Env1, S1[end]);push!(Env2, S2[end])
    return Env1,Env2
end

# ------------------------------------------------------------------------------
# display different results
function displayGraphics(fname,YN)
    PlotOrthonormedAxis = true  # Axis orthonormed or not
    DisplayYN   = true          # Non-dominated points corresponding to efficient solutions
    DisplayUBS  = false         # Points belonging to the Upper Bound Set
    DisplayLBS  = false         # Points belonging to the Lower Bound Set
    DisplayInt  = false         # Points corresponding to integer solutions
    DisplayProj = false         # Points corresponding to projected solutions
    DisplayFea  = false         # Points corresponding to feasible solutions
    DisplayPer  = false         # Points corresponding to perturbated solutions

    YN_1=[];YN_2=[]
    for i in 1:length(YN)
        push!(YN_1, YN[i][1])
        push!(YN_2, YN[i][2])
    end

    # --------------------------------------------------------------------------
    # Setup
    figure("Project MOMH 2021",figsize=(6.5,5))
    if PlotOrthonormedAxis
        vmin = 0.99 * min(minimum(YN_1),minimum(YN_2))
        vmax = 1.01 * max(maximum(YN_1),maximum(YN_2))
        xlim(vmin,vmax)
        ylim(vmin,vmax)
    end
    xlabel(L"z^1(x)")
    ylabel(L"z^2(x)")
    PyPlot.title("Bi-01BKP | $fname")

    # --------------------------------------------------------------------------
    # Display Non-Dominated points
    if DisplayYN
        # display only the points corresponding to non-dominated points
        scatter(YN_1, YN_2, color="black", marker="+", label = L"y \in Y_N")
        # display segments joining adjacent non-dominated points
        plot(YN_1, YN_2, color="black", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        # display segments joining non-dominated points and their corners points
        Env1,Env2 = computeCornerPointsLowerEnvelop(YN_1, YN_2)
        plot(Env1, Env2, color="black", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
    end

    # --------------------------------------------------------------------------
    # Display a Upper bound set (primal, by default)
    if DisplayUBS
        plot(xU, yU, color="green", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        scatter(xU, yU, color="green", marker="o", label = L"y \in U")
    end

    # --------------------------------------------------------------------------
    # Display a Lower bound set (dual, by excess)
    if DisplayLBS
        plot(xL, yL, color="blue", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        scatter(xL,yL, color="blue", marker="x", label = L"y \in L")
    end

    # --------------------------------------------------------------------------
    # Display integer points (feasible and non-feasible in GravityMachine)
    if DisplayInt
        scatter(XInt,YInt, color="orange", marker="s", label = L"y"*" rounded")
    end

    # --------------------------------------------------------------------------
    # Display projected points (points Δ(x,x̃) in GravityMachine)
    if DisplayProj
        scatter(XProj,YProj, color="red", marker="x", label = L"y"*" projected")
    end

    # --------------------------------------------------------------------------
    # Display feasible points
    if DisplayFea
        scatter(XFeas,YFeas, color="green", marker="o", label = L"y \in F")
    end

    # --------------------------------------------------------------------------
    # Display perturbed points (after a cycle in GravityMachine)
    if DisplayPer
        scatter(XPert,YPert, color="magenta", marker="s", label ="pertub")
    end

    # --------------------------------------------------------------------------
    legend(bbox_to_anchor=[1,1], loc=0, borderaxespad=0, fontsize = "x-small")
end
