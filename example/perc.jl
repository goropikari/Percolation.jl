using PyPlot

# nearest neighbor
type nnlattice
    N::Int64
    M::Int64
end

# next nearest neighbor
type nnnlattice
    N::Int64
    M::Int64
end

function checksite(i::Int64, j::Int64, water::Array{String})
	(n, m) = size(water)
	if j < m && water[i, j+1] == "block"; water[i, j+1] = "water"; end # water[i, j+1] == "block" && j < m とすると動かないので注意
	if 1 < j && water[i, j-1] == "block"; water[i, j-1] = "water"; end
	if i < n && water[i+1, j] == "block"; water[i+1, j] = "water"; end
	if 1 < i && water[i-1, j] == "block"; water[i-1, j] = "water"; end

	return water
end

function checksite(i::Int64, j::Int64, water::Array{String}, site::nnlattice)
    (n, m) = (site.N, site.M)
	if j < m && water[i, j+1] == "block"; water[i, j+1] = "water"; end
	if 1 < j && water[i, j-1] == "block"; water[i, j-1] = "water"; end
	if i < n && water[i+1, j] == "block"; water[i+1, j] = "water"; end
	if 1 < i && water[i-1, j] == "block"; water[i-1, j] = "water"; end

	return water
end

function checksite(i::Int64, j::Int64, water::Array{String}, site::nnnlattice)
    (n, m) = (site.N, site.M)
	if j < m && i < n && water[i+1, j+1] == "block"; water[i+1, j+1] = "water"; end
	if 1 < j && i < n && water[i+1, j-1] == "block"; water[i+1, j-1] = "water"; end
	if 1 < i && j < m && water[i-1, j+1] == "block"; water[i-1, j+1] = "water"; end
	if 1 < i && 1 < j && water[i-1, j-1] == "block"; water[i-1, j-1] = "water"; end

	if j < m && water[i, j+1] == "block"; water[i, j+1] = "water"; end
	if 1 < j && water[i, j-1] == "block"; water[i, j-1] = "water"; end
	if i < n && water[i+1, j] == "block"; water[i+1, j] = "water"; end
	if 1 < i && water[i-1, j] == "block"; water[i-1, j] = "water"; end
	return water
end


function PercolationPlot(N, M, lattice, config, hit, mizu=true)
	x = Int64[]; y = Int64[]

	if mizu
        # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
        # findnで 0 以外の数値が入っているインデックスを返す。
		ymizu, xmizu = findn( flipdim( (config .== "water") * 1 , 1) )
		x = vcat(x,xmizu); y = vcat(y,ymizu)
	end

    
	yl, xl = findn(flipdim(lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)


	plt[:hist2d](x, y, bins=[N, M] );
	colorbar()
	set_cmap("brg_r") # http://matplotlib.org/examples/color/colormaps_reference.html
	axis("equal")
	axis("off")
	if hit > 0; title(latexstring("Percolation !, \$p\$ = $p")); end
	if hit == 0; title(latexstring("Not Percolation, \$p\$ = $p")); end
	savefig("percolation.png")
	show()
end


function MakeSimpleLattice(N::Int64, M::Int64, p::Float64)
    lattice = ( rand(N,M) .< p ) * 1
	config = Array{String}(N, M)
	for i in 1:N, j in 1:M
		if lattice[i,j] == 1 && i == 1
			config[i,j] = "water"
		elseif lattice[i,j] == 1
			config[i,j] = "block"
		else
			config[i,j] = "empty"
		end
	end
    
    return lattice, config
end


function verticalPercolation(lattice::Array{Int64})
    test = ones(Int64, M)
	hit = 1
	for i in 1:N-1
		( findn(lattice[i, :]) ∩ findn(lattice[i+1, :]) ) == [] && break
		hit += 1
	end

	if hit < N
		return 0
	end
    
    return hit
end



function percolation(N::Int64, M::Int64, p::Float64, fig=true)

    lattice, config = MakeSimpleLattice(N, M, p)
    
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(lattice)
    if PercOrNot < N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(N,M), "tempolaryString")
	while config != exconfig
		exconfig = config[:,:]
		for i in 1:N, j in 1:M
			if config[i,j] == "water"
				config = checksite(i, j, config)
			end
		end
	end


	if "water" ∈ config[N,:]
		hit = 1
	else
		hit = 0
	end

	if fig
		PercolationPlot(N, M, lattice, config, hit)
	end

	return hit;
end


function percolation(N::Int64, M::Int64, p::Float64, site, fig=true)

    lattice, config = MakeSimpleLattice(N, M, p)
    
    # test whether vertical percolation or not.
    PercOrNot = verticalPercolation(lattice)
    if PercOrNot < N && fig == false
        return 0
    end
        

	exconfig = fill!(Array{String}(N,M), "tempolaryString")
	while config != exconfig
		exconfig = config[:,:]
		for i in 1:N, j in 1:M
			if config[i,j] == "water"
				config = checksite(i, j, config, site)
			end
		end
	end


	if "water" ∈ config[N,:]
		hit = 1
	else
		hit = 0
	end

	if fig
		PercolationPlot(N, M, lattice, config, hit)
	end

	return hit;
end


const N = 100;
M = N;
const p = 0.5;
site = nnnlattice(N, M)
@time percolation(N, N, p)
gc()
