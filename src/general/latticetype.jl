
abstract Lattice
abstract SimpleLattice <: Lattice
abstract TriangularLattice <: Lattice

##########################
# Simple lattice
###########################

# nearest neighbor
type simplenn <: SimpleLattice
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    
    function simplenn(N, M, p)
        lattice = MakeSimpleLattice(M, N, p)
        new(N, M, p, lattice)
    end
end


# next nearest neighbor
type simplennn <: SimpleLattice
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    
    function simplennn(N, M, p)
        lattice = MakeSimpleLattice(M, N, p)
        new(N, M, p, lattice)
    end
end


###########################
# Triangular lattice
###########################
type trinn <: TriangularLattice
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    
    function trinn(N, M, p)
        lattice = MakeSimpleLattice(M, N, p)
        new(N, M, p, lattice)
    end
end
