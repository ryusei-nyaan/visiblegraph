# visiblegraph

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

時系列データを可視化グラフ（Visibility Graph）に変換するための Julia スクリプトです。

A Julia script for converting time series data into **Visibility Graphs**.

## 可視化グラフ (Visibility Graph) とは

可視化グラフアルゴリズムは、時系列データ $x(t)$ をグラフ $G = (V, E)$ に変換する手法です。
2つのデータ点 $i$ と $j$ の間に他のデータ点 $k$ ($i < k < j$) があり、以下の条件を満たす場合にエッジが張られます：

$$x_k < x_j + (x_i - x_j) \frac{j - k}{j - i}$$

直感的には、時系列を棒グラフとして見たときに、点 $i$ の頂上から点 $j$ の頂上が「見える」場合に接続されます。

## セットアップ (Setup)

このリポジトリは独立したパッケージとして構成されていないため、ファイルを直接ダウンロードして `include` してください。また、依存パッケージとして `Graphs` と `GraphPlot` ,表示のために `Cairo`も必要です。

```julia
using Pkg
Pkg.add(["Graphs", "GraphPlot", "Cairo"])

using Downloads
# スクリプトのダウンロード
url = "https://raw.githubusercontent.com/ryusei-nyaan/visiblegraph/main/visiblegraph/src/visible_graph.jl"
Downloads.download(url, "visible_graph.jl")

# 読み込み
include("visible_graph.jl")
```

## 使い方 (Usage)

```julia
using Graphs
using GraphPlot

# サンプルデータ (Sample time series)
x = [0.1, 0.5, 0.2, 0.8, 0.4, 0.6]

# 可視化グラフの生成 (Generate visibility graph)
g = visible_graph(x)

# グラフの描画 (Plot the graph)
gplot(g)
```

## アルゴリズムの計算量 (Complexity)

現在の実装は $O(N^3)$ のナイーブなアルゴリズムを使用しています。

## ライセンス (License)

MIT License
