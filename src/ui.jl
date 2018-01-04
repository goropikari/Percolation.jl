function gui()
    ui = Builder(filename=Pkg.dir() * "/Percolation/src/ui.glade")
    showall(ui["win"])
    setproperty!(ui["imagebox"], :file, Pkg.dir() * "/Percolation/src/Julia_prog_language_logo.svg")
    setproperty!(ui["latticetype_cb"], "active", 0)
    setproperty!(ui["nsament"], :text, 10)
    setproperty!(ui["linent"], :text, 50)
    setproperty!(ui["psent"], :text, 0.1)
    setproperty!(ui["pincent"], :text, 0.1)
    setproperty!(ui["pfent"], :text, 1)
    setproperty!(ui["probent"], :text, 0.5)


    outputdir = tempdir() * "/percolation_" * randstring()
    mkdir(outputdir)
    filename = ""

    function heatmap_button()
        linsize = parse(getproperty(ui["linent"], :text, String))
        p = parse(getproperty(ui["probent"], :text, String))
        l = Square(linsize, p)
        heatmap!(l)
        filename = outputdir * "/cluster.png"
        savefig(filename)

        setproperty!(ui["imagebox"], :file, filename)
        println("Visualize")

        return nothing
    end

    function phase_transition_button()
        latticetype = getproperty(ui["latticetype_cb"], "active", Int)
        if latticetype in [0,1,2]
            plot_percolation_prob_button()
        elseif latticetype == 3
            plot_lifetime_button()
        end

        return nothing
    end

    function plot_percolation_prob_button()
        latticetypes = Dict(0=>"square", 1=>"triangular", 2=>"honeycomb")
        latticetype = latticetypes[getproperty(ui["latticetype_cb"], "active", Int)]
        linsize = parse(getproperty(ui["linent"], :text, String))
        ps = parse(getproperty(ui["psent"], :text, String))
        pinc = parse(getproperty(ui["pincent"], :text, String))
        pf = parse(getproperty(ui["pfent"], :text, String))
        nsample = parse(getproperty(ui["nsament"], :text, String))

        plot_percolation_prob(latticetype, linsize, ps, pinc, pf, nsample)
        filename = outputdir * "/percoprob.png"
        savefig(filename)

        setproperty!(ui["imagebox"], :file, filename)
        println("Plot Percolation Probability")

        return nothing
    end

    function plot_lifetime_button()
        linsize = parse(getproperty(ui["linent"], :text, String))
        ps = parse(getproperty(ui["psent"], :text, String))
        pinc = parse(getproperty(ui["pincent"], :text, String))
        pf = parse(getproperty(ui["pfent"], :text, String))
        nsample = parse(getproperty(ui["nsament"], :text, String))

        plot_lifetime(linsize, ps, pinc, pf, nsample)
        filename =  outputdir * "/lifetime.png"
        savefig(filename)

        setproperty!(ui["imagebox"], :file, filename)
        println("Plot Lifetime of forest")
        return nothing
    end

    function savefig_button()
        dstname = save_dialog("Save figure")
        cp(filename, dstname, remove_destination=true)

        return nothing
    end

    function forestfire_gif_button()
        linsize = parse(getproperty(ui["linent"], :text, String))
        p = parse(getproperty(ui["probent"], :text, String))

        forest = Forest(linsize, p)
        filename = forestfire!(forest, gifanime=true)[2]

        setproperty!(ui["imagebox"], :file, filename)
        println("Genarate GIF animation")

    end

    signal_connect(x -> savefig_button(), ui["savefig_button"], "clicked")
    signal_connect(x -> heatmap_button(), ui["visualize_button"], "clicked")
    signal_connect(x -> phase_transition_button(), ui["phase_transition_button"], "clicked")
    signal_connect(x -> forestfire_gif_button(), ui["forestfire_gif_button"], "clicked")


    signal_connect(ui["latticetype_cb"], "changed") do widget, others...
        idx = getproperty(ui["latticetype_cb"], "active", Int)
        if idx in [0, 1, 2]
            setproperty!(ui["phase_transition_button"], :label, "Plot percolation probability")
        elseif idx == 3
            setproperty!(ui["phase_transition_button"], :label, "Plot Lifetime")
        end
    end


    return nothing
end
