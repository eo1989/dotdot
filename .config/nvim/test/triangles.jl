# %%
using DataFrames
using Plots
using KittyTerminalImages
gr()


# println(backends())

# first arguments in these calls are arrays of angular coordinates.
# second args are fx's mapping the angle to the distance from the origin, using
# t as a dummy variable.
# `proj = :polar` tells `plot()` to make a polar plot.
# blubber = plot(0:(2π / 500):2π, t -> 1 + 0.2 * sin(8t); proj = :polar)
# lspiral = plot(0:(8π / 200):8π, t -> t; proj = :polar)
# plot(blubber, lspiral)

# circle = plot(sin, cos, 0, 2π)
# spiral = plot(r -> r * sin(r), r -> r * cos(r), 0, 8π)
# plot(circle, spiral)

# function ginger(x, y, a)
#     x² = 1.0 - y + a * abs(x)
#     y² = x
#     return x², y²
# end
# x = [20.0]; y = [9.0];

# The ginger function returns a tuple w/ its first mmeber stored in x² and its
# second in y².
# for i in 1:4_000
#     x², y² = ginger(x[end], y[end], 1.76)  # this is destructuring
#     push!(x, x²)
#     push!(y, y²)
# end
# scatter(x, y; ms = 0.5, legend = false)

f(x) = sin(1 / x)
x = (n / 1_000):(n / 1_000):n
plot(x, f.(x))

parabola = plot(x -> x^2);
ps = plot(sin, 0, 2π);
plot!(ps, cos);
plot(ps, plot(f))


# %%
triangle_count = 17
base = 4.0

function pythagorean_spiral(triangle_count, base)
    hypotenuses = Float64[]
    angles = Float64[]

    for n in 1:triangle_count
        hypotenuse = sqrt(base^2 + (n * base)^2)
        angle = atan(n * base / base)

        push!(hypotenuses, hypotenuse)
        push!(angles, angle)
    end

    return hypotenuses, angles
end

hypotenuses, θ = pythagoran_spiral(triangle_count, base)

# %%
# create df w/ the hypotenuse & angles (Θ), need to convert the angles to
# degrees first for display

DataFrame(Hypotenuse = hypotenuses, Angle = Θ .* 180 / π)

# %%

"""
An anonymous function is a fx w/o a name. You can create one-line anonymous functions
with the `->` operator. W/o anonymous functions, you'd need to write `splitter` & `mapper` as shown further below.
"""

splitter(dlm) = str -> split(str, dlm)
mapper(fn) = xs -> map(fn, xs)


# %%

function camel_case(input::AbstractString)
    return input |> splitter('_') |> mapper(uppercasefirst) |> join
end

# %%

f = splitter('_')
words = f("hello_how_are_you")


# %%
g = mapper(uppercasefirst)
g(words)
# %%


# %%
#

# `splitter` & `mapper` w/o anonymous functions
"Create a function which splits on `dim` character"
function splitter(dlm)
    function f(str)
        return split(str, dlm)
    end
    return f  # this return isnt needed; its just added to emphasize that f is returned.
end

"Create a function applying function `fn` on all its input"
function mapper(fn)
    function g(xs)
        return map(fn, xs)
    end
    return g  # this return isnt needed also, but the last expr is returned anyway
end
