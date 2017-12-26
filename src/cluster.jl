# clustering and check each cluster size.
"""
cluster!(site::Lattice)

return percolation or not and each clustersize

"""
function cluster!(site::TwoDLattice)
    _N = site.N

    checkallcluster!(site)
    maxlabelnum = maximum(site.lattice)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(site.lattice .== i)
    end

    # check percolation or not
    if sum(site.lattice[1,:] ∩ site.lattice[_N, :] ∩ site.lattice[:, 1] ∩ site.lattice[:,_N]) != 0
        site.ispercolation = true
    else
        site.ispercolation = false
    end

    site.ispercolation
    if clustersize != Vector{Int}() # クラスターがひとつもなかった場合を除く
        site.clustersize = clustersize
        site.clustersizefreq = [(collect(span(site.clustersize))[i], counts(site.clustersize)[i]) for i in 1:length(counts(site.clustersize)) if counts(site.clustersize)[i] != 0]

        # cluster numberはpercolationしたがどうかで場合分けしたほうがいい
        site.clusternumber = [(site.clustersizefreq[i][1], site.clustersizefreq[i][2] / site.N^2) for i in 1:length(site.clustersizefreq)]
        site.average_clustersize = sum([(x -> x[1]^2 * x[2])(site.clusternumber[i]) for i in 1:length(site.clusternumber)]) / mean(site.lattice)
    end

    # calculate strength.
    # def. The strength of the infinite cluster P(p) is the probability that an arbitrary site belongs to infinite cluster.
    if site.ispercolation
        site.strength = 0.0
        site.clusternumber = [(site.clustersizefreq[i][1], site.clustersizefreq[i][2] / site.N^2) for i in 1:length(site.clustersizefreq)]
    else
        site.strength = maximum(site.clustersize) / _N^2
    end

    return
end

function cluster!(site::HighDimLattice)
    _N, dim = site.N, site.dim
    checkallcluster!(site)
    maxlabelnum = maximum(site.lattice)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(site.lattice .== i)
    end

    # check percolation or not
    if sum( site.lattice[1:_N^(dim-1)] ∩ site.lattice[_N^(dim-1)*(_N-1)+1:end] ) != 0
        site.ispercolation = true
    else
        site.ispercolation = false
    end

    site.clustersize = clustersize
    
    return
end

###################
# For 2D lattice
###################
function checkallcluster!(lattice::Matrix{Int}, site::TwoDLattice)
    row = column = site.N
    labelnum = 0
    for i in 1:row, j in 1:column
        if lattice[j,i] == -1
            labelnum += 1
            searchlist = checkcluster!(j,i, labelnum, site)
            lattice[j,i] = labelnum

            while searchlist != []
                tmppos = pop!(searchlist)
                searchlist =  [ searchlist; checkcluster!(tmppos[1], tmppos[2], labelnum, site) ]
                lattice[tmppos...] = labelnum
            end

            labelnum += 1
        end
    end
end

function checkallcluster!(site::Squarenn)
    checkallcluster!(site.lattice, site)
end

function checkallcluster!(site::Squarennn)
    checkallcluster!(site.lattice, site)
end

function checkallcluster!(site::Tri)
    checkallcluster!(site.lattice, site)
end

function checkallcluster!(site::Honeycomb)
    checkallcluster!(site.lattice, site)
end

function checkallcluster!(site::Kagome)
    checkallcluster!(site.lattice, site)
end




# square lattice nearest neighbor
function checkcluster!(i::Int, j::Int, labelnum::Int, site::Squarenn)
    (row, column) = site.N, site.N
    searchlist = Array{Array{Int64, 1}, 1}()

    if site.lattice[i,j] == -1
        if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
        if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
        if i < row && site.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
        if 1 < i && site.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
    end

    return searchlist
end


# square lattice next nearest neighbor
function checkcluster!(i::Int, j::Int, labelnum::Int, site::Squarennn)
    (row, column) = site.N, site.N
    searchlist = Array{Array{Int64, 1}, 1}()

    if site.lattice[i,j] == -1
        if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
        if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
        if i < row && site.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
        if 1 < i && site.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
        if 1 < i && 1 < j && site.lattice[i-1, j-1] == -1; push!(searchlist, [i-1, j-1]); end
        if 1 < i && j < column && site.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
        if i < row && 1 < j && site.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
        if i < row && j < column && site.lattice[i+1, j+1] == -1; push!(searchlist, [i+1, j+1]); end
    end

    return searchlist
end

# triangular lattice nearest neighbor
function checkcluster!(i::Int, j::Int, labelnum::Int, site::Tri)
    (row, column) = site.N, site.N
    searchlist = Array{Array{Int64, 1}, 1}()

    if site.lattice[i,j] == -1
        if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
        if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
        if i < row && site.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
        if 1 < i && site.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
        if 1 < i && j < column && site.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
        if i < row && 1 < j && site.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
    end

    return searchlist
end


# honeycomb lattice nearest neighbor
function checkcluster!(i::Int, j::Int, labelnum::Int, site::Honeycomb)
    (row, column) = site.N, site.N
    searchlist = Array{Array{Int64, 1}, 1}()

    if site.lattice[i,j] == -1
        if iseven(i+j)
            if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if 1 < i && site.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
        else
            if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if i < row && site.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
        end
    end

    return searchlist
