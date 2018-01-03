using Gtk, Gtk.ShortNames
import ImageView.imshow
import PyPlot
export gui


function gui()
    ui = Builder(filename=Pkg.dir() * "/Percolation/src/ui.glade")
    showall(ui["win"])

    function heatmap_button()
        linsize = parse(getproperty(ui["linent"], :text, String))
        p = parse(getproperty(ui["psent"], :text, String))
        l = Square(linsize, p)
        heatmap!(l)
        savefig("cluster.png")
        img = load("cluster.png")
        imshow(img)
        
        println("Visualize")

        return nothing
    end

    function plot_percolation_prob_button()
        latticetypes = Dict(0=>"square", 1=>"triangular", 2=>"honeycomb")
        latticetype = latticetypes[getproperty(ui["latticetype"], "active", Int)]
        linsize = parse(getproperty(ui["linent"], :text, String))
        ps = parse(getproperty(ui["psent"], :text, String))
        pinc = parse(getproperty(ui["pincent"], :text, String))
        pf = parse(getproperty(ui["pfent"], :text, String))
        nsample = parse(getproperty(ui["nsament"], :text, String))

        plot_percolation_prob(latticetype, linsize, ps, pinc, pf, nsample)
        savefig("percoprob.png")
        img = load("percoprob.png")
        imshow(img)
        
        println("Plot Percolation Probability")

        return nothing
    end

    signal_connect(x -> heatmap_button(), ui["visualize_button"], "clicked")
    signal_connect(x -> plot_percolation_prob_button(), ui["plotpercoprob_button"], "clicked")

    return nothing
end
