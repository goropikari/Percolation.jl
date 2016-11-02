function PercolationPlot(Lattice::SquareLattice, hit::Int, waterplot::Bool, color::String, colorbar::Bool)
	x = Int[]; y = Int[]

	if waterplot
        # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
        # findnで 0 以外の数値が入っているインデックスを返す。
		ymizu, xmizu = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
		x = vcat(x,xmizu); y = vcat(y,ymizu)
	end

    
	yl, xl = findn(flipdim(Lattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)

    PyPlot.figure()
	PyPlot.plt[:hist2d](x, y, bins=[Lattice.N, Lattice.M] );
	if colorbar; PyPlot.colorbar(); end
	PyPlot.set_cmap(color) # http://matplotlib.org/examples/color/colormaps_reference.html
	PyPlot.axis("equal")
	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end
	show()
end


function PercolationPlot(Lattice::TriangularLattice, hit::Int, waterplot::Bool, color::String, colorbar::Bool)

    # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
    # findnで 0 以外の数値が入っているインデックスを返す。
    ywater, xwater = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
	yempty, xempty = findn( flipdim( (Lattice.lattice .== 1) * 1 , 1) )
	yblock, xblock = findn( flipdim( (Lattice.lattice .== 0) * 1 , 1) )
	

    PyPlot.figure()
    if waterplot; PyPlot.plot(xwater, ywater, "b."); else; PyPlot.plot(xwater, ywater, "o", color="white"); end
    PyPlot.plot(xempty, yempty, ".", color="white")
    PyPlot.plot(xblock, yblock, ".", color="black")
	PyPlot.axis("equal")
#	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end
	show()
end


# for GIF animation
function PercolationPlot(Lattice::SquareLattice, hit::Int, ind::Int, output_dir::String, color::String, colorbar::Bool)
	x = Int[]; y = Int[]

    ymizu, xmizu = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
    x = vcat(x,xmizu); y = vcat(y,ymizu)


	yl, xl = findn(flipdim(Lattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)
	PyPlot.plt[:hist2d](x, y, bins=[Lattice.N, Lattice.M] );
	if colorbar; PyPlot.colorbar(); end
	PyPlot.set_cmap(color) # http://matplotlib.org/examples/color/colormaps_reference.html
	PyPlot.axis("equal")
	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end

    # save figure
    if ! ispath(output_dir); mkdir(output_dir); end
	PyPlot.savefig(@sprintf("%s/%05d.png", output_dir, ind))
end
