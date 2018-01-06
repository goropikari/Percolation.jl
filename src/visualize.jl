"display labeled square lattice "
function heatmap!(latt::TwoDLattice)
    if !latt.lattice_properties.islabeled
        label_components!(latt)
    end

    labeled_site = latt.lattice_properties.labeled_lattice_sites
    linsize = latt.lattice_config.linear_size
    maxlabel = maximum(labeled_site)
    colorchange = Dict(i=>j for (i,j) in zip(1:maxlabel, shuffle(1:maxlabel)))

    row, col = size(labeled_site)
    site = zeros(row, col)
    @simd for j in 1:col
        @simd for i in 1:row
            if labeled_site[i,j] != 0
                @inbounds site[i,j] = colorchange[labeled_site[i,j]]
            end
        end
    end

    heatmap(site, colorbar=false, aspect_ratio=:equal)
end

function plot_percolation_prob(latticetype::String, linsize::Int, ps, pinc, pf, nsample::Int)
    prob = ps:pinc:pf
    percoprob = zeros(length(prob))

    for (i,p) in enumerate(prob)
        nperco = 0
        for iter in 1:nsample
            if latticetype == "square"
                l = Square(linsize, p)
            elseif latticetype == "triangular"
                l = Triangular(linsize, p)
            else
                l = Honeycomb(linsize, p)
            end
            nperco += ispercolation!(l)
        end
        percoprob[i] = nperco / nsample
    end

    plot(prob, percoprob,
         xlabel="Concentration",
         ylabel="Percolation Probability",
         title="Percolation Probability",
         legend=false, marker=:circle)
end

