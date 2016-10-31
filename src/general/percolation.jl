function percolation(N::Int64, M::Int64, p::Float64; fig=true, water=true)

    lattice, config = MakeSimpleLattice(N, M, p)
    
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(lattice)
    if PercOrNot < N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(N,M), "tempolaryString")
	while config != exconfig
		exconfig = config[:,:]
		for i in 1:N, j in 1:M
			if config[i,j] == "water"
				config = checksite(i, j, config)
			end
		end
	end


	if "water" ∈ config[N,:]
		hit = 1
	else
		hit = 0
	end

	if fig
		PercolationPlot(N, M, p, lattice, config, hit, waterplot=water)
	end

	return hit, lattice, config;
end



function percolation(N::Int64, p::Float64; fig=true, water=true)
    M = N
    lattice, config = MakeSimpleLattice(N, M, p)
    
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(lattice)
    if PercOrNot < N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(N,M), "tempolaryString")
	while config != exconfig
		exconfig = config[:,:]
		for i in 1:N, j in 1:M
			if config[i,j] == "water"
				config = checksite(i, j, config)
			end
		end
	end


	if "water" ∈ config[N,:]
		hit = 1
	else
		hit = 0
	end

	if fig
		PercolationPlot(N, M, p, lattice, config, hit, waterplot=water)
	end

	return hit, lattice, config;    
end


# add site option: nearest neighbor, next nearest neighbor
function percolation(SimpleLattice::simplenn; fig=true, water=true)
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(SimpleLattice)
    if PercOrNot < SimpleLattice.N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(SimpleLattice.N, SimpleLattice.M), "tempolaryString")
	while SimpleLattice.config != exconfig
		exconfig = SimpleLattice.config[:,:]
		for i in 1:SimpleLattice.N, j in 1:SimpleLattice.M
			if SimpleLattice.config[i,j] == "water"
				SimpleLattice.config = checksite(i, j, SimpleLattice)
			end
		end
	end


	if "water" ∈ SimpleLattice.config[SimpleLattice.N,:]
		hit = 1
	else
		hit = 0
	end

	if fig
		PercolationPlot(SimpleLattice, hit, water)
	end

	return hit, SimpleLattice.lattice, SimpleLattice.config;
end





function percolation(SimpleLattice::simplennn, p::Float64; fig=true, water=true)
    (N, M) = (SimpleLattice.N, SimpleLattice.M)
    lattice, config = MakeSimpleLattice(N, M, p)
    
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(lattice)
    if PercOrNot < N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(N,M), "tempolaryString")
	while config != exconfig
		exconfig = config[:,:]
		for i in 1:N, j in 1:M
			if config[i,j] == "water"
				config = checksite(i, j, config, SimpleLattice)
			end
		end
	end


	if "water" ∈ config[N,:]
		hit = 1
	else
		hit = 0
	end

	if fig
		PercolationPlot(SimpleLattice, p, lattice, config, hit, waterplot=water)
	end

	return hit, lattice, config;
end


