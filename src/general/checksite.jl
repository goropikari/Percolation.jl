# water: 2
# empty: 1
# block: 0

#########################
## For square lattice
#########################
    # nearest neighbor
    function checksite(i::Int, j::Int, Lattice::squarenn, checklist::Array{Array{Int64,1},1})
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.lattice[i,j] = 2
            Lattice.visit[i,j] = 1
            if j < column && Lattice.lattice[i, j+1] == 1; push!(checklist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(checklist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(checklist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(checklist, [i-1, j]); end
        end
    end

    function checkallsite(Lattice::squarenn)
        _N = Lattice.N
        checklist = Array{Int64,1}[]
        i = 1
        for j in 1:_N
            checksite(i, j, Lattice, checklist)
        end
        
        while checklist != []
            tmppos = pop!(checklist)
            checksite(tmppos[1], tmppos[2], Lattice, checklist)
        end
    end

    # next nearest neighbor
    function checksite(i::Int, j::Int, Lattice::squarennn, checklist::Array{Array{Int64,1},1})
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.lattice[i,j] = 2
            Lattice.visit[i,j] = 1
            if j < column && Lattice.lattice[i, j+1] == 1; push!(checklist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(checklist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(checklist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(checklist, [i-1, j]); end
            if 1 < i && 1 < j && Lattice.lattice[i-1, j-1] == 1; push!(checklist, [i-1, j-1]); end
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(checklist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(checklist, [i+1, j-1]); end
            if i < row && j < column && Lattice.lattice[i+1, j+1] == 1; push!(checklist, [i+1, j+1]); end
        end
    end

    function checkallsite(Lattice::squarennn)
        _N = Lattice.N
        checklist = Array{Int64,1}[]
        i = 1
        for j in 1:_N
            checksite(i, j, Lattice, checklist)
        end
        
        while checklist != []
            tmppos = pop!(checklist)
            checksite(tmppos[1], tmppos[2], Lattice, checklist)
        end
    end

    ######################################
    # recursive function
    ######################################
    # nearest neighbor
    function checksite(i::Int, j::Int, Lattice::squarennrec)
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.lattice[i,j] = 2
            Lattice.visit[i,j] = 1
            if j < column; checksite(i, j+1, Lattice); end
            if 1 < j; checksite(i, j-1, Lattice); end
            if i < row; checksite(i+1, j, Lattice); end
            if 1 < i; checksite(i-1, j, Lattice); end
        end
    end

    function checkallsite(Lattice::squarennrec)
        i = 1
        for j in 1:Lattice.N
            checksite(i, j, Lattice)
        end
    end
    
    # next nearest neighbor
    function checksite(i::Int, j::Int, Lattice::squarennnrec)
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.lattice[i,j] = 2
            Lattice.visit[i,j] = 1
            if j < column; checksite(i, j+1, Lattice); end
            if 1 < j; checksite(i, j-1, Lattice); end
            if i < row; checksite(i+1, j, Lattice); end
            if 1 < i; checksite(i-1, j, Lattice); end
            if 1 < i && 1 < j; checksite(i-1, j-1, Lattice); end
            if 1 < i && j < column; checksite(i-1, j+1, Lattice); end
            if i < row && 1 < j; checksite(i+1, j-1, Lattice); end
            if i < row && j < column; checksite(i+1, j+1, Lattice); end
        end
    end

    function checkallsite(Lattice::squarennnrec)
        i = 1
        for j in 1:Lattice.N
            checksite(i, j, Lattice)
        end
    end


##############################
# For triangular lattice
##############################
    function checksite(i::Int, j::Int, Lattice::trinn, checklist::Array{Array{Int64,1},1})
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.lattice[i,j] = 2
            Lattice.visit[i,j] = 1
            if j < column && Lattice.lattice[i, j+1] == 1; push!(checklist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(checklist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(checklist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(checklist, [i-1, j]); end
            if 1 < i && j < column; Lattice.lattice[i-1, j+1] == 1; push!(checklist, [i-1, j+1]); end
            if 1 < j && i < row; Lattice.lattice[i+1, j-1] == 1; push!(checklist, [i+1, j-1]); end
        end
    end

    function checkallsite(Lattice::trinn)
        _N = Lattice.N
        checklist = Array{Int64,1}[]
        i = 1
        for j in 1:_N
            checksite(i, j, Lattice, checklist)
        end
        
        while checklist != []
            tmppos = pop!(checklist)
            checksite(tmppos[1], tmppos[2], Lattice, checklist)
        end
    end
    
    ######################################
    # recursive function
    ######################################    
    function checksite(i::Int, j::Int, Lattice::trinnrec)
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.lattice[i,j] = 2
            Lattice.visit[i,j] = 1
            if j < column; checksite(i, j+1, Lattice); end
            if 1 < j; checksite(i, j-1, Lattice); end
            if i < row; checksite(i+1, j, Lattice); end
            if 1 < i; checksite(i-1, j, Lattice); end
            if 1 < i && j < column; checksite(i-1, j+1, Lattice); end
            if 1 < j && i < row; checksite(i+1, j-1, Lattice); end
        end
    end

    function checkallsite(Lattice::trinnrec)
        i = 1
        for j in 1:Lattice.N
            checksite(i, j, Lattice)
        end
    end
############################################################
# honeycomb lattice nearest neighbor
############################################################
function checksite(i::Int, j::Int, Lattice::honeycomb)
    (row, column) = size(Lattice.lattice)
    searchlist = Array{Array{Int64, 1}, 1}()
    
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        Lattice.lattice[i,j] = 2
        Lattice.visit[i,j] = 1
        
        if iseven(i+j)
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
        else
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
        end
    end
    
    return searchlist
end

function checkallsite(Lattice::honeycomb)
    _N = Lattice.N
    checklist = Array{Int64,1}[]
    i = 1
    for j in 1:_N
        checklist = [checklist; checksite(i, j, Lattice)]
    end
    
    while checklist != []
        tmppos = pop!(checklist)
        checklist = [checklist; checksite(tmppos[1], tmppos[2], Lattice)]
    end
end

############################################################
# kagome lattice nearest neighbor
############################################################
function checksite(i::Int, j::Int, Lattice::kagome)
    (row, column) = size(Lattice.lattice)
    searchlist = Array{Array{Int64, 1}, 1}()
    
    if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
        Lattice.lattice[i,j] = 2
        Lattice.visit[i,j] = 1
        
        if iseven(i+j) # if i and j are both zeros, always lattice[i,j] = 0
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end            
        elseif iseven(i) && isodd(j)
            if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end  
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
        else
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
        end
    end
    
    return searchlist
end

function checkallsite(Lattice::kagome)
    _N = Lattice.N
    checklist = Array{Int64,1}[]
    i = 1
    for j in 1:_N
        checklist = [checklist; checksite(i, j, Lattice)]
    end
    
    while checklist != []
        tmppos = pop!(checklist)
        checklist = [checklist; checksite(tmppos[1], tmppos[2], Lattice)]
    end
end

#######################################
##
## For simple lattice
##
#######################################
    function checksite(ind::Int, Lattice::simplenn, checklist::Array{Int64,1})
        present_place = ind2sub(Lattice.lattice, ind)
        
        if Lattice.lattice[present_place...] == 1 && Lattice.visit[present_place...] == 0
            Lattice.lattice[present_place...] = 2
            Lattice.visit[present_place...] = 1
            
            for i in 1:length(Lattice.NearestNeighborList)
                tempposition = ([present_place...] + Lattice.NearestNeighborList[i])
                if 0 ∉ tempposition && Lattice.N + 1 ∉ tempposition
                    tmpind = sub2ind(Lattice.lattice, tempposition...)
                    push!(checklist, tmpind)
                end
            end
        end
    end

    function checkallsite(Lattice::simplenn)
        _N, dim = Lattice.N, Lattice.dim
        checklist = Array{Int64, 1}()
        
        for i in 1:_N^(dim-1)
            checksite(i, Lattice, checklist)
        end

        while checklist != []
            tmppos = pop!(checklist)
            checksite(tmppos, Lattice, checklist)
        end
    end
