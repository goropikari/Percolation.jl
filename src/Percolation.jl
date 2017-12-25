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

    include("general/latticetype.jl")
    include("general/cluster.jl")
    include("general/forestfire.jl")
    include("general/HoshenKopelmanAlgorithm.jl")    

end
