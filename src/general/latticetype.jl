# nearest neighbor
type simplenn
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    config::Array{String}
    
    function simplenn(N, M, p)
        lattice, config = MakeSimpleLattice(M, N, p)
        new(N, M, p, lattice, config)
    end
end


# next nearest neighbor
type simplennn
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    config::Array{String}
    
    function simplennn(N, M, p)
        lattice, config = MakeSimpleLattice(M, N, p)
        new(N, M, p, lattice, config)
    end
end


