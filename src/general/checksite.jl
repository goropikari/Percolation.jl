# WEB: water, empty, block
function checksite(i::Int64, j::Int64, WEB::Array{String})
	(n, m) = size(WEB)
	if j < m && WEB[i, j+1] == "block"; WEB[i, j+1] = "water"; end # WEB[i, j+1] == "block" && j < m とすると動かないので注意
	if 1 < j && WEB[i, j-1] == "block"; WEB[i, j-1] = "water"; end
	if i < n && WEB[i+1, j] == "block"; WEB[i+1, j] = "water"; end
	if 1 < i && WEB[i-1, j] == "block"; WEB[i-1, j] = "water"; end

	return WEB
end

function checksite(i::Int64, j::Int64, WEB::Array{String}, site::simplenn)
    (n, m) = (site.N, site.M)
	if j < m && WEB[i, j+1] == "block"; WEB[i, j+1] = "water"; end
	if 1 < j && WEB[i, j-1] == "block"; WEB[i, j-1] = "water"; end
	if i < n && WEB[i+1, j] == "block"; WEB[i+1, j] = "water"; end
	if 1 < i && WEB[i-1, j] == "block"; WEB[i-1, j] = "water"; end

	return WEB
end

function checksite(i::Int64, j::Int64, WEB::Array{String}, site::simplennn)
    (n, m) = (site.N, site.M)
	if j < m && i < n && WEB[i+1, j+1] == "block"; WEB[i+1, j+1] = "water"; end
	if 1 < j && i < n && WEB[i+1, j-1] == "block"; WEB[i+1, j-1] = "water"; end
	if 1 < i && j < m && WEB[i-1, j+1] == "block"; WEB[i-1, j+1] = "water"; end
	if 1 < i && 1 < j && WEB[i-1, j-1] == "block"; WEB[i-1, j-1] = "water"; end

	if j < m && WEB[i, j+1] == "block"; WEB[i, j+1] = "water"; end
	if 1 < j && WEB[i, j-1] == "block"; WEB[i, j-1] = "water"; end
	if i < n && WEB[i+1, j] == "block"; WEB[i+1, j] = "water"; end
	if 1 < i && WEB[i-1, j] == "block"; WEB[i-1, j] = "water"; end
    
	return WEB
end
