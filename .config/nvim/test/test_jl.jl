using Distributions, Plots; pyplot()
using KittyTerminalImages

recip(x::Number) = (x == zero(typeof(x))) ? error("Invalid reciprocal") : one(typeof(x)) / x;

# recip(2)
# recip(11 // 7)
# recip(11 + 17im)

_a = rand(3)
# recip(aa)  # returns an error, no method matching recip(::Vector())

```markdown
To extend `recip()`,we need to define an additional form using a list
comprehension, or equivalently (in version 1.0), use the map() function.
```

recip(x::Array) = map(recip, _a)

# recip(aa)

# map(sin, recip(_a))

_b = [
    2.1 3.2 4.3;
    9.8 8.7 7.6
]

recip(_b)

_c = recip(_a)' .* recip(_b)
# Matrix multiplication using broadcasting works, recall ' is short-hand for the `transpose()` function.

```markdown
"Hailstone conjecture" by Lothar Collatz

- Sequence of numbers

These can be generated from a starting positive integer, n, by the following rules:
    ◌ if n is 1, the seq ends.
    ◌ if n is even, the next n of the seq = n / 2
    ◌ if n is odd, the next n of the seq = (3 * n) + 1

Effectively, the hailstone sequence for any starting number always terminates
```
# NOTE: w/o a limit the pc will run out of heap space

function hailstone(n::Integer)
    #=
    Function starts by creating an array w/ the single entry `n` & sets the counter `k`
    - the `while - end` block will loop until the value of n reaches 1 & each new value is pushed
        onto the array. Since this effectively modifies the array, by increasing its length,
        the convention of using a `!` is used.
    - statement `(n % 2 == 0) ? n >> 1 : 3n + 1` encapsulates the algorithms logic.
    - n >> 1 is a bit shift left so effectively halves n when n is even.
    =#
    @assert n > 0
    k = 1
    a = [n]
    while n > 1
        n = (n % 2 == 0) ? n >> 1 : 3n + 1
        push!(a, n)
        k += 1
    end
    return (k, a)
end

hailstone(17)

(m, s) = hailstone(1_000)

(m, s) = hailstone(1_000_000)

```markdown
No obvious pattern to the number of iterations needed in order to converge
but all integer values seem to eventually do so.
If the parameter type is restricted to an integer using the modifier ::Integer
and checking if its positive with the `@assert` macro:
```

for i in 1_000:1_000:6_000
    (mx, sx) = hailstone(i)
    println("hailstone($i) => $mx iterations")
end

# %%
p = MvNormal([0, 0], [0.25 0.3; 0.3 1])
X = rand(p, 1000)
x1 = -2.5:0.01:2.5
x2 = -3.5:0.01:3.5

f(x1, x2) = pdf(p, [x1, x2])

scatter(X[1, :], X[2, :], legend = false)
contour!(x1, x2, f, linewidth = 2)

# %%
x = rand(MvNormal([0, 0], [1 0; 0 1]), 1000)
σ = [3 -0.5; -0.5 1]
μ = [1, -2]
e = σ^(1/2) * x .+ μ
