module Percolation

# type
export squarenn, squarennrec, squarennn
export trinn, trinnrec
export simplenn

# function
export percolation, percolationgif
    
    import PyPlot
    using LaTeXStrings

    include("general/latticetype.jl")
    include("general/checksite.jl")
    include("general/makelattice.jl")
    include("general/PercolationPlot.jl")
    include("general/percolation.jl")
    include("general/percolationgif.jl")

end
