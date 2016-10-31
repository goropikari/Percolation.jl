# Simple lattice: nearest neighbor, next nearest neighbor
function percolation(SimpleLattice; fig=true, water=true)
    # test whether vertical percolation or not.
    (row, column) = size(SimpleLattice.lattice)

	exconfig = fill!(Array{String}(row, column), "tempolaryString")
	while SimpleLattice.config != exconfig
		exconfig = SimpleLattice.config[:,:]
        SimpleLattice.config = checkallsite(SimpleLattice)
	end

	if "water" ∈ SimpleLattice.config[row,:]; hit = 1; else; hit = 0; end

	if fig
		PercolationPlot(SimpleLattice, hit, water)
	end

	return hit, SimpleLattice.lattice, SimpleLattice.config;
end
