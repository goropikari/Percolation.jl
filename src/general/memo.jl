MakeSimpleLattice(N, d, p)


N = 3; p = 0.6; dim = 3
lattice = ( rand([N for i in 1:dim]...) .< p ) * 1
ind2sub(lattice, 10) # --> (1,1,2)
lattice[ind2sub(lattice, 10)...]



function nn(d)
    nn = zeros(Int, d)
end

function gen(list, nn, nth, d)
    println(nth)
    if nth <= d
        nncopy1 = nn[:]
        nncopy2 = nn[:]
        nncopy1[nth] += 1
        nncopy2[nth] -= 1
        push!(list, nncopy1)
        push!(list, nncopy2)
#        gen(list, nncopy1, nth+1, d)
#        gen(list, nncopy2, nth+1, d)
        gen(list, nn, nth+1, d)
    else
        return
    end
end

function nearlist(dim)
    list = []
    for i in 1:dim
        listplus = zeros(Int, dim)
        listminus = zeros(Int, dim)
        listplus[i] = 1
        listminus[i] = -1
        push!(list, listplus)
        push!(list, listminus)
    end
    return list
end

l = []
d=3
gen(l, nn(d), 1, d)
l

println(l)
length(l)


using PyPlot
using ProgressMeter
plist = collect(0.1:0.02:0.2)
hit = zeros(Int, length(plist))
trial = 10; N = 20; dim = 5;
progress = Progress(length(plist))
for i in 1:length(plist)
    println(i)
    for j in 1:trial
        site = simplenn(N, dim, plist[j])
        hit[j] += percolation(site)[1]
    end
    next!(progress)
end
hit /= trial
plot(plist, hit)
