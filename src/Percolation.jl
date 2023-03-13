module Percolation

using Gtk, Gtk.ShortNames, StatsBase, Plots, Random
gr()
import Plots: heatmap, heatmap!
import Images: label_components, label_components!

include("latticetype.jl")
include("connected.jl")
include("clusterproperties.jl")
include("forestfire.jl")
include("visualize.jl")
include("ui.jl")

end # module
