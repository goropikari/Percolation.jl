# water: 2
# empty: 1
# block: 0
function MakeSimpleLattice(N::Int64, M::Int64, p::Float64)
    lattice = ( rand(Float64, N,M) .< p ) * 1

	for i in 1:N, j in 1:M
		if i == 1 && lattice[i,j] == 1; lattice[i,j] = 2; end
    end
    
    return lattice
end
