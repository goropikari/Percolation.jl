export ispercolation!, clustersize!, clustersizefreq!, clusternumber!, average_clustersize!, strength!

"""
ispercolation!(latt::TwoDLattice)

check whether the system is percolated or not.
"""
function ispercolation!(latt::TwoDLattice)
    if latt.lattice_properties.ispercolationcheck
        return latt.lattice_properties.ispercolation
    end
    latt.lattice_properties.ispercolationcheck = true

    if !latt.lattice_properties.islabeled
        label_components!(latt)
        latt.lattice_properties.islabeled = true
    end

    labeled_site = latt.lattice_properties.labeled_lattice_sites

    tmpset = (Set(labeled_site[1,:]) ∩ Set(labeled_site[end,:])) ∩ (Set(labeled_site[:,1]) ∩ Set(labeled_site[:,end]))
    setdiff!(tmpset, 0)
    latt.lattice_properties.ispercolation = ifelse(isempty(tmpset), false, true)
    if latt.lattice_properties.ispercolation
        percoclusterlabel = pop!(tmpset)
        latt.lattice_properties.percoclusterlabel = percoclusterlabel
        latt.lattice_properties.percoclustersize = sum(latt.lattice_properties.labeled_lattice_sites .== percoclusterlabel)
    end

    return latt.lattice_properties.ispercolation
end


"""
clustersize!(latt::Lattice)

check each cluster size.
"""
function clustersize!(latt::Lattice)
    if latt.lattice_properties.isclustersizecheck
        return latt.lattice_properties.clustersize
    end
    latt.lattice_properties.isclustersizecheck = true

    if !latt.lattice_properties.islabeled
        label_components!(latt)
    end

    clustersize = zeros(Int, latt.lattice_properties.nclusters)
    for i in 1:latt.lattice_config.linear_size^2
        sitei = latt.lattice_properties.labeled_lattice_sites[i]
        if sitei != 0 && sitei != latt.lattice_properties.percoclusterlabel
            clustersize[latt.lattice_properties.labeled_lattice_sites[i]] += 1
        end
    end

    latt.lattice_properties.clustersize = clustersize

    return latt.lattice_properties.clustersize
end


"""
clustersizefreq!(latt::Lattice)

check the cluster size distribution.
"""
function clustersizefreq!(latt::Lattice)
    if latt.lattice_properties.isclustersizefreqcheck
        return latt.lattice_properties.clustersizefreq
    end

    if !latt.lattice_properties.isclustersizecheck
        clustersize!(latt)
    end

    latt.lattice_properties.clustersizefreq = delete!(countmap(latt.lattice_properties.clustersize), 0)
    latt.lattice_properties.isclustersizefreqcheck = true

    return latt.lattice_properties.clustersizefreq
end

"""
clusternumber!(latt::Lattice)

Cluster Number \$n_s\$ is the probability that a occupied site belonging to s-cluster.
Formal definition of cluster number is defined by exclunding the percolation cluster.
But in this calculation, it is included.
"""
function clusternumber!(latt::Lattice)
    if latt.lattice_properties.isclusternumbercheck
        return latt.lattice_properties.clusternumber
    end

    clustersizefreq!(latt)
    clusternumber = Dict(key => latt.lattice_properties.clustersizefreq[key] / latt.lattice_config.linear_size^2
                         for key in keys(latt.lattice_properties.clustersizefreq))
    latt.lattice_properties.clusternumber = clusternumber
    latt.lattice_properties.isclusternumbercheck = true

    return latt.lattice_properties.clusternumber
end

"""
average_clustersize!(latt::Lattice)

Average cluster size \$S\$ is defined by
\$S = \\frac{\\sum_{s=1} s^2 n_s}{p}\$.
"""
function average_clustersize!(latt::Lattice)
    if latt.lattice_properties.isaverage_clustersizecheck
        return latt.lattice_properties.average_clustersize
    end

    if !latt.lattice_properties.isclusternumbercheck
        clusternumber!(latt)
    end

    clusternumberdict = latt.lattice_properties.clusternumber
    average_clustersize = sum(collect(keys(clusternumberdict)).^2 .* collect(values(clusternumberdict))
                             ) / latt.lattice_config.p
    latt.lattice_properties.average_clustersize = average_clustersize

    return latt.lattice_properties.average_clustersize
end


"""
strength!(latt::Lattice)

Strength \$P(p)\$ is the probability that an arbitrary site belongs to the percolating cluster.  

\$P(p) = \\frac{\\text{# of sites in percolating cluster with occupied probability}~ p}{L^2}\$  where \$L\$ is the system linear size
"""
function strength!(latt::Lattice)
    if latt.lattice_properties.isstrengthcheck
        return latt.lattice_properties.strength
    end

    if ispercolation!(latt)
       latt.lattice_properties.strength = latt.lattice_properties.percoclustersize / latt.lattice_config.linear_size^2
    end

    return latt.lattice_properties.strength
end
