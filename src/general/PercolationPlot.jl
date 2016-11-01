function PercolationPlot(SimpleLattice::SimpleLattice, hit::Int64, waterplot::Bool, color::String, colorbar::Bool)
	x = Int64[]; y = Int64[]

	if waterplot
        # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
        # findnで 0 以外の数値が入っているインデックスを返す。
		ymizu, xmizu = findn( flipdim( (SimpleLattice.config .== "water") * 1 , 1) )
		x = vcat(x,xmizu); y = vcat(y,ymizu)
	end

    
	yl, xl = findn(flipdim(SimpleLattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)

    PyPlot.figure()
	PyPlot.plt[:hist2d](x, y, bins=[SimpleLattice.N, SimpleLattice.M] );
	if colorbar; PyPlot.colorbar(); end
	PyPlot.set_cmap(color) # http://matplotlib.org/examples/color/colormaps_reference.html
	PyPlot.axis("equal")
	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(SimpleLattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(SimpleLattice.p)")); end
	show()
end


# for GIF animation
function PercolationPlot(SimpleLattice::SimpleLattice, hit::Int64, ind::Int64, output_dir::String, color::String, colorbar::Bool, fps::Real)
	x = Int64[]; y = Int64[]

    ymizu, xmizu = findn( flipdim( (SimpleLattice.config .== "water") * 1 , 1) )
    x = vcat(x,xmizu); y = vcat(y,ymizu)


	yl, xl = findn(flipdim(SimpleLattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)
	PyPlot.plt[:hist2d](x, y, bins=[SimpleLattice.N, SimpleLattice.M] );
	if colorbar; PyPlot.colorbar(); end
	PyPlot.set_cmap(color) # http://matplotlib.org/examples/color/colormaps_reference.html
	PyPlot.axis("equal")
	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(SimpleLattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(SimpleLattice.p)")); end

    # save figure
    if ! ispath(output_dir); mkdir(output_dir); end
	PyPlot.savefig(@sprintf("%s/%05d.png", output_dir, ind))
    
end
