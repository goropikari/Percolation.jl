function percolationgif(N::Int64, M::Int64, p::Float64; output_dir="Percolation_pic")
    
    lattice, config = MakeSimpleLattice(N, M, p)
    PercolationPlot(N, M, p, lattice, config, 0, 0)
    clf()
    exconfig = fill!(Array{String}(N,M), "tempolaryString")
    
    indx = 0
    while config != exconfig
        exconfig = config[:,:]
        config = checkallsite(config)
        if "water" ∈ config[N,:]; hit = 1; else; hit = 0; end
        PercolationPlot(N, M, p, lattice, config, hit, indx, dirname=output_dir)
        clf()
        indx += 1
    end
    gc()
end
