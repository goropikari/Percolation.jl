
abstract Lattice
abstract SquareLattice <: Lattice
abstract TriangularLattice <: Lattice

##########################
# Square lattice
###########################

# nearest neighbor
type squarenn <: SquareLattice
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    
    function squarenn(N, M, p)
        lattice = MakeSquareLattice(M, N, p)
        new(N, M, p, lattice)
    end
end


# next nearest neighbor
type squarennn <: SquareLattice
	N::Int64
	M::Int64
    p::Float64
    lattice::Array{Int64}
    
    function squarennn(N, M, p)
        lattice = MakeSquareLattice(M, N, p)
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
        lattice = MakeSquareLattice(M, N, p)
        new(N, M, p, lattice)
    end
end
