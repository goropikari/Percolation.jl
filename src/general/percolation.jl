# Simple lattice: nearest neighbor, next nearest neighbor
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



function percolation(SimpleLattice::simplennn; fig=true, water=true)
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(SimpleLattice.lattice)
    if PercOrNot < SimpleLattice.N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(SimpleLattice.N, SimpleLattice.M), "tempolaryString")
	while SimpleLattice.config != exconfig
		exconfig = SimpleLattice.config[:,:]
        SimpleLattice.config = checkallsite(SimpleLattice)
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


