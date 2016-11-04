# Square lattice: nearest neighbor, next nearest neighbor
function percolation(Lattice::TwoDLattice; fig=true, water=true, color="brg_r", colorbar=true)
    # test whether vertical percolation or not.
    const row = Lattice.N
    const column = Lattice.N

	templattice = ones(Int, row, column)
	while Lattice.lattice != templattice
		templattice = Lattice.lattice[:,:]
        Lattice.lattice = checkallsite(Lattice)
	end

	if 2 ∈ Lattice.lattice[row,:]; hit = 1; else; hit = 0; end

	if fig
		PercolationPlot(Lattice, hit, water, color, colorbar)
	end

	return hit
end

# more fast computing
function percolation(Lattice::squarennrec; fig=true, water=true, color="brg_r", colorbar=true)
    # test whether vertical percolation or not.
    const row = Lattice.N
    const column = Lattice.N

    i = 1
    for j in 1:row
        checksitennrec(i, j, Lattice.lattice, Lattice.visit)
    end
        

	if 2 ∈ Lattice.lattice[row,:]; hit = 1; else; hit = 0; end

	if fig
		PercolationPlot(Lattice, hit, water, color, colorbar)
	end

	return hit
end

# if you encounter StackOverflowError when you use squarennrec, use squarennpos
function percolation(Lattice::squarennpos; fig=true, water=true, color="brg_r", colorbar=true)
	_N = Lattice.N
    checklist = Array{Int64,1}[]
    i = 1
    for j in 1:_N
        checksitennpos(i, j, Lattice.lattice, Lattice.visit, checklist)
    end
    
    while checklist != []
        tmppos = pop!(checklist)
        checksitennpos(tmppos[1], tmppos[2], Lattice.lattice, Lattice.visit, checklist)
    end
    
	if 2 ∈ Lattice.lattice[_N, :]; hit = 1; else; hit = 0; end
    
    if fig
		PercolationPlot(Lattice, hit, water, color, colorbar)
	end


	return hit
end



#######################################################################################
# Higher dimensional simple lattice: nearest neighbor
#######################################################################################
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

	return hit
end

# more fast computing
function percolation(Lattice::simplennrec)
	N, dim = Lattice.N, Lattice.dim
    for i in 1:N^(dim-1)
        checksitesimplennrec(i, Lattice)
        if 2 ∈ Lattice.lattice[N^(dim-1)*(N-1)+1:end]; return hit = 1; end
    end

    
	if 2 ∈ Lattice.lattice[N^(dim-1)*(N-1)+1:end]; hit = 1; else; hit = 0; end


	return hit
end


# if you encounter StackOverflowError when you use simplennrec, use simplennpos
function percolation(Lattice::simplennpos)
	_N, dim = Lattice.N, Lattice.dim
    checklist = Array{Int64, 1}()
    
    for i in 1:_N^(dim-1)
        checksitesimplennpos(i, Lattice, checklist)
    end

    while checklist != []
        tmppos = pop!(checklist)
        checksitesimplennpos(tmppos, Lattice, checklist)
    end
    
	if 2 ∈ Lattice.lattice[_N^(dim-1)*(_N-1)+1:end]; hit = 1; else; hit = 0; end


	return hit
end

