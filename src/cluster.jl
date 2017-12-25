# clustering and check each cluster size.
"""
cluster(Lattice::Lattice)

return percolation or not and each clustersize

"""
function cluster(Lattice::TwoDLattice)
    _N = Lattice.N

    checkallcluster(Lattice)
    maxlabelnum = maximum(Lattice.lattice)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(Lattice.lattice .== i)
    end

    # check percolation or not
    if sum(Lattice.lattice[1,:] ∩ Lattice.lattice[_N, :] ∩ Lattice.lattice[:, 1] ∩ Lattice.lattice[:,_N]) != 0
        perco = 1
    else
        perco = 0
    end

    Lattice.PercolationOrNot = perco
    if clustersize != Vector{Int}() # クラスターがひとつもなかった場合を除く
        Lattice.clustersize = clustersize
        Lattice.clustersizefreq = [(collect(span(Lattice.clustersize))[i], counts(Lattice.clustersize)[i]) for i in 1:length(counts(Lattice.clustersize)) if counts(Lattice.clustersize)[i] != 0]
        
        # cluster numberはpercolationしたがどうかで場合分けしたほうがいい
        Lattice.clusternumber = [(Lattice.clustersizefreq[i][1], Lattice.clustersizefreq[i][2] / Lattice.N^2) for i in 1:length(Lattice.clustersizefreq)]
        Lattice.average_clustersize = sum([(x -> x[1]^2 * x[2])(Lattice.clusternumber[i]) for i in 1:length(Lattice.clusternumber)]) / mean(Lattice.lattice)
    end
    
    # calculate strength.
    # def. The strength of the infinite cluster P(p) is the probability that an arbitrary site belongs to infinite cluster.
    if perco == 0
        Lattice.strength = 0.0
        Lattice.clusternumber = [(Lattice.clustersizefreq[i][1], Lattice.clustersizefreq[i][2] / Lattice.N^2) for i in 1:length(Lattice.clustersizefreq)]
    else
        Lattice.strength = maximum(Lattice.clustersize) / _N^2
    end
    
    return
end

function cluster(Lattice::HighDimLattice)
    _N, dim = Lattice.N, Lattice.dim
    checkallcluster(Lattice)
    maxlabelnum = maximum(Lattice.lattice)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(Lattice.lattice .== i)
    end
    
    # check percolation or not
    if sum( Lattice.lattice[1:_N^(dim-1)] ∩ Lattice.lattice[_N^(dim-1)*(_N-1)+1:end] ) != 0
        perco = 1
    else
        perco = 0
    end
    
    return perco, clustersize
end

