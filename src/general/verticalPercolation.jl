function verticalPercolation(lattice::Array{Int64})
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

function verticalPercolation(SiteSize::testnn)
    test = ones(Int64, SiteSize.M)
	hit = 1
	for i in 1:SiteSize.N-1
		( findn(SiteSize.lattice[i, :]) ∩ findn(SiteSize.lattice[i+1, :]) ) == [] && break
		hit += 1
	end

	if hit < SiteSize.N
		return 0
	end
    
    return hit
end
