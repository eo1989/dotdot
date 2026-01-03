import PlotlyBase: Plot
using Plots, Distributions, DataFrames, Random, StatsPlots, Measures; pyplot()
using KittyTerminalImages

# theme(:juno)
# Plots.scalefontsizes(1.3)

x = 1:7
y = [3, 1, 4, 1, 5, 9, 2]

# foreach(theme -> begin
#     theme!(theme)
#     display("image/png", plot(rand(10), title = string(theme)))
#     theme!(:default)
# end,themes)

# Calculate the ł^\upRho norm of a vector, where an anonymous function is used for $x \RightTeeVector |x|^\upRho$
# norm(v::Vector, p::Number) = mapreduce(x -> abs(x)^p, +, v)^(1/p)

# Or with optional arguments: for example for the $ł^2$ norm (most popular of the ł^p norms)
norm(v::Vector, p::Number = 2) = mapreduce(x -> abs(x)^p, +, v)^(1/p)

norm([-1, -2, -3])

norm([-1, -2, -3], 1)

norm(v::Vector, p::Number) = 
    mapreduce(+, v) do x
        abs(x)^p
    end^(1/p)
    


## From stats w/ julia
Random.seed!(42)

b1, b2 = 0.5, 2
dist1, dist2 = Beta(b1, b1), Beta(b2, b2)

n = 2_000
data1 = rand(dist1, n)
data2 = rand(dist2, n)

stephist(data1, bins = 15, label = "beta($b1, $b1)", c = :red, normed = true)

p1 = stephist!(data2, bins = 15, label = "beta($b2,$b2)", c = :blue, xlabel = "x", ylabel = "Density", normed = true)

p2 = qqplot(data1, data2, c= :black, ms = 1, msw = 0, xlabel = "Quantiles for beta($b1, $b1) sample", ylabel = "Quantiles for beta($b2, $b2) sample", legend = false )

plot(p1, p2, size = (800, 400), margin = 5mm)
##


# %% [markdown]
# Ackleys function
# $$
# f(x) = -\alpha \exp\left{-b \sqrt{frac{1}{d}\Sum_{i=1}^{d}x_{i}^{2}}}\right} - \exp{\left{-b \sqrt{frac{1}{d}\Sum_{i=1}^{d}cos(cx_{i})}}\right}} + \alpha + \exp(1)
# $$
# %%

# 
function ackley(x, a = 20, b = 0.2, c = 2π)
    d = length(x)
    return -a * exp(-b * sqrt(sum(x.^2)/d)) -
                exp(sum(cos.(c*xi) for xi in x)/d) + a + exp(1)
end

# Booth's function: two-dimensional quadratic function
# example w/ a global minimum at [1,3]
# equation:
# $$
# f(x) = (x_{1} + 2x_{2} - 7)^2 + (2x_{1} + x_{2} - 5)^2
# $$
booth(x) = (x[1] + 2x[2] - 7)^2 + (2x[1] + x[2] - 5)^2

# Branin function: two-dimensional function
# $ f(x) = α(x_{2} - bx_{1}^{2} + cx_{1} - r)^2 + s(1 - t)cos(x_{1}) + s $
# with recommended values at $α = 1, b = 5.1/(4π^{2}), c = 5/π, r = 6, s = 10, t = 1/(8π)$
# no local minima aside from global minima with $x_{1} = π + 2πm$ for integer $m$. Four of these minima are:
# $$
#
# $$

# Newton function for finding roots of nonlinear functions
function newton(f::Function, df::Function, x0; typ = Float64, tol = 1e-6, max_iterations::Integer = 100)
    @assert tol > 0
    @assert max_iterations >= 1

    local x = typ(x0)
    local i = 1
    while abs(f(x)) >= tol && i <= max_iterations
        x += -f(x)/df(x)
        @show i, x, f(x)
        i += 1
    end
    x
end
newton(sin, cos, 3.0, typ = Float32, tol = 1e-15, max_iterations = 5)
newton(sin, cos, 3.0, tol = 5e-16)

foo(a; b = 0, c...) = c
foo(1, b = 2)

# This is equivalent to
foo(1, b = 2; bar = 3, baz = 4)

# this. As in "syntactic sugar".
foo(1, b = 2; :bar => 3, :baz => 4)
# both pass the keyword arguments

# This general facility for passing keyword arguments is useful when the keyword names are
# computed at runtime or when a number of keyword arguments is assembled and passed through
# one of more function calls and receiving functions picks the keyword arguments it needs.

# Sometimes its convenient for a function to take a variable number of arguments. The syntax
# to supply the arguments as a tuple is that the last argument is followed by an ellipsis`...`
# The variables `args` is bound to a tuple of all the trailing values passed to the function.
foo(a, b, c, args...) = args
foo(1, 2, 3)  # ()
foo(1, 2, 3, 4, 5, 6)  # (4, 5, 6)

# Analogously the ellipsis `...` can be used in a function call to splice the values contained
# in an iterable collection into a function call as individual arguments.
foo((1, 2, 3, 4, 5, 6)...)  # (4, 5, 6)
foo([1, 2, 3, 4, 5, 6]...)  # (4, 5, 6)

# The above example shows that the splied arguments can also take the place of fixed arguments.
# in fact the function call taking a spliced argument list doesnt have to take a variable number
# of arguments at all.



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

spot = S = 0.2:0.01:20
K = 5
r = 0.035
q = 0.013
q2 = 0.12
t = 5/252
σ = 0.32

# compute option
opt_val = BSM.(spot, K, t, r, q, σ)
df = DataFrame(BSM.(spot, K, t, r, q, σ))
rename!(df, :2 => :theta)
theta = df[!, :theta]

df1 = DataFrame(BSM.(spot, K, t, r, q2, σ))
rename!(df1, :2 => :theta1)
theta1 = df1[!, :theta1]

x = [i < 0 ? i : 0 for i in [val[1] for val in opt_val] .- [val for val in max.(spot .- K, 0)]]
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
plot!(spot, [val for val in max.(spot .- K, 0)], label = "Intrinsic Value", legend = :topleft, linestyle = :dash)

## color the area where there is negative time value
plot!(
    spot, [val[1] for val in opt_val],
    fillrange = area, fillalpha = 0.35, c = 3, label = "Negative Time Value with dividend = $(round(q * 100, digits = 4))%"
)

# plot a second option with a different dividend
plot!(spot, [val[1] for val in BSM.(spot, K, t, r, q2, σ)], label = "Theoretical Value with dividend = $(round(q2 * 100, digits = 4))%", title = "Natenberg replica")

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
