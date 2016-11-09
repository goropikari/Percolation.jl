# clustering and check each cluster size.
"""
cluster(Lattice::Lattice)

return percolation or not and clustersize


"""
function cluster(Lattice::Lattice)
    checkallcluster(Lattice)
    maxlabelnum = maximum(Lattice.visit)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(Lattice.visit .== i)
    end
    
    # percolation or not
    if sum(Lattice.visit[1,:] ∩ Lattice.visit[ size(Lattice.lattice)[1], :] ) != 0
        perco = true
    else
        perco = false
    end
    
    return perco, clustersize
end


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

function clusterplot(Lattice::Lattice)
    MaxClusterLabelNum = maximum(Lattice.visit)
    for i in 1:MaxClusterLabelNum
        y, x = ind2sub(Lattice.visit, findin(Lattice.visit, i))
        PyPlot.plot(x,y, ".")
        PyPlot.axis("equal")
    end
    
end
