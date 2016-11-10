module Percolation

# type
export squarenn, squarennrec, squarennn, squarennnrec
export trinn, trinnrec
export honeycomb
export kagome
export simplenn

# function
export percolation, percolationplot, percolationgif, cluster, clusterplot
    
    import PyPlot
    using LaTeXStrings

    include("general/latticetype.jl")
    include("general/checksite.jl")
    include("general/makelattice.jl")
    include("general/PercolationPlot.jl")
    include("general/percolation.jl")
    include("general/percolationgif.jl")
    include("general/cluster.jl")
    

end
