#using PyPlot, PyCall
#@pyimport matplotlib.patches as patch

#0: empty
#1: green
#2: fire
type Forest
    N::Int
    p::Float64
    lattice::Matrix{Int}
    
    function Forest(N, p)
        if N > 10^3
            error("Too large site size. Reduce the number of sites under or equal 1000 of linear size.\n")
        end
    
        lattice = ( rand(N, N) .< p ) * 1
        for i in 1:N
            if lattice[i] == 1
                lattice[i] = 2
            end
        end
        
        new(N, p, lattice)
    end
end

function forest(Lattice::Forest)
    lifetime = 0
    previous_lattice = Lattice.lattice[:,:]
    
    checkallsite(Lattice)
    while previous_lattice != Lattice.lattice
        previous_lattice = Lattice.lattice[:,:]
        checkallsite(Lattice)
        lifetime += 1
    end
    
    return lifetime
end

## Introduction to Percolation Theory revised 2nd ed, Stauffer, p.6
#plist = collect(0:0.02:1)
#time = zeros(Int, length(plist))
#trial = 50
#len = length(plist)
#@time for i in 1:len, j in 1:trial
#	site = forest(100, plist[i])
#	time[i] += forest(site)
#end

#plot(plist, time/trial)
#show()







# square lattice nearest neighbor
function checksite(i::Int, j::Int, Lattice::Forest)
    checksitenn(i, j, Lattice)
end

function checksitenn(i::Int, j::Int, Lattice::Forest)
	(row,  column) = size(Lattice.lattice)
	if j < column && Lattice.lattice[i, j+1] == 1; Lattice.lattice[i, j+1] = 2; end # Lattice.lattice[i, j+1] == 1 && j < m とすると動かないので注意
	if 1 < j && Lattice.lattice[i, j-1] == 1; Lattice.lattice[i, j-1] = 2; end
	if i < row && Lattice.lattice[i+1, j] == 1; Lattice.lattice[i+1, j] = 2; end
	if 1 < i && Lattice.lattice[i-1, j] == 1; Lattice.lattice[i-1, j] = 2; end
end

function checkallsite(Lattice::Forest)
    row, column = Lattice.N, Lattice.N
    for i in 1:row, j in 1:column
        if Lattice.lattice[j,i] == 2
            checksite(j, i, Lattice)
        end
    end
end


##################
# plot 関連
##################
function forestplot(Lattice::Forest, lifetime::Int; circle=false, output_dir=".")
    if ! ispath(output_dir); mkdir(output_dir); end

    yfire, xfire = findn(Lattice.lattice .== 2)
    ytree, xtree = findn(Lattice.lattice .== 1)
    yempty, xempty = findn(Lattice.lattice .== 0)
    
    PyPlot.ioff()
    #Grid(1, Lattice.N, 1, Lattice.N)
    if circle
        for i in 1:length(xfire)
            circle(xfire[i], yfire[i], 0.25, "r")
        end
        for i in 1:length(xtree)
            circle(xtree[i], ytree[i], 0.25, "g")
        end
        for i in 1:length(xempty)
            circle(xempty[i], yempty[i], 0.25, "w", FILL=false)
        end
    else
        PyPlot.plot(xfire, yfire, "ro")
        PyPlot.plot(xtree, ytree, "go")
        PyPlot.plot(xempty, yempty, "w.") 
    end
    
    PyPlot.title(@sprintf("%05d", lifetime))
    PyPlot.axis("equal")
    PyPlot.axis("off")
    PyPlot.axis([-1, Lattice.N+1, -1, Lattice.N+1])
    PyPlot.savefig(output_dir * "/" * @sprintf("%05d.png", lifetime), bbox_inches="tight")
    PyPlot.clf()

end


function forestgif(Lattice::Forest; fps=5, output_dir=".", filename="anime.gif")
    output_tempolary_png=tempdir()*"/forest_"*randstring()
    close()
    lifetime = 0
    previous_lattice = Lattice.lattice[:,:]
    
    # plot initial configuration
    PyPlot.ioff()
    PyPlot.figure(figsize=(8,8))
    forestplot(Lattice, lifetime, output_dir=output_tempolary_png)
    
    checkallsite(Lattice)
#    lifetime += 1
#    forestplot(Lattice, lifetime, output_dir=output_tempolary_png)
    while previous_lattice != Lattice.lattice && 2 ∉ Lattice.lattice[:,Lattice.N]
        lifetime += 1
        forestplot(Lattice, lifetime, output_dir=output_tempolary_png)
        previous_lattice = Lattice.lattice[:,:]
        checkallsite(Lattice)
    end
    
    if 2 in Lattice.lattice[:,Lattice.N]
        lifetime += 1
        forestplot(Lattice, lifetime, output_dir=output_tempolary_png)
    end
    
    run(`convert -delay $(100/fps) $(output_tempolary_png)/*.png $(output_dir)/$filename`)
    rm(output_tempolary_png, force=true, recursive=true)
    return lifetime
end

# 丸を書く
function circle(x, y, r, COLOR; FILL=true)
    maru = patch.Circle((x,y), radius=r, color=COLOR, fill=FILL);
    PyPlot.gca()[:add_patch](maru);
end

# 格子を書く
function Grid(a, b, c, d)
    hx = [a, b]
    hy = [[i, i] for i in c:d]
    for i in 1:length(collect(c:d))
        PyPlot.plot(hx, hy[i], "k")
    end

    vx = [[i, i] for i in a:b]
    vy = [c, d]
    for i in 1:length(collect(a:b))
        PyPlot.plot(vx[i], vy, "k")
    end
end
