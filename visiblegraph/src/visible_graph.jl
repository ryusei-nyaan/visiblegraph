using Graphs
using GraphPlot

"""
    visible_graph(x::AbstractVector{T}) where T<:Real

Convert a time series `x` into a visibility graph.
Uses the O(N^3) algorithm.
"""
function visible_graph(x::AbstractVector{T}) where T<:Real
    N = length(x)
    g = SimpleGraph(N)
    for i in 1:N
        for j in i+1:N
            cnt = 0
            for k in i+1:j-1
                # Visibility criterion
                if x[k] >= x[j] + (x[i]-x[j]) * (j-k) / (j-i)
                    cnt = 1
                    break
                end
            end
            if cnt == 0
                add_edge!(g, i, j)
            end
        end
    end
    return g
end