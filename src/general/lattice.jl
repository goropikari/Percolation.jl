function MakeSimpleLattice(N::Int64, M::Int64, p::Float64)
    lattice = ( rand(N,M) .< p ) * 1
	config = Array{String}(N, M)
	for i in 1:N, j in 1:M
		if i == 1 && lattice[i,j] == 1
			config[i,j] = "water"
		elseif lattice[i,j] == 1
			config[i,j] = "block"
		else
			config[i,j] = "empty"
		end
	end
    
    return lattice, config
end

function MakeSimpleLattice(SimpleLattice::simplennn)
    MakeSimpleLattice(SimpleLattice.N, SimpleLattice.M, SimpleLattice.p)
end
