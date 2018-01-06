module Percolation

using Gtk, Gtk.ShortNames, Plots; gr()
import Plots: heatmap, heatmap!
import Images: label_components, label_components!


export Square, Triangular, Honeycomb, Forest
export label_components!, ispercolation!
export forestfire!, plot_lifetime
export heatmap!, plot_percolation_prob
export gui

include("latticetype.jl")
include("connected.jl")
include("forestfire.jl")
include("visualize.jl")
include("ui.jl")


function ispercolation!(l::TwoDLattice)
    if !l.lattice_properties.islabeled
        label_components!(l)
        l.lattice_properties.islabeled = true
    end

    labeled_site = l.lattice_properties.labeled_lattice_sites

    tmpset = (Set(labeled_site[1,:]) ∩ Set(labeled_site[end,:])) ∪ (Set(labeled_site[:,1]) ∩ Set(labeled_site[:,end]))
    tmpset = setdiff(tmpset, 0)

    return l.lattice_properties.ispercolation = ifelse(isempty(tmpset), false, true)
end


end # module