end

# kagome lattice nearest neighbor
function checkcluster!(i::Int, j::Int, labelnum::Int, site::Kagome)
    (row, column) = site.N, site.N
    searchlist = Array{Array{Int64, 1}, 1}()

    if site.lattice[i,j] == -1
        if iseven(i+j) # if i and j are both zeros, always lattice[i,j] = 0
            if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if i < row && site.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            if 1 < i && site.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end            
        elseif iseven(i) && isodd(j)
            if i < row && site.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            if 1 < i && site.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end  
            if 1 < i && j < column && site.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && site.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
        else
            if j < column && site.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && site.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if 1 < i && j < column && site.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && site.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
        end
    end

    return searchlist
end


########################
# For over 3 dimension
########################
function checkcluster!(ind::Int, labelnum::Int,site::Simplenn)
    present_place = ind2sub(site.lattice, ind)
    searchlist = Vector{Int}()
    
    if site.lattice[present_place...] == -1
        for i in 1:length(site.NearestNeighborList)
            tempposition = ([present_place...] + site.NearestNeighborList[i])
            if 0 ∉ tempposition && site.N + 1 ∉ tempposition
                tmpind = sub2ind(site.lattice, tempposition...)
                push!(searchlist, tmpind)
            end
        end
    end
    
    return searchlist
end

function checkallcluster!(site::Simplenn)
    _N, dim = site.N, site.dim
    labelnum = 1
    
    for ind in 1:_N^dim
        if site.lattice[ind] == -1
            searchlist = checkcluster!(ind, labelnum, site)
            site.lattice[ind] = labelnum
            
            while searchlist != []
                tmpind = pop!(searchlist)
                searchlist =  [ searchlist; checkcluster!(tmpind, labelnum, site) ]
                site.lattice[tmpind] = labelnum
            end
            
            labelnum += 1
        end
    end

end




####################################################################################################
# cluster figure
####################################################################################################
" clusterplot(site::Lattice; figsave=false, filename=\"cluster.png\") "
function clusterplot(site::Lattice; figsave=false, filename="cluster.png")
    maxlabelnum = maximum(site.lattice)
    tmplattice = copy(site.lattice)
    PyPlot.figure(figsize=(7,7))
    tmplattice *= -1
    shufflelabel = Dict(i=>j for (i,j) in zip(-maxlabelnum:-1, shuffle(1:maxlabelnum)))
    for i in -maxlabelnum:-1
        tmplattice[tmplattice .== i] = shufflelabel[i]
    end
    
    PyPlot.imshow(tmplattice, cmap="gist_ncar")
    PyPlot.axis("equal")
    PyPlot.axis("off")
    if site.ispercolation
        PyPlot.title("Percolation!")
    else
        PyPlot.title("Not percolation")
    end   

    if figsave; PyPlot.savefig(filename); end
end

"colored by each cluster size"
function clusterplotsize(site::Lattice; figsave=false, filename="cluster.png")
#    colorlist = ["black", "grey", "silver", "rosybrown", "firebrick", "r", "darksalmon", "sienna", "sandybrown", 
#                 "tan", "moccasin", "gold", "darkkhaki", "olivedrab", "chartreuse", "darksage", "lightgreen", "green", 
#                 "mediumseagreen", "mediumaquamarine", "mediumturquoise", "darkslategrey", "c", "cadetblue", "skyblue", 
#                 "dodgerblue", "slategray", "darkblue", "slateblue", "blueviolet", "mediumorchid", "purple", "fuchsia", "hotpink", "pink"]
#    colorlist = ["c", "darksage", "slategray", "olivedrab", "silver", "sandybrown", "grey", "moccasin", "darksalmon", "mediumaquamarine", "darkkhaki", "lightgreen", "darkslategrey", "rosybrown", "black", "mediumturquoise", "gold", "slateblue", "mediumorchid", "skyblue", "mediumseagreen", "hotpink", "cadetblue", "sienna", "chartreuse", "purple", "green", "fuchsia", "dodgerblue", "tan", "blueviolet", "pink", "darkblue", "firebrick", "r"]
    colorlist = ["black", "red", "green", "yellow", "c", "purple", "fuchsia", "orangered", "teal", "grey", "yellowgreen", "violet"]
    MaxClusterSize = maximum(site.clustersize)
    hit = 1
    
    PyPlot.figure(figsize=(7,7))
    for i in 1:MaxClusterSize-1
        if i ∈ site.clustersize
            y, x = ind2sub(site.lattice, findin(site.lattice, findin(site.clustersize, i)))
            PyPlot.plot(x,y, color=colorlist[hit], ".")
            hit = hit % length(colorlist) + 1

        end
    end
    
    PyPlot.axis("equal")
    PyPlot.axis("off")
    
    # maximum cluster is colored by blue.
    y, x = ind2sub(site.lattice, findin(site.lattice, findin(site.clustersize, MaxClusterSize)))
    PyPlot.plot(x,y, "b.")  
    
    if site.ispercolation
        PyPlot.title("Percolation !")
    else
        PyPlot.title("Not percolation ")
    end   
    
    if figsave; PyPlot.savefig(filename); end
    
end
