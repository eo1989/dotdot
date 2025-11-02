using Plots, Distributions, PlotThemes, DataFrames
using KittyTerminalImages

# PlotThemes.default_theme!()
# PlotThemes.default_theme!()
theme(:juno)
Plots.scalefontsizes(1.3)

x = 1:7
y = [3, 1, 4, 1, 5, 9, 2]

foreach(
theme -> begin
    theme!(theme)
    display("image/png", plot(rand(10), title = string(theme)))
    theme!(:default)  # reset after aech plot
end, themes)



# defining cdf & pdf
N(x) = cdf(Normal(0, 1), x)
n(x) = pdf(Normal(0, 1), x)

# generic put call pricer
function BSM(S, K, t, r, q, σ)
    d1 = (log(S / K) + (r - q + 1 / 2 * σ^2) * t) / (σ * √t)
    d2 = d1 - σ * √t
    c = exp(-q * t)S * N(d1) - exp(-r * t) * K * N(d2)
    theta = (-(S * exp(-q * t) * n(d1) * σ) / (2 * √t)) + q * exp(-q * t) * S * N(d1) - r * exp(-r * t) * K * N(d2) / 365
    return c, theta
end

spot = 0.2:0.1:15
k = 5
r = 0.03
q = 0.09
q2 = 0.12
t = 1
σ = 0.3

# compute option
opt_val = BSM.(spot, k, t, r, q, σ)
df = DataFrame(BSM.(spot, k, t, r, q, σ))
rename!(df, :2 => :theta)
theta = df[!, :theta]

df1 = DataFrame(BSM.(spot, k, t, r, q2, σ))
rename!(df1, :2 => :theta1)
theta1 = df1[!, :theta1]

x = [i < 0 ? i : 0 for i in [val[1] for val in opt_val] .- [val for val in max.(spot .- k, 0)]]
area = [val[1] for val in opt_val] .- x

# plot option
plot(
    spot, [val[1] for val in opt_val],
    label = "Theoretical Value with dividend = $(round(q * 100, digits = 4))%",
    title = "Natenberg replica",
    size = (900, 600),
    xlabel = "Underlying Price",
    ylabel = "Option Value",
    linwidth = 2,
    linecolor = :lightgreen
)

# plot intrinsic value
plot!(spot, [val for val in max.(spot .- k, 0)], label = "Intrinsic Value", legend = :topleft, linestyle = :dash)

## color the area where there is negative time value
plot!(
    spot, [val[1] for val in opt_val],
    fillrange = area, fillalpha = 0.35, c = 3, label = "Negative Time Value with dividend = $(round(q * 100, digits = 4))%"
)

# plot a second option with a different dividend
plot!(spot, [val[1] for val in BSM.(spot, k, t, r, q2, σ)], label = "Theoretical Value with dividend = $(round(q2 * 100, digits = 4))%", title = "Natenberg replica")

# shade area where theta is positive
vspan!(
    [spot[length(opt_val) - length(theta[theta .>= 0])], spot[length(spot)]],
    linecolor = :grey, fillcolor = :blue, opacity = 0.05,
    label = "Positive θ for dividend = $(round(q * 100, digits = 4))%"
)

vspan!(
    [spot[length(opt_val) - length(theta1[theta1 .>= 0])], spot[length(spot)]],
    linecolor = :grey, fillcolor = :yellow, opacity = 0.03,
    label = "Positive θ for dividend = $(round(q2 * 100, digits = 4))%"
)
