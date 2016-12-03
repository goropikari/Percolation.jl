module Percolation

# type
export squarenn, squarennn
export Forest
export tri
export honeycomb
export kagome
export simplenn

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
