module LabelPropagation

using Random: randperm
using StatsBase: countmap
using LightGraphs

export labelpropagation


function labelpropagation(graph::AbstractGraph, max_iter=10000)
    labels = collect(1:nv(graph))
    stable_labels = false
    for _ in 1:max_iter
        if reassign_labels!(graph, labels)
            break
        end
    end
    return labels
end

function reassign_labels!(graph::AbstractGraph{T}, labels::Vector{T}) where T<:Integer
    permu = randperm(nv(graph))
    c = 0
    stable = true
    # for i in permutation
    for (i, node) in zip(permu, vertices(graph)[permu])
        label = labels[i]
        most_frequent_label = find_most_frequent_label(graph, node, labels)    
        if most_frequent_label != label
            labels[i] = most_frequent_label
            stable = false
            c += 1
        end
    end
    println(c)
    return stable
end

function find_most_frequent_label(graph::AbstractGraph{T}, node::T,
                                  labels::Array{T}) where T<:Integer
    neighbours_labels = countmap(labels[neighbors(graph, node)])
    most_frequent_label, _ = findmax(neighbours_labels)
    return most_frequent_label
end

end
