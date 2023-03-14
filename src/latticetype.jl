export Square, Triangular, Honeycomb, Forest

abstract type Lattice end
abstract type TwoDLattice <: Lattice end

"""
lattice_type::String # square, triangular, honeycomb, kagome\n
linear_size::Int # linear size of lattice  \n
p::Float64 # concentration  \n
neighbor::String  # nn:nearest nearest or nnn:next nearest neighbor  \n
\n
clustersize::Vector{Int} # the number of sites belonging to i th cluster.\n
clustersizefreq::Vector{Tuple{Int,Int}}\n
clusternumber::Vector{Tuple{Int,Float64}} # The cluster number n_s(p) denotes the number of s-clusters per lattice site.
                                          # (s, n_s(p)), http://www.mit.edu/~levitov/8.334/notes/percol_notes.pdf\n
average_clustersize::Float64\n
strength::Float64 # The strength of the infinite cluster P(p) is the probability that an arbitrary site belongs to the infinite cluster.\n
ispercolation::Bool\n
ncluster::Int # The number of clusters
\n
lattice_sites::Matrix{Int8}\n
labeled_lattice_sites::Matrix{Int}
"""
struct LatticeConfig
    linear_size::Int
    p::Float64
    neighbortype::String
    lattice_sites::Matrix{Int8}
end

mutable struct LatticeProperties
    percoclustersize::Int
    percoclusterlabel::Int
    clustersize::Vector{Int}
    clustersizefreq::Dict{Int, Int}
    clusternumber::Dict{Int,Float64}
    average_clustersize::Float64
    strength::Float64
    islabeled::Bool
    ispercolation::Bool
    ispercolationcheck::Bool
    isclustersizecheck::Bool
    isclustersizefreqcheck::Bool
    isclusternumbercheck::Bool
    isaverage_clustersizecheck::Bool
    isstrengthcheck::Bool
    nclusters::Int

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
                    LatticeProperties(0,                                    # percoclustersize
                                      0,                                    # percoclusterlabel
                                      Vector{Int}(),                        # clustersize
                                      Dict{Int, Int}(),                     # clustersizefreq
                                      Dict{Int,Float64}(),                  # clusternumber
                                      0.0,                                  # average_clustersize
                                      0.0,                                  # strength
                                      false,                                # islabeled
                                      false,                                # ispercolation
                                      false,                                # ispercolationcheck
                                      false,                                # isclustersize
                                      false,                                # isclustersizefreq
                                      false,                                # isclusternumber
                                      false,                                # isaverage_clustersize
                                      false,                                # isstrength
                                      0,                                    # nclusters
                                      Array{Int64,2}(undef,linear_size, linear_size) # labeled_lattice_sites
                                     )
                   )
            end
        end
    end)
end

makelattice(linear_size, p) = (rand(linear_size, linear_size) .< p) * Int8(1)
