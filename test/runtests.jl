using Test
using visiblegraph: visible_graph
using Graphs

@testset "visiblegraph tests" begin
    @testset "README example: x = [0.1, 0.5, 0.2, 0.8, 0.4, 0.6]" begin
        x = [0.1, 0.5, 0.2, 0.8, 0.4, 0.6]
        g = visible_graph(x)

        # 頂点数と辺数
        @test nv(g) == 6
        @test ne(g) == 7

        # 存在するエッジ (計7本)
        # 隣接点: (1,2), (2,3), (3,4), (4,5), (5,6)
        # 距離2以上で見通せるペア: (2,4), (4,6)
        expected_edges = [
            (1, 2),
            (2, 3), (2, 4),
            (3, 4),
            (4, 5), (4, 6),
            (5, 6)
        ]
        for (u, v) in expected_edges
            @test has_edge(g, u, v)
        end

        # 存在しないエッジ（遮られるペア）
        blocked_edges = [
            (1, 3), # 2 (0.5 >= 0.15) に遮られる
            (1, 4), # 2 に遮られる
            (1, 5), # 4 に遮られる
            (1, 6), # 4 に遮られる
            (2, 5), # 4 (0.8 >= 0.433) に遮られる
            (2, 6), # 4 に遮られる
            (3, 5), # 4 (0.8 >= 0.3) に遮られる
            (3, 6)  # 4 に遮られる
        ]
        for (u, v) in blocked_edges
            @test !has_edge(g, u, v)
        end

        # 各頂点の次数: deg = [1, 3, 2, 4, 2, 2]
        @test degree(g) == [1, 3, 2, 4, 2, 2]
    end

    @testset "Small series & Boundary cases" begin
        # N = 1
        g1 = visible_graph([1.0])
        @test nv(g1) == 1
        @test ne(g1) == 0

        # N = 2
        g2 = visible_graph([1.0, 2.0])
        @test nv(g2) == 2
        @test ne(g2) == 1
        @test has_edge(g2, 1, 2)

        # N = 3: 山型（中間点が高く遮る） -> パスグラフ (辺数 2)
        g_mountain = visible_graph([1.0, 10.0, 1.0])
        @test nv(g_mountain) == 3
        @test ne(g_mountain) == 2
        @test has_edge(g_mountain, 1, 2)
        @test has_edge(g_mountain, 2, 3)
        @test !has_edge(g_mountain, 1, 3)

        # N = 3: 谷型（中間点が低く見通せる） -> 完全グラフ K_3 (辺数 3)
        g_valley = visible_graph([10.0, 1.0, 10.0])
        @test nv(g_valley) == 3
        @test ne(g_valley) == 3
        @test has_edge(g_valley, 1, 2)
        @test has_edge(g_valley, 2, 3)
        @test has_edge(g_valley, 1, 3)
    end

    @testset "Convex shape (Complete graph)" begin
        # 下に凸な時系列（谷）: すべてのノード間が見通せるため完全グラフ K_N になる
        x_convex = [4.0, 1.0, 0.0, 1.0, 4.0]
        g_convex = visible_graph(x_convex)
        N = length(x_convex)
        @test nv(g_convex) == N
        @test ne(g_convex) == N * (N - 1) ÷ 2
    end

    @testset "Linear series (Path graph)" begin
        # 直線上の時系列: 中間点と直線が等高 (>=) になるため、隣接点以外は遮られる
        x_linear = [1.0, 2.0, 3.0, 4.0, 5.0]
        g_linear = visible_graph(x_linear)
        N = length(x_linear)
        @test nv(g_linear) == N
        @test ne(g_linear) == N - 1
        for i in 1:(N - 1)
            @test has_edge(g_linear, i, i + 1)
        end
    end

    @testset "General properties (Invariants)" begin
        x_test = [0.3, 0.7, 0.1, 0.9, 0.5, 0.2]
        g_test = visible_graph(x_test)
        N = length(x_test)

        # 頂点数
        @test nv(g_test) == N

        # 無向グラフであること
        @test !is_directed(g_test)

        # 常に連結グラフであること (隣接点が必ず繋がるため)
        @test is_connected(g_test)

        # すべての隣接ノード間にエッジが存在すること
        for i in 1:(N - 1)
            @test has_edge(g_test, i, i + 1)
        end
    end
end
