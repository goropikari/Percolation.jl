using Percolation, PyPlot, ProgressMeter
# 3D
N = 50; dim = 3;
plist = collect(0.2:0.01:0.35)
len = length(plist)
hit = zeros(Int, len)
trial = 50

progress = Progress(len)
for i in 1:len
    for j in 1:trial
        site = simplennpos(N, dim, plist[i])
        hit[i] += percolation(site)
    end
    next!(progress)
end

plot(plist, hit/trial)
xlabel("occupied probability")
ylabel("percolation probability")
title("$dim dimension, N=$N, trial=$trial")
savefig("$(dim)D.png")


# 4D-
function g(N, dim, plist)
#    N = 0; dim = 4;
#    plist = collect(0.2:0.01:0.35)
    len = length(plist)
    hit = zeros(Int, len)
    trial = 50

    progress = Progress(len)
    for i in 1:len
        for j in 1:trial
            site = simplennpos(N, dim, plist[i])
            hit[i] += percolation(site)
        end
        next!(progress)
    end

    plot(plist, hit/trial)
    xlabel("occupied probability")
    ylabel("percolation probability")
    title("$dim dimension, N=$N, trial=$trial")
    savefig("$(dim)D.png")
end


#   percolation threshold
#   2   0.592
#   3   0.307
#   4	0.1968861(14),[135] 0.196889(3),[136] 0.196901(5) [137]	0.1601314(13),[135] 0.160130(3),[136] 0.1601310(10) [102]
#   5	0.1407966(15) [135]	0.118172(1),[135] 0.1181718(3) [102]
#   6	0.109017(2) [135]	0.0942019(6) [135]
#   7	0.0889511(9),[135] 0.088939(20) [138]	0.0786752(3) [135]
#   8	0.0752101(5) [135]	0.06770839(7) [135]
#   9	0.0652095(3) [135]	0.05949601(5) [135]
#   10	0.0575930(1) [135]	0.05309258(4) [135]
#   11	0.05158971(8) [135]	0.04794969(1) [135]
#   12	0.04673099(6) [135]	0.04372386(1) [135]
#   13	0.04271508(8) [135]	0.04018762(1) [135]
