# clustering and check each cluster size.
"""
cluster(Lattice::Lattice)

return percolation or not and each clustersize


"""
function cluster(Lattice::Lattice)
    checkallcluster(Lattice)
    maxlabelnum = maximum(Lattice.visit)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(Lattice.visit .== i)
    end
    
    # check percolation or not
    if sum(Lattice.visit[1,:] ∩ Lattice.visit[ size(Lattice.lattice)[1], :] ) != 0
        perco = true
    else
        perco = false
    end
    
    return perco, clustersize
end


function checkallcluster(lattice::Matrix{Int}, visit::Matrix{Int}, Lattice::TwoDLattice)
    (row, column) = size(lattice)
    labelnum = 1
    for i in 1:row, j in 1:column
        if lattice[j,i] == 1 && visit[j,i] == 0
            searchlist = checkcluster(j,i, labelnum, Lattice)
            visit[j,i] = labelnum
            
            while searchlist != []
                tmppos = pop!(searchlist)
                searchlist =  [ searchlist; checkcluster(tmppos[1], tmppos[2], labelnum, Lattice) ]
                visit[tmppos...] = labelnum
            end
            
            labelnum += 1
        end
    end
end

function checkallcluster(Lattice::squarenn)
    checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
end

function checkallcluster(Lattice::squarennn)
    checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
end

function checkallcluster(Lattice::trinn)
    checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
end

#function checkallcluster(Lattice::squarenn)
#    (row, column) = size(Lattice.lattice)
#    labelnum = 1
#    for i in 1:row, j in 1:column
#        if Lattice.lattice[j,i] == 1 && Lattice.visit[j,i] == 0
#            searchlist = checkcluster(j,i, labelnum, Lattice)
#            Lattice.visit[j,i] = labelnum
            
#            while searchlist != []
#                tmppos = pop!(searchlist)
#                searchlist =  [ searchlist; checkcluster(tmppos[1], tmppos[2], labelnum, Lattice) ]
#                Lattice.visit[tmppos...] = labelnum
#            end
            
#            labelnum += 1
#        end
#    end
#end



# square lattice nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarenn)
    (row, column) = size(Lattice.lattice)
    searchlist = Array{Array{Int64, 1}, 1}()
    
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
        if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
        if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
        if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
    end
    
    return searchlist
end

# square lattice next nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennn)
    (row, column) = size(Lattice.lattice)
    searchlist = Array{Array{Int64, 1}, 1}()
    
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
        if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
        if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
        if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
        if 1 < i && 1 < j && Lattice.lattice[i-1, j-1] == 1; push!(searchlist, [i-1, j-1]); end
        if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
        if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
        if i < row && j < column && Lattice.lattice[i+1, j+1] == 1; push!(searchlist, [i+1, j+1]); end
    end
    
    return searchlist
end

# triangular lattice nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::trinn)
    (row, column) = size(Lattice.lattice)
    searchlist = Array{Array{Int64, 1}, 1}()
    
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
        if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
        if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
        if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
        if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
        if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
    end
    
    return searchlist
end





########################################################################################
# recursive function
########################################################################################
function checkallcluster(Lattice::TwoDLattice)
    (row, column) = size(Lattice.lattice)
    labelnum = 1
    for i in 1:row, j in 1:column
        if Lattice.lattice[j,i] == 1 && Lattice.visit[j,i] == 0
            checkcluster(j, i, labelnum, Lattice)
            labelnum += 1
        end
    end
end

# square lattice nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennrec)
    (row,  column) = size(Lattice.lattice)
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        Lattice.visit[i,j] = labelnum
        if j < column; checkcluster(i, j+1, labelnum, Lattice); end
        if 1 < j; checkcluster(i, j-1, labelnum, Lattice); end
        if i < row; checkcluster(i+1, j, labelnum, Lattice); end
        if 1 < i; checkcluster(i-1, j, labelnum, Lattice); end
    end
end

# square lattice next nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennnrec)
    (row,  column) = size(Lattice.lattice)
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        Lattice.visit[i,j] = labelnum
        if j < column; checkcluster(i, j+1, labelnum, Lattice); end
        if 1 < j; checkcluster(i, j-1, labelnum, Lattice); end
        if i < row; checkcluster(i+1, j, labelnum, Lattice); end
        if 1 < i; checkcluster(i-1, j, labelnum, Lattice); end
        if 1 < i && 1 < j; checkcluster(i-1, j-1, labelnum, Lattice); end
        if 1 < i && j < column; checkcluster(i-1, j+1, labelnum, Lattice); end
        if i < row && 1 < j; checkcluster(i+1, j-1, labelnum, Lattice); end
        if i < row && j < column; checkcluster(i+1, j+1, labelnum, Lattice); end
    end
end

# triangular lattice nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::trinnrec)
    (row,  column) = size(Lattice.lattice)
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        Lattice.visit[i,j] = labelnum
        if j < column; checkcluster(i, j+1, labelnum, Lattice); end
        if 1 < j; checkcluster(i, j-1, labelnum, Lattice); end
        if i < row; checkcluster(i+1, j, labelnum, Lattice); end
        if 1 < i; checkcluster(i-1, j, labelnum, Lattice); end
        if 1 < i && j < column; checkcluster(i-1, j+1, labelnum, Lattice); end
        if i < row && 1 < j; checkcluster(i+1, j-1, labelnum, Lattice); end
    end
end




####################################################################################################
# cluster figure
####################################################################################################
function clusterplot(Lattice::Lattice)
    MaxClusterLabelNum = maximum(Lattice.visit)
    for i in 1:MaxClusterLabelNum
        y, x = ind2sub(Lattice.visit, findin(Lattice.visit, i))
        PyPlot.plot(x,y, ".")
        PyPlot.axis("equal")
    end
    
    if sum(Lattice.visit[1,:] ∩ Lattice.visit[ size(Lattice.lattice)[1], :] ) != 0
        PyPlot.title("Percolation !")
    else
        PyPlot.title("Not percolation ")
    end   
    
    
end
