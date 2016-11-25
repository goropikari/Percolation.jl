#######################################################################################
# Square and triangular lattice: nearest neighbor, next nearest neighbor
#######################################################################################
function percolation(Lattice::TwoDLattice; fig=true, water=true, color="seismic_r", colorbar=false)
    _N = Lattice.N
    checkallsite(Lattice)

	#if 2 ∈ Lattice.lattice[1, :] && 2 ∈ Lattice.lattice[_N, :] && 2 ∈ Lattice.lattice[:, 1] && 2 ∈ Lattice.lattice[:, _N]
	if 2 ∈ Lattice.lattice[_N, :]
        hit = 1; 
    else;
        hit = 0;
    end
    
    Lattice.PercolationOrNot = hit
    
	return hit
end


#######################################################################################
# Higher dimensional simple lattice: nearest neighbor
#######################################################################################
function percolation(Lattice::simplenn)
    _N, dim = Lattice.N, Lattice.dim
    checkallsite(Lattice)

	if 2 ∈ Lattice.lattice[_N^(dim-1)*(_N-1)+1:end]; hit = 1; else; hit = 0; end

	return hit
end




" percolationgif(Lattice::SquareLattice; output_dir=\"./\", color=\"seismic_r\", colorbar=false, fps=4, filename=\"anime.gif\") "
function percolationgif(Lattice::SquareLattice; output_dir="./", color="seismic_r", colorbar=false, fps=4, filename="anime.gif")
    output_tempolary_png=tempdir()*"/Percolation_"*randstring()
    row, column = Lattice.N, Lattice.N
    for j in 1:column
        if Lattice.lattice[1, j] == 1; Lattice.lattice[1, j] = 2; end
    end
    
    
    percolationplot(Lattice, 0, 0, output_tempolary_png, color, colorbar)
    PyPlot.clf()
    previous_lattice = ones(Int, row, column)
    
    PyPlot.ioff()
    indx = 1
    while Lattice.lattice != previous_lattice
        previous_lattice = Lattice.lattice[:,:]
        Lattice.lattice = checkallsitegif(Lattice)
        if 2 ∈ Lattice.lattice[row, :]; hit = 1; else; hit = 0; end
        percolationplot(Lattice, hit, indx, output_tempolary_png, color, colorbar)
        PyPlot.clf()
        indx += 1
    end
    run(`convert -delay $fps $(output_tempolary_png)/*.png $(output_dir)/$filename`)
    rm(output_tempolary_png, force=true, recursive=true)
    close()
    
    gc()
end



function checksitenn(i::Int, j::Int, lattice::Array{Int})
	(row,  column) = size(lattice)
	if j < column && lattice[i, j+1] == 1; lattice[i, j+1] = 2; end # lattice[i, j+1] == 1 && j < m とすると動かないので注意
	if 1 < j && lattice[i, j-1] == 1; lattice[i, j-1] = 2; end
	if i < row && lattice[i+1, j] == 1; lattice[i+1, j] = 2; end
	if 1 < i && lattice[i-1, j] == 1; lattice[i-1, j] = 2; end

	return lattice
end


function checksitennn(i::Int, j::Int, lattice::Array{Int})
    (row,  column) = size(lattice)
    lattice = checksitenn(i, j, lattice)
    
	if j < column && i < row && lattice[i+1, j+1] == 1; lattice[i+1, j+1] = 2; end
	if 1 < j && i < row && lattice[i+1, j-1] == 1; lattice[i+1, j-1] = 2; end
	if 1 < i && j < column && lattice[i-1, j+1] == 1; lattice[i-1, j+1] = 2; end
	if 1 < i && 1 < j && lattice[i-1, j-1] == 1; lattice[i-1, j-1] = 2; end
    
	return lattice
end

# square lattice nearest neighbor
function checksite(i::Int, j::Int, Lattice::squarenn)
    checksitenn(i::Int, j::Int, Lattice.lattice::Array{Int})
end

# square lattice next nearest neighbor
function checksite(i::Int, j::Int, Lattice::squarennn)
    checksitennn(i::Int, j::Int, Lattice.lattice::Array{Int})
end

######################################
#
# For square lattice
#
######################################
function checkallsitegif(Lattice::TwoDLattice)
    row, column = Lattice.N, Lattice.N
    for i in 1:row, j in 1:column
        if Lattice.lattice[i,j] == 2
            Lattice.lattice = checksite(i, j, Lattice)
        end
    end
    
    return Lattice.lattice
end



# for GIF animation
function percolationplot(Lattice::SquareLattice, hit::Int, ind::Int, output_dir::String, color::String, colorbar::Bool)
	x = Int[]; y = Int[]

    ymizu, xmizu = findn( flipdim( (Lattice.lattice .== 2) * 1 , 1) )
    x = vcat(x,xmizu); y = vcat(y,ymizu)

	yl, xl = findn(flipdim(Lattice.lattice, 1))
	x = vcat(x,xl); y = vcat(y,yl)
    PyPlot.ioff()
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
