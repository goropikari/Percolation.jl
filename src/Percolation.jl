module Percolation

# type
export Squarenn, Squarennn, Forest, Tri, Honeycomb, Kagome, Simplenn

# function
#export percolation, percolationplot, percolationgif
export cluster!, clusterplot, clusterplotsize
export forestfire!, forestplot, forestgif!
export HK!
    
import PyPlot
using LaTeXStrings, StatsBase, PyCall
@pyimport matplotlib.patches as patch

include("latticetype.jl")
include("cluster.jl")
include("forestfire.jl")
include("HoshenKopelmanAlgorithm.jl")    

end
