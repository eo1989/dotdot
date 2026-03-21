x = "2+2"

2+2

eval(Meta.parse(ans))

x = replace(x, "+" => "-")

# eval(Meta.parse(ans))
print(eval(Meta.parse(x)))

# x = :(2+2)
# eval(x)

quote
    x = 2 + 2
    hypot(x, 5)
end

:(function mysum(xs)
    sum = 0
    for x in xs
        sum += x
    end
end)

# Fruit of the Expression Tree
# Strings support "Interpolation", which allows us to easily build larger strings from smaller components
x = "yields falsehood when preceded by its quotation"
# println(x)

y = "'x"*"x"
println(y)

x = :(2+2)
:(x*x)

x = rand(Float32, 5, 3)
length(x)
size(x)
x[:, 3]
x + x
x - x
x .+ 1

zeros(5, 5) .+ (1:5)

# The x' syntax is used to transpose a column `1:5` into an equivalent row, and Julia will tile that across columns.
zeros(5, 5) .+ (1:5)'

# make use of this to make a times table.
(1:5) .* (1:5)'

W = randn(1, 10)
x = rand(10)
W * x


# Automatic Differentiation
# --------------------------

f(x) = 3x^2 + 2x + 1
f(5)  # 86

# using Flux: gradient
using Zygote: gradient

df(x) = gradient(f, x)[1]

# df(x)
eltype(df)

#=
Lets try this with a few different inputs to make sure it's really the same as `6x+2`. 
We can even do it multiple times (but the second derivative is a fairly boring `6`)
=#

ddf(x) = gradient(df, x)[1]
ddf(5)


#=
=#

mysin(x) = sum((-1)^k*x^(1 + 2k) / factorial(1 + 2k) for k in 0:5)

x = 0.5

mysin(x), gradient(mysin, x)

sin(x), cos(x)

myloss(W, b, x) = sum(W*x .+ b)

W = randn(3, 5)
b = zeros(3)
x = rand(5)

gradient(myloss, W, b, x)
