function checksitenn(i::Int64, j::Int64, config::Array{String})
	(row,  column) = size(config)
	if j < column && config[i, j+1] == "block"; config[i, j+1] = "water"; end # config[i, j+1] == "block" && j < m とすると動かないので注意
	if 1 < j && config[i, j-1] == "block"; config[i, j-1] = "water"; end
	if i < row && config[i+1, j] == "block"; config[i+1, j] = "water"; end
	if 1 < i && config[i-1, j] == "block"; config[i-1, j] = "water"; end

	return config
end

function checksitennn(i::Int64, j::Int64, config::Array{String})
    (row,  column) = size(config)
    config = checksitenn(i, j, config)
    
	if j < column && i < row && config[i+1, j+1] == "block"; config[i+1, j+1] = "water"; end
	if 1 < j && i < row && config[i+1, j-1] == "block"; config[i+1, j-1] = "water"; end
	if 1 < i && j < column && config[i-1, j+1] == "block"; config[i-1, j+1] = "water"; end
	if 1 < i && 1 < j && config[i-1, j-1] == "block"; config[i-1, j-1] = "water"; end
    
	return config
end

# simple lattice nearest neighbor
function checksite(i::Int64, j::Int64, SimpleLattice::simplenn)
    checksitenn(i::Int64, j::Int64, SimpleLattice.config::Array{String})
end

# simple lattice next nearest neighbor
function checksite(i::Int64, j::Int64, SimpleLattice::simplennn)
    checksitennn(i::Int64, j::Int64, SimpleLattice.config::Array{String})
end


function checkallsite(SimpleLattice)
    (row, column) = size(SimpleLattice.config)
    for i in 1:row, j in 1:column
        if SimpleLattice.config[i,j] == "water"
            SimpleLattice.config = checksite(i, j, SimpleLattice)
        end
    end
    
    return SimpleLattice.config
end



