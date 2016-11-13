###############################################
# For 2D square and triangular lattice 
###############################################
function MakeLattice(_N::Int, probability::Float64)
    lattice = ( rand(Float64, _N, _N) .< probability ) * 1
    return lattice
end


###############################################
# For Higher Dimension cubic lattice
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
    NearestNeighborList = nearlist(dim)
    return lattice, NearestNeighborList
end
