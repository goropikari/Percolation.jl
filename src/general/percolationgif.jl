function percolationgif(Lattice::SimpleLattice; output_dir=tempdir()*"/Percolation_"*randstring(), color="brg_r", colorbar=true, fps=4, filename="anime.gif")
    (row, column) = (Lattice.N, Lattice.M)
    if 2 ∈ Lattice.lattice[row, :]; hit = 1; else; hit = 0; end
    PercolationPlot(Lattice, hit, 0, output_dir, color, colorbar, fps)
    PyPlot.clf()
    previous_lattice = ones(Int64, row, column)
    
    PyPlot.ioff()
    indx = 1
    while Lattice.lattice != exconfig
        exconfig = Lattice.lattice[:,:]
        Lattice.lattice = checkallsite(Lattice)
        if 2 ∈ Lattice.lattice[row, :]; hit = 1; else; hit = 0; end
        PercolationPlot(Lattice, hit, indx, output_dir, color, colorbar, fps)
        PyPlot.clf()
        indx += 1
    end
    run(`convert -delay $fps $output_dir/*.png $filename`)
    rm(output_dir, force=true, recursive=true)
    close()
    
    gc()
end
