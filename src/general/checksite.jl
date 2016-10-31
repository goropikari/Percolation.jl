# WEB: water, empty, block
function checksite(i::Int64, j::Int64, WEB::Array{String})
	(n, m) = size(WEB)
	if j < m && WEB[i, j+1] == "block"; WEB[i, j+1] = "water"; end # WEB[i, j+1] == "block" && j < m とすると動かないので注意
	if 1 < j && WEB[i, j-1] == "block"; WEB[i, j-1] = "water"; end
	if i < n && WEB[i+1, j] == "block"; WEB[i+1, j] = "water"; end
	if 1 < i && WEB[i-1, j] == "block"; WEB[i-1, j] = "water"; end

	return WEB
end

function checkallsite(WEB::Array{String})
    (N, M) = size(WEB)
    for i in 1:N, j in 1:M
        if WEB[i,j] == "water"
        WEB = checksite(i, j, WEB)
        end
    end
    
    return WEB
end





function checksite(i::Int64, j::Int64, SimpleLattice::simplenn)
	if j < SimpleLattice.M && SimpleLattice.config[i, j+1] == "block"; SimpleLattice.config[i, j+1] = "water"; end
	if 1 < j && SimpleLattice.config[i, j-1] == "block"; SimpleLattice.config[i, j-1] = "water"; end
	if i < SimpleLattice.N && SimpleLattice.config[i+1, j] == "block"; SimpleLattice.config[i+1, j] = "water"; end
	if 1 < i && SimpleLattice.config[i-1, j] == "block"; SimpleLattice.config[i-1, j] = "water"; end

	return SimpleLattice.config
end



function checksite(i::Int64, j::Int64, SimpleLattice::simplennn)
	if j < SimpleLattice.M && i < SimpleLattice.N && SimpleLattice.config[i+1, j+1] == "block"; SimpleLattice.config[i+1, j+1] = "water"; end
	if 1 < j && i < SimpleLattice.N && SimpleLattice.config[i+1, j-1] == "block"; SimpleLattice.config[i+1, j-1] = "water"; end
	if 1 < i && j < SimpleLattice.M && SimpleLattice.config[i-1, j+1] == "block"; SimpleLattice.config[i-1, j+1] = "water"; end
	if 1 < i && 1 < j && SimpleLattice.config[i-1, j-1] == "block"; SimpleLattice.config[i-1, j-1] = "water"; end

	if j < SimpleLattice.M && SimpleLattice.config[i, j+1] == "block"; SimpleLattice.config[i, j+1] = "water"; end
	if 1 < j && SimpleLattice.config[i, j-1] == "block"; SimpleLattice.config[i, j-1] = "water"; end
	if i < SimpleLattice.N && SimpleLattice.config[i+1, j] == "block"; SimpleLattice.config[i+1, j] = "water"; end
	if 1 < i && SimpleLattice.config[i-1, j] == "block"; SimpleLattice.config[i-1, j] = "water"; end
    
	return SimpleLattice.config
end

function checkallsite(SimpleLattice::simplennn)
    for i in 1:SimpleLattice.N, j in 1:SimpleLattice.M
        if SimpleLattice.config[i,j] == "water"
            SimpleLattice.config = checksite(i, j, SimpleLattice)
        end
    end 
    
    return SimpleLattice.config
end
