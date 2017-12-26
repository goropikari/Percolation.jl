#using PyPlot, PyCall
#@pyimport matplotlib.patches as patch

"""
0: empty  
1: green  
2: fire
"""
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

function forestfire!(site::Forest)
    lifetime = 0
    previous_lattice = site.lattice[:,:]
    
    checkallsite!(site)
    while previous_lattice != site.lattice
        previous_lattice = site.lattice[:,:]
        checkallsite!(site)
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
#	site = forestfire!100, plist[i])
#	time[i] += forestfire!site)
#end

#plot(plist, time/trial)
#show()


# square lattice nearest neighbor
function checksite!(i::Int, j::Int, site::Forest)
   checksitenn!(i, j, site)
end

function checksitenn!(i::Int, j::Int, site::Forest)
	(row,  column) = size(site.lattice)
	if j < column && site.lattice[i, j+1] == 1; site.lattice[i, j+1] = 2; end # site.lattice[i, j+1] == 1 && j < m とすると動かないので注意
	if 1 < j && site.lattice[i, j-1] == 1; site.lattice[i, j-1] = 2; end
	if i < row && site.lattice[i+1, j] == 1; site.lattice[i+1, j] = 2; end
	if 1 < i && site.lattice[i-1, j] == 1; site.lattice[i-1, j] = 2; end
end

function checkallsite!(site::Forest)
    row, column = site.N, site.N
    for i in 1:row, j in 1:column
        if site.lattice[j,i] == 2
            checksite!(j, i, site)
        end
    end
end


##################
# plot 関連
##################
function forestplot(site::Forest, lifetime::Int; circle=false, output_dir=".")
    if ! ispath(output_dir); mkdir(output_dir); end

    yfire, xfire = findn(site.lattice .== 2)
    ytree, xtree = findn(site.lattice .== 1)
    yempty, xempty = findn(site.lattice .== 0)
    
    if lifetime != -1
        PyPlot.ioff()
    else
        PyPlot.ion()
    end
    #Grid(1, site.N, 1, site.N)
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
    
    PyPlot.axis("equal")
    PyPlot.axis("off")
    PyPlot.axis([-1, site.N+1, -1, site.N+1])
    if lifetime != -1
        PyPlot.title(@sprintf("%05d", lifetime))
        PyPlot.savefig(output_dir * "/" * @sprintf("%05d.png", lifetime), bbox_inches="tight")
        PyPlot.clf()
    end

end

function forestplot(site::Forest)
    forestplot(site, -1)
end


function forestgif!(site::Forest; fps=5, output_dir=".", filename="anime.gif")
    output_tempolary_png=tempdir()*"/forest_"*randstring()
    close()
    lifetime = 0
    previous_lattice = site.lattice[:,:]
    
    # plot initial configuration
    PyPlot.ioff()
    PyPlot.figure(figsize=(8,8))
    forestplot(site, lifetime, output_dir=output_tempolary_png)
    
    checkallsite!(site)
#    lifetime += 1
#    forestplot(site, lifetime, output_dir=output_tempolary_png)
    while previous_lattice != site.lattice && 2 ∉ site.lattice[:,site.N]
        lifetime += 1
        forestplot(site, lifetime, output_dir=output_tempolary_png)
        previous_lattice = site.lattice[:,:]
        checkallsite!(site)
    end
    
    if 2 in site.lattice[:,site.N]
        lifetime += 1
        forestplot(site, lifetime, output_dir=output_tempolary_png)
    end
    
    run(`convert -delay $(100/fps) $(output_tempolary_png)/"*".png $(output_dir)/$filename`)
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
