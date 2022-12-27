# recursive fib() function that accepts an int n and returns the nth value of
# the fibanacci sequence using memoization

# %%
def fib(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 2:
        return 1
    else:
        memo[n] = fib(n - 1, memo) + fib(n - 2, memo)
        return memo[n]


b = fib(432)
print(f"fib(432) is {b}")

# %%
def f(x, y, z):
    return (x + y) / z


a = 5
b = 6
c = 7.5

result = f(a, b, c)
print(result)

#
