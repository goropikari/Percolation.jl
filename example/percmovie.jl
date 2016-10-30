using PyPlot
function checksite(i::Int64, j::Int64, water::Array{String})
    (n, m) = size(water)
    if 1 < j && water[i, j-1] == "block"; water[i, j-1] = "water"; end
    if j < m && water[i, j+1] == "block"; water[i, j+1] = "water"; end # water[i, j+1] == "block" && j < m とすると動かないので注意
    if i < n && water[i+1, j] == "block"; water[i+1, j] = "water"; end
    if 1 < i && water[i-1, j] == "block"; water[i-1, j] = "water"; end

    return water
end

function percoplot(N, M, lattice, config, hit, ind)
	x = Int64[]; y = Int64[]

    ymizu, xmizu = findn( flipdim( (config .== "water") * 1 , 1) )
    x = vcat(x,xmizu); y = vcat(y,ymizu)


	yl, xl = findn(flipdim(lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)
	plt[:hist2d](x, y, bins=[N, M] );
	colorbar()
	set_cmap("brg_r") # http://matplotlib.org/examples/color/colormaps_reference.html
	axis("equal")
	axis("off")
	if hit > 0; title(latexstring("Percolation !, \$p\$ = $p")); end
	if hit == 0; title(latexstring("Not Percolation, \$p\$ = $p")); end

    # save figure
    output_dir = "pic"
    if ! ispath(output_dir); mkdir(output_dir); end
	savefig(@sprintf("%s/%05d.png", output_dir, ind))
end


function percolation(lattice::Array{Int64}, config::Array{String}, N::Int64, M::Int64, p::Float64, ind::Int64)
    for i in 1:N, j in 1:M
        if config[i,j] == "water"
            config = checksite(i, j, config)
        end
    end

    if "water" ∈ config[N,:]
        hit = 1
    else
        hit = 0
    end

    percoplot(N, M, lattice, config, hit, ind)

    return config;
end


function makelattice(N, M, p)
    const lattice = ( rand(N,M) .< p ) * 1
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


const N = 200;
M = N;
const p = 0.6;
lattice, config = makelattice(N, M, p)
percoplot(N, M, lattice, config, 0, 0)
clf()
@time for i in 1:300
    exconfig = config[:,:]
    config = percolation(lattice, config, N, N, p, i)
    config == exconfig && break
    clf()
end
close()
gc()

# convert -delay 4 *.png anime.gif
# ffmpeg -i anime.gif anime.mp4
