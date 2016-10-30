module Percolation
export simplenn, simplennn
export checksite, MakeSimpleLattice, PercolationPlot, verticalPercolation, percolation
    
    using PyPlot

    # nearest neighbor
    type simplenn
        N::Int64
        M::Int64
    end

    # next nearest neighbor
    type simplennn
        N::Int64
        M::Int64
    end
    
    include("general/checksite.jl")
    include("general/lattice.jl")
    include("general/PercolationPlot.jl")
    include("general/verticalPercolation.jl")
    include("general/percolation.jl")



end
