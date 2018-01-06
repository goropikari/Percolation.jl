function label_components!(sqlattice::Square)
    if sqlattice.lattice_config.neighbortype == "nn"
        sqlattice.lattice_properties.labeled_lattice_sites = label_components(sqlattice.lattice_config.lattice_sites)
        sqlattice.lattice_properties.islabeled = true
    else # next nearest neighbor
        sqlattice.lattice_properties.labeled_lattice_sites = label_components(sqlattice.lattice_config.lattice_sites, trues(3,3))
        sqlattice.lattice_properties.islabeled = true
    end

    return nothing
end


function label_components!(trilattice::Triangular)
    site = trilattice.lattice_config.lattice_sites
    row, col = size(site)
    labelnum = 0
    labeled_site = - Int.(site)
    searchlist = Vector{Vector{Int}}()

    function checkneighbor!(i,j)
        if labeled_site[i,j] == -1
            # x o o neighbor
            # o o o
            # o o x
            if j < col && labeled_site[i, j+1] == -1; push!(searchlist, [i, j+1]); end
            if 1 < j && labeled_site[i, j-1] == -1; push!(searchlist, [i, j-1]); end
            if i < row && labeled_site[i+1, j] == -1; push!(searchlist, [i+1, j]); end
            if 1 < i && labeled_site[i-1, j] == -1; push!(searchlist, [i-1, j]); end
            if 1 < i && j < col && labeled_site[i-1, j+1] == -1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && labeled_site[i+1, j-1] == -1; push!(searchlist, [i+1, j-1]); end
        end
    end

    @simd for j in 1:col
        @simd for i in 1:row
            if labeled_site[i,j] == -1
                labelnum += 1
                checkneighbor!(i,j)
                labeled_site[i,j] = labelnum

                while !isempty(searchlist)
                    tmppos = pop!(searchlist)
                    checkneighbor!(tmppos...)
                    labeled_site[tmppos...] = labelnum
                end
            end
        end
    end

    trilattice.lattice_properties.islabeled = true
    trilattice.lattice_properties.labeled_lattice_sites = labeled_site

    return nothing
end


function label_components!(hclattice::Honeycomb)
    site = hclattice.lattice_config.lattice_sites
    row, col = size(site)
    labelnum = 0
    labeled_site = - Int.(site)
    searchlist = Vector{Vector{Int}}()

    function checkneighbor!(i,j)
        if labeled_site[i,j] == -1
            if j < col && labeled_site[i, j+1] == -1; push!(searchlist, [i, j+1]); end # right
            if 1 < j && labeled_site[i, j-1] == -1; push!(searchlist, [i, j-1]); end # left

            if iseven(i+j)
                if 1 < i && labeled_site[i-1, j] == -1; push!(searchlist, [i-1, j]); end # above
            else
                if i < row && labeled_site[i+1, j] == -1; push!(searchlist, [i+1, j]); end # down
            end
        end
    end

    @simd for j in 1:col
        @simd for i in 1:row
            if labeled_site[i,j] == -1
                labelnum += 1
                checkneighbor!(i,j)
                labeled_site[i,j] = labelnum

                while !isempty(searchlist)
                    tmppos = pop!(searchlist)
                    checkneighbor!(tmppos...)
                    labeled_site[tmppos...] = labelnum
                end
            end
        end
    end

    hclattice.lattice_properties.islabeled = true
    hclattice.lattice_properties.labeled_lattice_sites = labeled_site

    return nothing
end
