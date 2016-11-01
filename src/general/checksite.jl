################
#
# For square lattice
#
################

function checksitenn(i::Int64, j::Int64, lattice::Array{Int64})
	(row,  column) = size(lattice)
	if j < column && lattice[i, j+1] == 1; lattice[i, j+1] = 2; end # lattice[i, j+1] == 1 && j < m とすると動かないので注意
	if 1 < j && lattice[i, j-1] == 1; lattice[i, j-1] = 2; end
	if i < row && lattice[i+1, j] == 1; lattice[i+1, j] = 2; end
	if 1 < i && lattice[i-1, j] == 1; lattice[i-1, j] = 2; end

	return lattice
end

function checksitennn(i::Int64, j::Int64, lattice::Array{Int64})
    (row,  column) = size(lattice)
    lattice = checksitenn(i, j, lattice)
    
	if j < column && i < row && lattice[i+1, j+1] == 1; lattice[i+1, j+1] = 2; end
	if 1 < j && i < row && lattice[i+1, j-1] == 1; lattice[i+1, j-1] = 2; end
	if 1 < i && j < column && lattice[i-1, j+1] == 1; lattice[i-1, j+1] = 2; end
	if 1 < i && 1 < j && lattice[i-1, j-1] == 1; lattice[i-1, j-1] = 2; end
    
	return lattice
end

# square lattice nearest neighbor
function checksite(i::Int64, j::Int64, Lattice::squarenn)
    checksitenn(i::Int64, j::Int64, Lattice.lattice::Array{Int64})
end

# square lattice next nearest neighbor
function checksite(i::Int64, j::Int64, Lattice::squarennn)
    checksitennn(i::Int64, j::Int64, Lattice.lattice::Array{Int64})
end


######################
#
# For triangular lattice
#
######################
function checksitetrinn(i::Int64, j::Int64, lattice::Array{Int64})
	(row,  column) = size(lattice)
    lattice = checksitenn(i, j, lattice)
    if 1 < i && j < column && lattice[i-1, j+1] == 1; lattice[i-1, j+1] = 2; end
    if 1 < j && i < row && lattice[i+1, j-1] == 1; lattice[i+1, j-1] = 2; end
    
	return lattice
end

function checksite(i::Int64, j::Int64, Lattice::trinn)
    checksitetrinn(i::Int64, j::Int64, Lattice.lattice::Array{Int64})
end


######################
#
# For square, triangular lattice
#
######################
function checkallsite(Lattice::Lattice)
    (row, column) = size(Lattice.lattice)
    for i in 1:row, j in 1:column
        if Lattice.lattice[i,j] == 2
            Lattice.lattice = checksite(i, j, Lattice)
        end
    end
    
    return Lattice.lattice
end




