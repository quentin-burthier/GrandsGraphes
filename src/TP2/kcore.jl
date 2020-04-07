using DelimitedFiles: readdlm
using ProgressBars

function load_edges(filename, delim, comments)
    return readdlm(filename, delim, Int, comments=comments)
end

function kcore(nodes::Vector{Int64}, edges::Matrix{Int64})
    if minimum(edges) == 0
        edges = edges .+ 1
        nodes = Vector(1:length(nodes)+1)
    end
    n = length(nodes)
    i = n
    c = 0
    # Compute degrees
    degrees = zeros(Int64, n)
    for edge in eachrow(edges)
        degrees[edge[1]] += 1
        degrees[edge[2]] += 1
    end

    for i in ProgressBar(1:n)
        index = argmin(degrees)
        node = nodes[index]
        c = max(c, degrees[index])
        # Update graph
        deleteat!(nodes, index)

        neighbor_edges_indices = Vector{Int64}()

        for (k, edge) in enumerate(eachrow(edges))
            if edge[1] == node || edge[2] == node
                push!(neighbor_edges_indices, k)
            end
        end

        edges = edges[findall(x->!(x in neighbor_edges_indices), 1:size(edges, 1)),:]

        degrees = zeros(Int64, length(nodes))
        for edge in eachrow(edges)
            index1 = findall(x->x==edge[1], nodes)[1]
            index2 = findall(x->x==edge[2], nodes)[1]
            degrees[index1] += 1
            degrees[index2] += 1
        end
        i = i - 1
    end

    return c
end

filename = "com-amazon.ungraph.txt"
edges = load_edges(filename, '\t', true)
nodes = Vector(1:maximum(edges))
core_value = kcore(nodes, edges)