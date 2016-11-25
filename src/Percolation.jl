module Percolation

# type
export squarenn, squarenn2, squarennrec, squarennn, squarennnrec
export Forest
export trinn, trinnrec
export honeycomb
export kagome
export simplenn

# function
export percolation, percolationplot, percolationgif
export cluster, clusterplot, clusterplotsize
export forest, forestgif
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
    include("general/forestfire.jl") # 他に依存しない
    include("general/HoshenKopelmanAlgorithm.jl")
    include("general/squarenn2.jl")
    

end
