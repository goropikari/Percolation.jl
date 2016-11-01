################
#
# For simple lattice
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

# simple lattice nearest neighbor
function checksite(i::Int64, j::Int64, Lattice::simplenn)
    checksitenn(i::Int64, j::Int64, Lattice.lattice::Array{Int64})
end

# simple lattice next nearest neighbor
function checksite(i::Int64, j::Int64, Lattice::simplennn)
    checksitennn(i::Int64, j::Int64, Lattice.lattice::Array{Int64})
end


######################
#
# For triangle lattice
#
######################
function checksitetrinn(i::Int64, j::Int64, lattice::Array{Int64})
	(row,  column) = size(lattice)
	if 1 < j && lattice[i, j-1] == 1; lattice[i, j-1] = 2; end
	if j < column && lattice[i, j+1] == 1; lattice[i, j+1] = 2; end # lattice[i, j+1] == 1 && j < m とすると動かないので注意
	if 1 < i && lattice[i-1, j] == 1; lattice[i-1, j] = 2; end
	if i < row && lattice[i+1, j] == 1; lattice[i+1, j] = 2; end

	return lattice
end


function checkallsite(Lattice::Lattice)
    (row, column) = size(Lattice.lattice)
    for i in 1:row, j in 1:column
        if Lattice.lattice[i,j] == 2
            Lattice.lattice = checksite(i, j, Lattice)
        end
    end
    
    return Lattice.lattice
end