###################
# For 2D lattice
###################
    function checkallcluster(lattice::Matrix{Int}, Lattice::TwoDLattice)
        row, column = Lattice.N, Lattice.N
        labelnum = 0
        for i in 1:row, j in 1:column
            if lattice[j,i] == -1
                labelnum += 1
                searchlist = checkcluster(j,i, labelnum, Lattice)
                lattice[j,i] = labelnum
                
                while searchlist != []
                    tmppos = pop!(searchlist)
                    searchlist =  [ searchlist; checkcluster(tmppos[1], tmppos[2], labelnum, Lattice) ]
                    lattice[tmppos...] = labelnum
                end
                
                labelnum += 1
            end
        end
    end

    function checkallcluster(Lattice::squarenn)
        checkallcluster(Lattice.lattice, Lattice)
    end

    function checkallcluster(Lattice::squarennn)
        checkallcluster(Lattice.lattice, Lattice)
    end

    function checkallcluster(Lattice::tri)
        checkallcluster(Lattice.lattice, Lattice)
    end

    function checkallcluster(Lattice::honeycomb)
        checkallcluster(Lattice.lattice, Lattice)
    end

    function checkallcluster(Lattice::kagome)
        checkallcluster(Lattice.lattice, Lattice)
    end




    # square lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarenn)
        (row, column) = Lattice.N, Lattice.N
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == -1
            if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
        end
        
        return searchlist
    end
    

    # square lattice next nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennn)
        (row, column) = Lattice.N, Lattice.N
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == -1
            if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
            if 1 < i && 1 < j && Lattice.lattice[i-1, j-1] == -1; push!(searchlist, [i-1, j-1]); end
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
            if i < row && j < column && Lattice.lattice[i+1, j+1] == -1; push!(searchlist, [i+1, j+1]); end
        end
        
        return searchlist
    end

    # triangular lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::tri)
        (row, column) = Lattice.N, Lattice.N
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == -1
            if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
        end
        
        return searchlist
    end


    # honeycomb lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::honeycomb)
        (row, column) = Lattice.N, Lattice.N
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == -1
            if iseven(i+j)
                if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
                if 1 < i && Lattice.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end
            else
                if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
                if i < row && Lattice.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            end
        end
        
        return searchlist
    end

    # kagome lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::kagome)
        (row, column) = Lattice.N, Lattice.N
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == -1
            if iseven(i+j) # if i and j are both zeros, always lattice[i,j] = 0
                if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
                if i < row && Lattice.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
                if 1 < i && Lattice.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end            
            elseif iseven(i) && isodd(j)
                if i < row && Lattice.lattice[i+1, j] == -1; push!(searchlist, [i+1, j]); end
                if 1 < i && Lattice.lattice[i-1, j] == -1; push!(searchlist, [i-1, j]); end  
                if 1 < i && j < column && Lattice.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
                if i < row && 1 < j && Lattice.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
            else
                if j < column && Lattice.lattice[i, j+1] == -1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == -1; push!(searchlist, [i, j-1]); end
                if 1 < i && j < column && Lattice.lattice[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
                if i < row && 1 < j && Lattice.lattice[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
            end
        end
        
        return searchlist
    end


########################
# For over 3 dimension
########################
    function checkcluster(ind::Int, labelnum::Int,Lattice::simplenn)
        present_place = ind2sub(Lattice.lattice, ind)
        searchlist = Vector{Int}()
        
        if Lattice.lattice[present_place...] == -1
            for i in 1:length(Lattice.NearestNeighborList)
                tempposition = ([present_place...] + Lattice.NearestNeighborList[i])
                if 0 ∉ tempposition && Lattice.N + 1 ∉ tempposition
                    tmpind = sub2ind(Lattice.lattice, tempposition...)
                    push!(searchlist, tmpind)
                end
            end
        end
        
        return searchlist
    end

    function checkallcluster(Lattice::simplenn)
        _N, dim = Lattice.N, Lattice.dim
        labelnum = 1
        
        for ind in 1:_N^dim
            if Lattice.lattice[ind] == -1
                searchlist = checkcluster(ind, labelnum, Lattice)
                Lattice.lattice[ind] = labelnum
                
                while searchlist != []
                    tmpind = pop!(searchlist)
                    searchlist =  [ searchlist; checkcluster(tmpind, labelnum, Lattice) ]
                    Lattice.lattice[tmpind] = labelnum
                end
                
                labelnum += 1
            end
        end

    end




####################################################################################################
# cluster figure
####################################################################################################
" clusterplot(Lattice::Lattice; figsave=false, filename=\"cluster.png\") "
function clusterplot(Lattice::Lattice; figsave=false, filename="cluster.png")
    MaxClusterLabelNum = maximum(Lattice.lattice)
    
    PyPlot.figure(figsize=(7,7))
    for i in 1:MaxClusterLabelNum
#        y, x = ind2sub(Lattice.lattice, findin(Lattice.lattice, i))
        y, x = findn(Lattice.lattice .== i)
        if Lattice.N < 100
            PyPlot.plot(x,y, "o")
        else
            PyPlot.plot(x,y, ".")
        end
    end
    
    PyPlot.axis("equal")
    PyPlot.axis("off")
    
    if Lattice.PercolationOrNot == 1
        PyPlot.title("Percolation !")
    else
        PyPlot.title("Not percolation ")
    end   
    
    if figsave; PyPlot.savefig(filename); end
    
end

"colored by each cluster size"
function clusterplotsize(Lattice::Lattice; figsave=false, filename="cluster.png")
#    colorlist = ["black", "grey", "silver", "rosybrown", "firebrick", "r", "darksalmon", "sienna", "sandybrown", 
#                 "tan", "moccasin", "gold", "darkkhaki", "olivedrab", "chartreuse", "darksage", "lightgreen", "green", 
#                 "mediumseagreen", "mediumaquamarine", "mediumturquoise", "darkslategrey", "c", "cadetblue", "skyblue", 
#                 "dodgerblue", "slategray", "darkblue", "slateblue", "blueviolet", "mediumorchid", "purple", "fuchsia", "hotpink", "pink"]
#    colorlist = ["c", "darksage", "slategray", "olivedrab", "silver", "sandybrown", "grey", "moccasin", "darksalmon", "mediumaquamarine", "darkkhaki", "lightgreen", "darkslategrey", "rosybrown", "black", "mediumturquoise", "gold", "slateblue", "mediumorchid", "skyblue", "mediumseagreen", "hotpink", "cadetblue", "sienna", "chartreuse", "purple", "green", "fuchsia", "dodgerblue", "tan", "blueviolet", "pink", "darkblue", "firebrick", "r"]
    colorlist = ["black", "red", "green", "yellow", "c", "purple", "fuchsia", "orangered", "teal", "grey", "yellowgreen", "violet"]
    MaxClusterSize = maximum(Lattice.clustersize)
    hit = 1
    
    PyPlot.figure(figsize=(7,7))
    for i in 1:MaxClusterSize-1
        if i ∈ Lattice.clustersize
            y, x = ind2sub(Lattice.lattice, findin(Lattice.lattice, findin(Lattice.clustersize, i)))
            PyPlot.plot(x,y, color=colorlist[hit], ".")
            hit = hit % length(colorlist) + 1

        end
    end
    
    PyPlot.axis("equal")
    PyPlot.axis("off")
    
    # maximum cluster is colored by blue.
    y, x = ind2sub(Lattice.lattice, findin(Lattice.lattice, findin(Lattice.clustersize, MaxClusterSize)))
    PyPlot.plot(x,y, "b.")  
    
    if Lattice.PercolationOrNot == 1
        PyPlot.title("Percolation !")
    else
        PyPlot.title("Not percolation ")
    end   
    
    if figsave; PyPlot.savefig(filename); end
    
end
