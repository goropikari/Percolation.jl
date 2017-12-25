module Percolation

# type
export Squarenn, Squarennn
export Forest
export Tri
export Honeycomb
export Kagome
export Simplenn

# function
#export percolation, percolationplot, percolationgif
export cluster, clusterplot, clusterplotsize
export forest, forestgif
export HK!
    
    import PyPlot
    using LaTeXStrings, StatsBase, PyCall
    @pyimport matplotlib.patches as patch

    include("latticetype.jl")
    include("cluster.jl")
    include("forestfire.jl")
    include("HoshenKopelmanAlgorithm.jl")    

end
