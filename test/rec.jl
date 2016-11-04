type simplennrec
	N::Int
    dim::Int
    p::Float64
    lattice::Array{Int}
    visit::Array{Int}
    NearestNeighborList::Array{Array,1}
    
    function simplennrec(N, dim, p)
        lattice = ( rand([N for i in 1:dim]...) .< p ) * 1
        visit = zeros(Int, [N for i in 1:dim]...)
        NearestNeighborList = nearlist(dim)
        new(N, dim, p, lattice, visit, NearestNeighborList)
    end
end

function percolation(Lattice::simplennrec)
	N, dim = Lattice.N, Lattice.dim
    for i in 1:N^(dim-1)
        checksitesimplennrec(i, Lattice)
        if 2 ∈ Lattice.lattice[N^(dim-1)*(N-1)+1:end]; return hit = 1; end
    end

    
	if 2 ∈ Lattice.lattice[N^(dim-1)*(N-1)+1:end]; hit = 1; else; hit = 0; end


	return hit
end

function checksitesimplennrec(ind::Int, Lattice::simplennrec)
    present_place = ind2sub(Lattice.lattice, ind)
    
    if Lattice.lattice[present_place...] == 1 && Lattice.visit[present_place...] == 0
        Lattice.lattice[present_place...] = 2
        Lattice.visit[present_place...] = 1
        
        for i in 1:length(Lattice.NearestNeighborList)
            tempposition = ([present_place...] + Lattice.NearestNeighborList[i])
            if 0 ∉ tempposition && Lattice.N + 1 ∉ tempposition
                tmpind = sub2ind(Lattice.lattice, tempposition...)
                checksitesimplennrec(tmpind, Lattice)
            end
        end
    end
end

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
