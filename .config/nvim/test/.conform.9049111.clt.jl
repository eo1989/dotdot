# Manual histogram creation

# using KittyTerminalImages
# using Plots, Distributions, Random;
# pyplot();
# n = 2000;
# data = rand(Normal(), n);
# l, m = minimum(data), maximum(data);
# δ = 0.3;
# bins = [(x, x + δ) for x in l:δ:m-δ]
# if last(bins)[2] < m
#     push!(bins, (last(bins)[2], m))
# end
# L = length(bins)
# inBin(x, j) = first(bins[j]) <= x && x < last(bins[j])
# sizeBin(j) = last(bins[j]) - first(bins[j])
# f(j) = sum([inBin(x, j) for x in data]) / n
# h(x) = sum([f(j) / sizeBin(j) * inBin(x, j) for j in 1:L])
# xGrid = -4:0.01:4;
# histogram(data, normed=true, bins=L, label="Built-in histogram", c=:blue, la=0, alpha=0.6);
# plot!(xGrid, h.(xGrid), lw=3, c=:red, label="Manual histogram", xlabel="x", ylabel="Frequency");
# plot!(xGrid, pdf.(Normal(), xGrid), label="True PDF", lw=3, c=:green, xlims=(-4, 4), ylims=(0, 0.5))


using KittyTerminalImages
using StatsPlots, Distributions, Random;
pyplot();

Random.seed!(0)

μ₁, σ₁ = 10, 5
μ₂, σ₂ = 40, 12


dist1, dist2 = Normal(μ₁, σ₁), Normal(μ₂, σ₂)
p = 0.3
mixRv() = (rand() <= p) ? rand(dist1) : rand(dist2)

n = 2_000;
data = [mixRv() for _ in 1:n]

density(data, c=:blue, label="Density via StatsPlots", xlims=(-20, 80), ylims=(0, 0.035))

stephist!(data, bins=50, c=:black, norm=true, label="Histogram", xlabel="x", ylabel="Density")

