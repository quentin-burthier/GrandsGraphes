using LightGraphs
using Random
using GraphPlot
import Cairo, Fontconfig
using Compose

include("label_propagation.jl")
using .LabelPropagation: labelpropagation

function plot_graphs(nb_nodes=400, nb_clusters=4, q=0.1)
    p = [0.1, 0.3, 0.5, 0.9]
    for p_i in p
        g, y = generate_graph(p_i, q, nb_nodes, nb_clusters)
        draw(PNG("../res/$(p_i)_propagation.png", 16cm, 16cm), gplot(g))
    end
end


function main_label_propagation(nb_nodes=400, nb_clusters=4, q=0.1)
    p = [0.1, 0.3, 0.5, 0.9]
    for p_i in p
        graph, gold_labels = generate_graph(p_i, q, nb_nodes, nb_clusters)
        
        labels = labelpropagation(graph)
        # labels, _ = label_propagation(graph) # LightGraph
        println(collect(zip(labels, gold_labels)))
        # nodecolor = [colorant"lightseagreen", colorant"orange", colorant"red", colorant"blue"]
        # nodefillc = nodecolor[membership]
        # draw(PNG("../res/$(p_i)_propagation.png", 16cm, 16cm), 
        #      gplot(graph, nodefillc=nodefillc))
    end
end


function generate_graph(p::Float64, q::Float64, nb_nodes::Int64, nb_clusters::Int64)
    clusters = Vector{Int64}()
    for j in 1:nb_clusters
        for i in 1:Int(floor(nb_nodes//nb_clusters))
            push!(clusters, j)
        end
    end

    edges = Vector{Tuple{Int64, Int64}}()
    for i1 in 1:nb_nodes
        for i2 in i1:nb_nodes
            r = rand()
            if clusters[i1] == clusters[i2]
                if r < p
                    push!(edges, (i1, i2))
                end
            elseif r < q
                push!(edges, (i1, i2))
            end
        end
    end

    g = SimpleGraph(nb_nodes)
    for edge in edges
        add_edge!(g, edge[1], edge[2])
    end

    return g, clusters
end


# plot_graphs()
main_label_propagation()
