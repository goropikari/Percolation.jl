# Square lattice: nearest neighbor, next nearest neighbor
function percolation(Lattice::Lattice; fig=true, water=true, color="brg_r", colorbar=true)
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
