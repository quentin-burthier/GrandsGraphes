using LightGraphs
using Random
using GraphPlot
import Cairo, Fontconfig
using Compose
using Colors

#exercice 1
function plot_graphs(nb_nodes=400, nb_clusters=4, q=0.1)
    p = [0.1, 0.3, 0.5, 0.9]
    for p_i in p
        g, y = generate_graph(p_i, q, nb_nodes, nb_clusters)
        draw(PNG(string("../res/", p_i, "_clusters.png"), 16cm, 16cm), gplot(g))
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

#exercice 2

function fy_shuffle!(tab) 
    #Fisher-Yates shuffle
    list_range = [1:1:length(tab);]
    for i in list_range
        j = rand(list_range[1]: list_range[end])
        tab[i], tab[j] = tab[j], tab[i]
    end
    return(tab)
end

function neighbour_label(graph, node, labels)
    #find label occurring with the highest frequency among neighbours of node in graph
    unique_labels = unique(labels)
    values = zeros(length(unique_labels))
    scores = Dict(zip(unique_labels, values))
    
    for neighb in  neighbors(graph, node)
        neighb_label = labels[neighb]
        scores[neighb_label] += 1
    end
    a = argmax(scores)

    return a
end

function label_propagation_step_three(graph,labels)

    new_labels =zeros(length(labels))
    graph_nodes = [1:1:nv(graph);]
    shuffled_nodes = fy_shuffle!(graph_nodes)

    #for each node in the network (in this random order)
    # set its label to a label occurring with the highest frequency among its neighbours
    for node in shuffled_nodes
        new_labels[node] = neighbour_label(graph,node,labels)
    end
    
    return new_labels
end

function label_propagation!(graph, init_labels, max_iter=1000)

    test = true #bool that indicates if the we keep iterating the algorithm
    n_iter = 0
    labels = init_labels
    
    while test
        #step three: label propagation
        labels = label_propagation_step_three(graph,labels)
        
        #stoping criteria
        test = false
        for node in vertices(graph)
            # Check if one node doesn't belong to the same communities than the majority of its neighbors
            if labels[node] != neighbour_label(graph,node,labels)
                test = true# If one node doesn't satisfy the condition, we need to continue
            end
        end
        
        if n_iter > max_iter
            test = false
        end
        
        n_iter+=1
    end
    
    return labels
end
                

function main_label_propagation(nb_nodes=400, nb_clusters=4, q=0.1)
    p = [0.1, 0.3, 0.5, 0.9]
#     p = [0.1]
    for p_i in p
        graph, true_y = generate_graph(p_i, q, nb_nodes, nb_clusters)
        
        ##
        init_y = [1:1:nv(graph);]
        init_y = fy_shuffle!(init_y)
        
        label_prop_y = label_propagation!(graph, init_y)
        membership = unique(label_prop_y)
        chosen=[]
        for l in label_prop_y
            f = findall(membership .== l)
            push!(chosen, f[1])
        end
        
        nodecolor = [colorant"lightseagreen", colorant"orange", colorant"blue", colorant"purple"]
        nodefillc = nodecolor[chosen]
        draw(PNG(string("../res/", p_i, "_propagation.png"), 16cm, 16cm),gplot(graph, nodefillc=nodefillc))

	nodefillc2 = nodecolor[true_y]
	draw(PNG(string("../res/", p_i, "_true.png"), 16cm, 16cm),gplot(graph, nodefillc=nodefillc2))
    end
end


main_label_propagation()
