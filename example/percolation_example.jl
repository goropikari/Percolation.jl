using Percolation
using Plots

N = 50; p = 0.6
sq = Square(N, p, "nn")
sq.lattice_config.lattice_sites

label_components!(sq)
sq.lattice_properties.labeled_lattice_sites

sq
Plots.heatmap(sq.lattice_properties.labeled_lattice_sites)