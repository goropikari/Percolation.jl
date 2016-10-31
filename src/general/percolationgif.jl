function percolationgif(SimpleLattice::SimpleLattice; output_dir="Percolation_pic", color="brg_r", colorbar=true, fps=4)
    (row, column) = (SimpleLattice.N, SimpleLattice.M)
    if "water" ∈ SimpleLattice.config[row, :]; hit = 1; else; hit = 0; end
    PercolationPlot(SimpleLattice, hit, 0, output_dir, color, colorbar)
    PyPlot.clf()
    exconfig = fill!(Array{String}(row, column), "tempolaryString")
    
    indx = 1
    while SimpleLattice.config != exconfig
        exconfig = SimpleLattice.config[:,:]
        SimpleLattice.config = checkallsite(SimpleLattice)
        if "water" ∈ SimpleLattice.config[row, :]; hit = 1; else; hit = 0; end
        PercolationPlot(SimpleLattice, hit, indx, output_dir, color, colorbar)
        PyPlot.clf()
        indx += 1
    end
    close()
    
    run(`convert -delay $fps $output_dir/*.png anime.gif`)
    gc()
end
