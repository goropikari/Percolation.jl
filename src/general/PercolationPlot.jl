#######
# 2D  #
#######
# square
"""
This package supports visualizing percolation for 2D lattice, but not for over 3D lattice.

percolationplot(Lattice::TwoDLattice; waterplot=true, color=\"seismic_r\", colorbar=false)

percolationplot(Lattice::simplenn)

If you want to use other colormaps, see  http://matplotlib.org/examples/color/colormaps_reference.html
"""
function percolationplot(Lattice::SquareLattice; waterplot=true, color="seismic_r", colorbar=false)
	# check percolation or not.
    if 2 ∈ Lattice.lattice[Lattice.N, :]; hit = 1; else; hit = 0; end
    
    x = Int[]; y = Int[]

	if waterplot
        # 行列で書くと(1,1)は左上になるけど、グラフで(1,1)は左下になるのでflipdimを使って上下を反転させる。
        # findnで 0 以外の数値が入っているインデックスを返す。
        # Matrix (1, 1) element is located at top left, but if you plot the point (1, 1), it is 
        # located at bottom left. 
		ymizu, xmizu = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
		x = vcat(x,xmizu); y = vcat(y,ymizu)
	end

    
	yl, xl = findn(flipdim(Lattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)

    PyPlot.figure()
	PyPlot.plt[:hist2d](x, y, bins=[Lattice.N, Lattice.N] );
	if colorbar; PyPlot.colorbar(); end
	PyPlot.set_cmap(color) # http://matplotlib.org/examples/color/colormaps_reference.html
	PyPlot.axis("equal")
	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end
	show()
end

# triangle
function percolationplot(Lattice::TriangularLattice; waterplot=true)
	# check percolation or not.
    if 2 ∈ Lattice.lattice[Lattice.N, :]; hit = 1; else; hit = 0; end
    
    ywater, xwater = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
#	yempty, xempty = findn( flipdim( (Lattice.lattice .== 1) * 1 , 1) )
	yblock, xblock = findn( flipdim( (Lattice.lattice .== 0) * 1 , 1) )
	

    PyPlot.figure()
#    if waterplot; PyPlot.plot(xwater, ywater, "b."); else; PyPlot.plot(xwater, ywater, "o", color="white"); end
    if waterplot; PyPlot.plot(xwater, ywater, "b."); end
#    PyPlot.plot(xempty, yempty, ".", color="white")
    PyPlot.plot(xblock, yblock, ".", color="black")
	PyPlot.axis("equal")
#	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end
	show()
end

# honeycomb
function percolationplot(Lattice::HoneycombLattice; waterplot=true)
	# check percolation or not.
    if 2 ∈ Lattice.lattice[Lattice.N, :]; hit = 1; else; hit = 0; end
    
    ywater, xwater = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
#	yempty, xempty = findn( flipdim( (Lattice.lattice .== 1) * 1 , 1) )
	yblock, xblock = findn( flipdim( (Lattice.lattice .== 0) * 1 , 1) )
	

    PyPlot.figure()
#    if waterplot; PyPlot.plot(xwater, ywater, "b."); else; PyPlot.plot(xwater, ywater, ".", color="white"); end
    if waterplot; PyPlot.plot(xwater, ywater, "b."); end
#    PyPlot.plot(xempty, yempty, ".", color="white")
    PyPlot.plot(xblock, yblock, ".", color="black")
	PyPlot.axis("equal")
#	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end
	show()
end

# kagome
function percolationplot(Lattice::KagomeLattice; waterplot=true)
	# check percolation or not.
    if 2 ∈ Lattice.lattice[Lattice.N, :]; hit = 1; else; hit = 0; end
    
    for i in 2:2:Lattice.N, j in 2:2:Lattice.N
        Lattice.lattice[j,i] = -1
    end
    
    ywater, xwater = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
#	yempty, xempty = findn( flipdim( (Lattice.lattice .== 1) * 1 , 1) )
	yblock, xblock = findn( flipdim( (Lattice.lattice .== 0) * 1 , 1) )
	

    PyPlot.figure()
#    if waterplot; PyPlot.plot(xwater, ywater, "b."); else; PyPlot.plot(xwater, ywater, "o", color="white"); end
    if waterplot; PyPlot.plot(xwater, ywater, "b."); end
#    PyPlot.plot(xempty, yempty, ".", color="white")
    PyPlot.plot(xblock, yblock, ".", color="black")
	PyPlot.axis("equal")
#	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end
	show()
end


# for GIF animation
function percolationplot(Lattice::SquareLattice, hit::Int, ind::Int, output_dir::String, color::String, colorbar::Bool)
	x = Int[]; y = Int[]

    ymizu, xmizu = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
    x = vcat(x,xmizu); y = vcat(y,ymizu)


	yl, xl = findn(flipdim(Lattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)
	PyPlot.plt[:hist2d](x, y, bins=[Lattice.N, Lattice.N] );
	if colorbar; PyPlot.colorbar(); end
	PyPlot.set_cmap(color)
	PyPlot.axis("equal")
	PyPlot.axis("off")
	if hit > 0; PyPlot.title(latexstring("Percolation !, \$p\$ = $(Lattice.p)")); end
	if hit == 0; PyPlot.title(latexstring("Not Percolation, \$p\$ = $(Lattice.p)")); end

    # save figure
    if ! ispath(output_dir); mkdir(output_dir); end
	PyPlot.savefig(@sprintf("%s/%05d.png", output_dir, ind))
end
