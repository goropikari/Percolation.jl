
abstract Lattice
abstract SquareLattice <: Lattice
abstract TriangularLattice <: Lattice
abstract TwoDimLattice <: Lattice

##########################
# Square lattice
###########################

# nearest neighbor
type squarenn <: SquareLattice
	N::Int
	M::Int
    p::Float64
    lattice::Array{Int}
    
    function squarenn(N, M, p)
        lattice = MakeSquareLattice(M, N, p)
        new(N, M, p, lattice)
    end
end


# next nearest neighbor
type squarennn <: SquareLattice
	N::Int
	M::Int
    p::Float64
    lattice::Array{Int}
    
    function squarennn(N, M, p)
        lattice = MakeSquareLattice(M, N, p)
        new(N, M, p, lattice)
    end
end


###########################
# Triangular lattice
###########################
type trinn <: TriangularLattice
	N::Int
	M::Int
    p::Float64
    lattice::Array{Int}
    
    function trinn(N, M, p)
        lattice = MakeSquareLattice(M, N, p)
        new(N, M, p, lattice)
    end
end


###########################
# Z^d lattice
###########################
type simplenn <: TwoDimLattice
	N::Int
    dim::Int
    p::Float64
    lattice::Array{Int}
    
    function simplenn(N, dim, p)
        lattice = MakeSimpleLattice(N, dim, p)
        new(N, dim, p, lattice)
    end
end
