function percolationgif(SimpleLattice; output_dir="Percolation_pic")
    (row, column) = (SimpleLattice.N, SimpleLattice.M)
    PercolationPlot(SimpleLattice, 0, 0, output_dir)
    clf()
    exconfig = fill!(Array{String}(row, column), "tempolaryString")
    
    indx = 1
    while SimpleLattice.config != exconfig
        exconfig = SimpleLattice.config[:,:]
        config = checkallsite(SimpleLattice)
        if "water" ∈ config[row, :]; hit = 1; else; hit = 0; end
        PercolationPlot(SimpleLattice, hit, indx, output_dir)
        clf()
        indx += 1
    end
    close()
    gc()
end
