module Percolation

# type
export squarenn, squarennn, trinn, simplenn, squarennrec, simplennrec

# function
export checksite, checkallsite, MakeSquareLattice, PercolationPlot, percolation, percolationgif
    
    import PyPlot
    using LaTeXStrings

    include("general/latticetype.jl")
    include("general/checksite.jl")
    include("general/makelattice.jl")
    include("general/PercolationPlot.jl")
    include("general/EasyPercolationTest.jl")
    include("general/percolation.jl")
    include("general/percolationgif.jl")

end
