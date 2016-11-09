abstract Lattice
abstract TwoDLattice <: Lattice
abstract SquareLattice <: TwoDLattice
abstract TriangularLattice <: TwoDLattice
abstract HighDimLattice <: Lattice

##########################
# Square lattice
###########################
    # nearest neighbor
    type squarenn <: SquareLattice
        N::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        
        function squarenn(N, p)
            lattice = MakeSquareLattice(N, p)
            visit = zeros(Int, N, N)
            new(N, p, lattice, visit)
        end
    end

    type squarennrec <: SquareLattice
        N::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        
        function squarennrec(N, p)
            lattice = MakeSquareLattice(N, p)
            visit = zeros(Int, N, N)
            new(N, p, lattice, visit)
        end
    end


    # next nearest neighbor
    type squarennn <: SquareLattice
        N::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        
        function squarennn(N, p)
            lattice = MakeSquareLattice(N, p)
            visit = zeros(Int, N, N)
            new(N, p, lattice, visit)
        end
    end
    
    type squarennnrec <: SquareLattice
        N::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        
        function squarennnrec(N, p)
            lattice = MakeSquareLattice(N, p)
            visit = zeros(Int, N, N)
            new(N, p, lattice, visit)
        end
    end


###########################
# Triangular lattice
###########################
    type trinn <: TriangularLattice
        N::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        
        function trinn(N, p)
            lattice = MakeSquareLattice(N, p)
            visit = zeros(Int, N, N)
            new(N, p, lattice, visit)
        end
    end

    type trinnrec <: TriangularLattice
        N::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        
        function trinnrec(N, p)
            lattice = MakeSquareLattice(N, p)
            visit = zeros(Int, N, N)
            new(N, p, lattice, visit)
        end
    end

###########################
# Z^d lattice
###########################
    type simplenn <: HighDimLattice
        N::Int
        dim::Int
        p::Float64
        lattice::Array{Int}
        visit::Array{Int}
        NearestNeighborList::Array{Array,1}
        
        function simplenn(N, dim, p)
            lattice, NearestNeighborList = MakeSimpleLattice(N, dim, p)
            visit = zeros(Int, [N for i in 1:dim]...)
            new(N, dim, p, lattice, visit, NearestNeighborList)
        end
    end
