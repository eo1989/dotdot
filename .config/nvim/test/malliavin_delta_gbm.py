# ignore: reportInvalidStringEscapeSequence
import matplotlib.pyplot as plt
import numpy as np
from aleatory.processes import GBM, BrownianMotion
from scipy.stats import norm

# %%[markdown]
# noqa: F821
f"""
# Process Dynamics
Using a geometric brownian process, i.e. Black-Scholes world, to model the dynamics of the price of the underlying asset.
This means that $X$ satifies the following PDE:
> $dX_{t} = rX_{t}dt + \sigmaX_{t}dW_{t}$

with $X_{0} = x_{0} > 0$, where $W_{t}$ denotes a standard brownian motion, and both $r$ and $\sigma$ are known parameters.

r = 5%
$\sigma$ = 10%
$x_{0}$ = 100
Maturity (years) = 1

"""
# %%
x0 = 100
r = 0.05
sigma = 0.1
T = 1.0

process = GBM(drift=r, volatility=sigma, initial=x0, T=T)
process.draw(n=100, N=500, title="Monte Carlo Framework")
plt.show()
