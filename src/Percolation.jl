module Percolation
export simplenn, simplennn
export checksite, checkallsite, MakeSimpleLattice, PercolationPlot, percolation, percolationgif
    
    import PyPlot
    using LaTeXStrings

    include("general/latticetype.jl")
    include("general/checksite.jl")
    include("general/lattice.jl")
    include("general/PercolationPlot.jl")
    include("general/EasyPercolationTest.jl")
    include("general/percolation.jl")
    include("general/percolationgif.jl")

end
