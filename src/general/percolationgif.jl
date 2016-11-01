function percolationgif(Lattice::SimpleLattice; output_dir="./", color="brg_r", colorbar=true, fps=4, filename="anime.gif")
    output_tempolary_png=tempdir()*"/Percolation_"*randstring()
    (row, column) = (Lattice.N, Lattice.M)
    if 2 ∈ Lattice.lattice[row, :]; hit = 1; else; hit = 0; end
    PercolationPlot(Lattice, hit, 0, output_tempolary_png, color, colorbar)
    PyPlot.clf()
    previous_lattice = ones(Int64, row, column)
    
    PyPlot.ioff()
    indx = 1
    while Lattice.lattice != previous_lattice
        previous_lattice = Lattice.lattice[:,:]
        Lattice.lattice = checkallsite(Lattice)
        if 2 ∈ Lattice.lattice[row, :]; hit = 1; else; hit = 0; end
        PercolationPlot(Lattice, hit, indx, output_tempolary_png, color, colorbar)
        PyPlot.clf()
        indx += 1
    end
    run(`convert -delay $fps $(output_tempolary_png)/*.png $(output_dir)/$filename`)
    rm(output_tempolary_png, force=true, recursive=true)
    close()
    
    gc()
end
