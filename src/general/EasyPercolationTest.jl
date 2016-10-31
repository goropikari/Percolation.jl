# easy percolation test
function EasyPercolationTest(lattice::Array{Int64})
    (N,M) = size(lattice)
    test = ones(Int64, M)
	hit = 1
	for i in 1:N-1
		( findn(lattice[i, :]) ∩ findn(lattice[i+1, :]) ) == [] && break
		hit += 1
	end

	if hit < N
		return 0
	end
    
    return hit
end

function EasyPercolationTest(SimpleLattice::simplenn)
    EasyPercolationTest(SimpleLattice.lattice::Array{Int64})
end

function EasyPercolationTest(SimpleLattice::simplennn)
    EasyPercolationTest(SimpleLattice.lattice::Array{Int64})
end
