module Percolation
export simplenn, simplennn, testnn
export checksite, MakeSimpleLattice, PercolationPlot, verticalPercolation, percolation, percolationgif
    
    using PyPlot

    include("general/latticetype.jl")
    include("general/checksite.jl")
    include("general/lattice.jl")
    include("general/PercolationPlot.jl")
    include("general/verticalPercolation.jl")
    include("general/percolation.jl")
    include("general/percolationgif.jl")

end
