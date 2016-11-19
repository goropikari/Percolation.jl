module Percolation

# type
export squarenn, squarennrec, squarennn, squarennnrec, forest
export trinn, trinnrec
export honeycomb
export kagome
export simplenn

# function
export percolation, percolationplot, percolationgif
export cluster, clusterplot, clusterplotsize
export forestfire, forestfiregif
export HK
    
    import PyPlot
    using LaTeXStrings, StatsBase, PyCall
    @pyimport matplotlib.patches as patch

    include("general/latticetype.jl")
    include("general/checksite.jl")
    include("general/PercolationPlot.jl")
    include("general/percolation.jl")
    include("general/percolationgif.jl")
    include("general/cluster.jl")
    include("general/forestfire.jl")
    include("general/HoshenKopelmanAlgorithm.jl")
    

end
