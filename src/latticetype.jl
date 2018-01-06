abstract type Lattice end
abstract type TwoDLattice <: Lattice end

"""
lattice_type::String # square, triangular, honeycomb, kagome\n
linear_size::Int16 # linear size of lattice  \n
p::Float64 # concentration  \n
neighbor::String  # nn:nearest nearest or nnn:next nearest neighbor  \n
\n
clustersize::Vector{Int} # the number of sites belonging to i th cluster.\n
clustersizefreq::Vector{Tuple{Int,Int}}\n
clusternumber::Vector{Tuple{Int,Float64}} # The cluster number n_s(p) denotes the number of s-clusters per lattice site. (s, n_s(p)), http://www.mit.edu/~levitov/8.334/notes/percol_notes.pdf\n
average_clustersize::Float64\n
strength::Float64 # The strength of the infinite cluster P(p) is the probability that an arbitrary site belongs to the infinite cluster.\n
ispercolation::Bool\n
\n
lattice_sites::Matrix{Int}\n
labeled_lattice_sites::Matrix{Int}
"""
struct LatticeConfig
    linear_size::Int16
    p::Float64
    neighbortype::String
    lattice_sites::Matrix{Int}
end

mutable struct LatticeProperties
    clustersize::Vector{Int}
    clustersizefreq::Vector{Tuple{Int,Int}}
    clusternumber::Vector{Tuple{Int,Float64}}
    average_clustersize::Float64
    strength::Float64
    islabeled::Bool
    ispercolation::Bool

    labeled_lattice_sites::Matrix{Int}
end


lattice_types = [:Square, :Triangular, :Honeycomb]
for lattice_type in lattice_types
    eval(quote
        mutable struct $lattice_type <: TwoDLattice
            lattice_config::LatticeConfig
            lattice_properties::LatticeProperties

            function $lattice_type(linear_size, p, neighbortype="nn")
                new(LatticeConfig(linear_size,
                                  p,
                                  neighbortype,
                                  makelattice(linear_size, p)
                                 ),
                    LatticeProperties(Vector{Int}(),
                                      Vector{Tuple{Int,Int}}(),
                                      Vector{Tuple{Int,Float64}}(),
                                      0.0,
                                      0.0,
                                      false,
                                      false,
                                      Matrix{Int}(linear_size, linear_size)
                                     )
                   )
            end
        end
    end)
end

makelattice(linear_size, p) = (rand(linear_size, linear_size) .< p) * 1
