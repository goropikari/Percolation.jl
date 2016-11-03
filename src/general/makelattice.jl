# water: 2
# empty: 1
# block: 0

###############################################
#
# For 2D square and triangular lattice 
#
###############################################
function MakeSquareLattice(N::Int, p::Float64)
    M = N
    lattice = ( rand(Float64, N, M) .< p ) * 1

	for i in 1:N, j in 1:M
		if i == 1 && lattice[i,j] == 1; lattice[i,j] = 2; end
    end
    
    return lattice
end


###############################################
#
# For Higher Dimension cubic lattice
#
###############################################
function nearlist(dim)
    list = Array[]
    for i in 1:dim
        listplus = zeros(Int, dim)
        listminus = zeros(Int, dim)
        listplus[i] = 1
        listminus[i] = -1
        push!(list, listplus)
        push!(list, listminus)
    end
    return list
end

function MakeSimpleLattice(N::Int, dim::Int, p::Float64)
    lattice = ( rand([N for i in 1:dim]...) .< p ) * 1
	for i in 1:N^(dim - 1)
		if lattice[i] == 1; lattice[i] = 2; end
    end
    
    NearestNeighborList = nearlist(dim)
    
    return lattice, NearestNeighborList
end
