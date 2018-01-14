export gui

function gui()
    ui = Builder(filename=joinpath(@__DIR__, "ui.glade"))
    showall(ui["win"])
    setproperty!(ui["imagebox"], :file, joinpath(@__DIR__, "Julia_prog_language_logo.svg"))
    visible(ui["forestfire_gif_button"], false)

    outputdir = joinpath(tempdir(), "JuliaPercolation")
    mkpath(outputdir)
    filename = ""

    function getparameters()
        linsize = parse(getproperty(ui["linent"], :text, String))
        nsample = parse(getproperty(ui["nsament"], :text, String))
        ps = parse(getproperty(ui["psent"], :text, String))
        pinc = parse(getproperty(ui["pincent"], :text, String))
        pf = parse(getproperty(ui["pfent"], :text, String))

        return linsize, nsample, ps, pinc, pf
    end

    function heatmap_button()
        linsize = parse(getproperty(ui["linent"], :text, String))
        p = parse(getproperty(ui["probent"], :text, String))
        latticetype = getproperty(ui["latticetype_cb"], "active", Int)
        if latticetype == 0
            l = Square(linsize, p)
        elseif latticetype == 1
            l = Triangular(linsize, p)
        elseif latticetype == 2
            l = Honeycomb(linsize, p)
        end
        heatmap!(l)
        filename = joinpath(outputdir, "cluster.png")
        savefig(filename)

        setproperty!(ui["imagebox"], :file, filename)
        println("Visualize $(typeof(l))")

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
        linsize, nsample, ps, pinc, pf = getparameters()

        plot_percolation_prob(latticetype, linsize, ps, pinc, pf, nsample)
        filename = joinpath(outputdir, "percoprob.png")
        savefig(filename)

        setproperty!(ui["imagebox"], :file, filename)
        println("Plot Percolation Probability of $(latticetype) lattice")

        return nothing
    end

    function plot_lifetime_button()
        linsize, nsample, ps, pinc, pf = getparameters()

        plot_lifetime(linsize, ps, pinc, pf, nsample)
        filename =  joinpath(outputdir, "lifetime.png")
        savefig(filename)

        setproperty!(ui["imagebox"], :file, filename)
        println("Plot Lifetime of forest")
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

    function savefig_button()
        dstname = save_dialog("Save figure")
        if contains(filename, ".png")
            if !contains(dstname, ".png")
                dstname *= ".png"
            end
        elseif contains(filename, ".gif")
            if !contains(dstname, ".gif")
                dstname *= ".gif"
            end
        end
        cp(filename, dstname, remove_destination=true)

        return nothing
    end

    signal_connect(x -> savefig_button(), ui["savefig_button"], "clicked")
    signal_connect(x -> heatmap_button(), ui["visualize_button"], "clicked")
    signal_connect(x -> phase_transition_button(), ui["phase_transition_button"], "clicked")
    signal_connect(x -> forestfire_gif_button(), ui["forestfire_gif_button"], "clicked")
    signal_connect(ui["latticetype_cb"], "changed") do widget, others...
        idx = getproperty(ui["latticetype_cb"], "active", Int)
        if idx in [0, 1, 2]
            setproperty!(ui["phase_transition_button"], :label, "Plot percolation probability")
            visible(ui["visualize_button"], true)
            visible(ui["forestfire_gif_button"], false)
        elseif idx == 3
            setproperty!(ui["phase_transition_button"], :label, "Plot Lifetime")
            visible(ui["visualize_button"], false)
            visible(ui["forestfire_gif_button"], true)
        end
    end

    if !isinteractive()
        c = Condition()
        signal_connect(ui["win"], :destroy) do widget
            notify(c)
        end
        wait(c)
    end

    return nothing
end
