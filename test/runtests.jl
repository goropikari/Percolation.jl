using Percolation
using Base.Test

# square
## nearest neighbor
@test try
	N = 50; p = 0.6
	sq = Square(N, p, "nn")
	label_components!(sq)
	heatmap!(sq)
	true
catch
	false
end


## next nearest neighbor
@test try
	N = 100; p = 0.45
	sq = Square(N, p, "nnn")
	label_components!(sq)
	heatmap!(sq)
	true
catch
	false
end

# triangular
@test try
	N = 100; p = 0.45
	tri = Triangular(N, p, "nnn")
	label_components!(tri)
	heatmap!(tri)
	true
catch
	false
end

# honeycomb
@test try
	N = 100; p = 0.45
	h = Honeycomb(N, p, "nnn")
	label_components!(h)
	heatmap!(h)
	true
catch
	false
end

# Percolating probability
## square lattice, nearest neighbor
@test try
	linsize = 50
	ps = 0.1
	pinc = 0.025
	pf = 1
	nsample = 50
	plot_percolation_prob("square", linsize, ps, pinc, pf, nsample)
	true
catch
	false
end

## triangular lattice
@test try
	linsize = 50
	ps = 0
	pinc = 0.025
	pf = 1
	nsample = 50
	plot_percolation_prob("triangular", linsize, ps, pinc, pf, nsample)
	true
catch
	false
end

## honeycomb lattice
@test try
	linsize = 50
	ps = 0
	pinc = 0.025
	pf = 1
	nsample = 50
	plot_percolation_prob("honeycomb", linsize, ps, pinc, pf, nsample)
	true
catch
	false
end

# Cluster property
lattice_types = [:Square, :Triangular, :Honeycomb]
@test try
    for lattice_type in lattice_types
        eval(quote
    	    N = 50; p = 0.6
    	    l = $lattice_type(N, p, "nn")
    	    heatmap!(l)
    	    clustersize!(l)
    	    clustersizefreq!(l)
    	    clusternumber!(l)
    	    average_clustersize!(l)
    	    strength!(l)
    end)
    end
    true
catch
	false
end

# Lifetime of forest fire
@test try
	linsize = 50
	ps = 0
	pinc = 0.025
	pf = 1
	nsample = 50
	plot_lifetime(linsize, ps, pinc, pf, nsample)
	true
catch
	false
end
