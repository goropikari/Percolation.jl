#######################################################################################
# Square and triangular lattice: nearest neighbor, next nearest neighbor
#######################################################################################
function percolation(Lattice::TwoDLattice; fig=true, water=true, color="seismic_r", colorbar=false)
    _N = Lattice.N
    checkallsite(Lattice)

	if 2 ∈ Lattice.lattice[_N, :]; hit = 1; else; hit = 0; end

    if fig
		PercolationPlot(Lattice, hit, water, color, colorbar)
	end

	return hit
end


#######################################################################################
# Higher dimensional simple lattice: nearest neighbor
#######################################################################################
function percolation(Lattice::simplenn)
    _N, dim = Lattice.N, Lattice.dim
    checkallsite(Lattice)

	if 2 ∈ Lattice.lattice[_N^(dim-1)*(_N-1)+1:end]; hit = 1; else; hit = 0; end

	return hit
end
