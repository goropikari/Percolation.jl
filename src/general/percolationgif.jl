function percolationgif(SimpleLattice::SimpleLattice; output_dir=tempdir()*"/Percolation_"*randstring(), color="brg_r", colorbar=true, fps=4, filename="anime.gif")
    (row, column) = (SimpleLattice.N, SimpleLattice.M)
    if "water" ∈ SimpleLattice.config[row, :]; hit = 1; else; hit = 0; end
    PercolationPlot(SimpleLattice, hit, 0, output_dir, color, colorbar, fps)
    PyPlot.clf()
    exconfig = fill!(Array{String}(row, column), "tempolaryString")
    
    PyPlot.ioff()
    indx = 1
    while SimpleLattice.config != exconfig
        exconfig = SimpleLattice.config[:,:]
        SimpleLattice.config = checkallsite(SimpleLattice)
        if "water" ∈ SimpleLattice.config[row, :]; hit = 1; else; hit = 0; end
        PercolationPlot(SimpleLattice, hit, indx, output_dir, color, colorbar, fps)
        PyPlot.clf()
        indx += 1
    end
    run(`convert -delay $fps $output_dir/*.png $filename`)
    rm(output_dir, force=true, recursive=true)
    close()
    
    gc()
end
