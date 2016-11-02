########################
#
# For square lattice
#
########################

function checksitenn(i::Int, j::Int, lattice::Array{Int})
	(row,  column) = size(lattice)
	if j < column && lattice[i, j+1] == 1; lattice[i, j+1] = 2; end # lattice[i, j+1] == 1 && j < m とすると動かないので注意
	if 1 < j && lattice[i, j-1] == 1; lattice[i, j-1] = 2; end
	if i < row && lattice[i+1, j] == 1; lattice[i+1, j] = 2; end
	if 1 < i && lattice[i-1, j] == 1; lattice[i-1, j] = 2; end

	return lattice
end

function checksitennn(i::Int, j::Int, lattice::Array{Int})
    (row,  column) = size(lattice)
    lattice = checksitenn(i, j, lattice)
    
	if j < column && i < row && lattice[i+1, j+1] == 1; lattice[i+1, j+1] = 2; end
	if 1 < j && i < row && lattice[i+1, j-1] == 1; lattice[i+1, j-1] = 2; end
	if 1 < i && j < column && lattice[i-1, j+1] == 1; lattice[i-1, j+1] = 2; end
	if 1 < i && 1 < j && lattice[i-1, j-1] == 1; lattice[i-1, j-1] = 2; end
    
	return lattice
end

# square lattice nearest neighbor
function checksite(i::Int, j::Int, Lattice::squarenn)
    checksitenn(i::Int, j::Int, Lattice.lattice::Array{Int})
end

# square lattice next nearest neighbor
function checksite(i::Int, j::Int, Lattice::squarennn)
    checksitennn(i::Int, j::Int, Lattice.lattice::Array{Int})
end


##############################
#
# For triangular lattice
#
##############################
function checksitetrinn(i::Int, j::Int, lattice::Array{Int})
	(row,  column) = size(lattice)
    lattice = checksitenn(i, j, lattice)
    if 1 < i && j < column && lattice[i-1, j+1] == 1; lattice[i-1, j+1] = 2; end
    if 1 < j && i < row && lattice[i+1, j-1] == 1; lattice[i+1, j-1] = 2; end
    
	return lattice
end

function checksite(i::Int, j::Int, Lattice::trinn)
    checksitetrinn(i::Int, j::Int, Lattice.lattice::Array{Int})
end


######################################
#
# For square, triangular lattice
#
######################################
function checkallsite(Lattice::TwoDLattice)
    (row, column) = size(Lattice.lattice)
    for i in 1:row, j in 1:column
        if Lattice.lattice[i,j] == 2
            Lattice.lattice = checksite(i, j, Lattice)
        end
    end
    
    return Lattice.lattice
end


######################################
#
# For simple lattice
#
######################################
function checksitesimple(ind::Int, Lattice::HighDimLattice)
    present_place = ind2sub(Lattice.lattice, ind)
    
    for i in 1:length(Lattice.NearestNeighborList)
        tempposition = ([present_place...] + Lattice.NearestNeighborList[i])
        if 0 ∉ tempposition && Lattice.N + 1 ∉ tempposition
            if Lattice.lattice[tempposition...] == 1; Lattice.lattice[tempposition...] = 2; end
        end
    end
end

function checkallsite(Lattice::HighDimLattice)
    for i in 1:length(Lattice.lattice)
        present_place = ind2sub(Lattice.lattice, i)
        if Lattice.lattice[present_place...] == 2
            checksitesimple(i, Lattice)
        end
    end
    
    return Lattice.lattice
end
