function PercolationPlot(N::Int64, M::Int64, p::Float64, lattice::Array{Int64}, config::Array{String}, hit::Int64; waterplot=true)
	x = Int64[]; y = Int64[]

	if waterplot
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
	show()
end

function PercolationPlot(N::Int64, p::Float64, lattice::Array{Int64}, config::Array{String}, hit::Int64; waterplot=true)
    PercolationPlot(N::Int64, N::Int64, p::Float64, lattice::Array{Int64}, config::Array{String}, hit::Int64; waterplot=true)
end


function PercolationPlot(SimpleLattice::simplenn, hit::Int64, waterplot::Bool)
	x = Int64[]; y = Int64[]

	if waterplot
        # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
        # findnで 0 以外の数値が入っているインデックスを返す。
		ymizu, xmizu = findn( flipdim( (SimpleLattice.config .== "water") * 1 , 1) )
		x = vcat(x,xmizu); y = vcat(y,ymizu)
	end

    
	yl, xl = findn(flipdim(SimpleLattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)


	plt[:hist2d](x, y, bins=[SimpleLattice.N, SimpleLattice.M] );
	colorbar()
	set_cmap("brg_r") # http://matplotlib.org/examples/color/colormaps_reference.html
	axis("equal")
	axis("off")
	if hit > 0; title(latexstring("Percolation !, \$p\$ = $(SimpleLattice.p)")); end
	if hit == 0; title(latexstring("Not Percolation, \$p\$ = $(SimpleLattice.p)")); end
	show()
end


function PercolationPlot(SimpleLattice::simplennn, p::Float64, lattice::Array{Int64}, config::Array{String}, hit::Int64; waterplot=true)
    (N, M) = (SimpleLattice.N, SimpleLattice.M)
	x = Int64[]; y = Int64[]

	if waterplot
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
	show()
end





# for GIF animation
function PercolationPlot(N::Int64, M::Int64, p::Float64, lattice::Array{Int64}, config::Array{String}, hit::Int64, ind::Int64; dirname="Percolation_pic")
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
    if ! ispath(dirname); mkdir(dirname); end
	savefig(@sprintf("%s/%05d.png", dirname, ind))
end
