# Square lattice: nearest neighbor, next nearest neighbor
function percolation(Lattice::TwoDLattice; fig=true, water=true, color="brg_r", colorbar=true)
    # test whether vertical percolation or not.
    (row, column) = size(Lattice.lattice)

	templattice = ones(Int, row, column)
	while Lattice.lattice != templattice
		templattice = Lattice.lattice[:,:]
        Lattice.lattice = checkallsite(Lattice)
	end

	if 2 ∈ Lattice.lattice[row,:]; hit = 1; else; hit = 0; end

	if fig
		PercolationPlot(Lattice, hit, water, color, colorbar)
	end

	return hit, Lattice.lattice;
end

# Higher dimensional simple lattice: nearest neighbor
function percolation(Lattice::HighDimLattice; fig=false, water=false, color="brg_r", colorbar=false)
	N, dim = Lattice.N, Lattice.dim
    templattice = ones(Int, [N for i in 1:dim]...)
	while Lattice.lattice != templattice
		templattice = copy(Lattice.lattice)
        Lattice.lattice = checkallsite(Lattice)
	end

    
	if 2 ∈ Lattice.lattice[N^(dim-1)*(N-1)+1:end]; hit = 1; else; hit = 0; end

	if fig && Lattice.dim == 2
		PercolationPlot(Lattice, hit, water, color, colorbar)
	end

	return hit, Lattice.lattice;
end

