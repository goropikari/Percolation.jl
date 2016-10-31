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

    figure()
	plt[:hist2d](x, y, bins=[SimpleLattice.N, SimpleLattice.M] );
	colorbar()
	set_cmap("brg_r") # http://matplotlib.org/examples/color/colormaps_reference.html
	axis("equal")
	axis("off")
	if hit > 0; title(latexstring("Percolation !, \$p\$ = $(SimpleLattice.p)")); end
	if hit == 0; title(latexstring("Not Percolation, \$p\$ = $(SimpleLattice.p)")); end
	show()
end


function PercolationPlot(SimpleLattice::simplennn, hit::Int64, waterplot::Bool)
	x = Int64[]; y = Int64[]

	if waterplot
        # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
        # findnで 0 以外の数値が入っているインデックスを返す。
		ymizu, xmizu = findn( flipdim( (SimpleLattice.config .== "water") * 1 , 1) )
		x = vcat(x,xmizu); y = vcat(y,ymizu)
	end

    
	yl, xl = findn(flipdim(SimpleLattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)

    figure()
	plt[:hist2d](x, y, bins=[SimpleLattice.N, SimpleLattice.M] );
	colorbar()
	set_cmap("brg_r") # http://matplotlib.org/examples/color/colormaps_reference.html
	axis("equal")
	axis("off")
	if hit > 0; title(latexstring("Percolation !, \$p\$ = $(SimpleLattice.p)")); end
	if hit == 0; title(latexstring("Not Percolation, \$p\$ = $(SimpleLattice.p)")); end
	show()
end



# for GIF animation
function PercolationPlot(SimpleLattice, hit::Int64, ind::Int64, output_dir::String)
	x = Int64[]; y = Int64[]

    ymizu, xmizu = findn( flipdim( (SimpleLattice.config .== "water") * 1 , 1) )
    x = vcat(x,xmizu); y = vcat(y,ymizu)


	yl, xl = findn(flipdim(SimpleLattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)
	plt[:hist2d](x, y, bins=[SimpleLattice.N, SimpleLattice.M] );
	colorbar()
	set_cmap("brg_r") # http://matplotlib.org/examples/color/colormaps_reference.html
	axis("equal")
	axis("off")
	if hit > 0; title(latexstring("Percolation !, \$p\$ = $(SimpleLattice.p)")); end
	if hit == 0; title(latexstring("Not Percolation, \$p\$ = $(SimpleLattice.p)")); end

    # save figure
    if ! ispath(output_dir); mkdir(output_dir); end
	savefig(@sprintf("%s/%05d.png", output_dir, ind))
end
