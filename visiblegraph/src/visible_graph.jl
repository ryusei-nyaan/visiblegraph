using LightGraphs
using GraphPlot

function visible_graph(x)
    N = length(x)
    g = SimpleGraph(N)
    for i = 1:N
        for j = i+1:N
            cnt = 0
            for k = i+1:j-1
                if x[k]>=x[j]+(x[i]-x[j])*(j-k)/(j-i)
                    cnt = 1
                    break
                end
            end
            if cnt == 0
                add_edge!(g,i,j)
            end
        end
    end
    return g
end