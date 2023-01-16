# %%
import numpy as np
import pandas as pd
from ipywidgets import *
from bqplot import DateScale, LinearScale
import bqplot.pyplot as plt
from bqplot.interacts import FastIntervalSelector

# %%


def regress(x, y):
    b = np.cov(x, y)[0, 1] / np.var(x)
    a = y.mean() - b * x.mean()
    return a, b


def trend_score(x, y):
    """Computes trend score as a cube of the correlation coeff."""
    return np.corrcoef(x, y)[0, 1] ** 3


# %%
spx_prices = pd.read_csv(
    "~/SPY_history_2021-04-01_13:30:23.csv", index_col=0, parse_dates=True
)
dates = spx_prices.index

# This drops everything except the date and the adjusted close column.
spx = spx_prices.drop(["open", "low", "high", "close", "volume", "symbol"], axis=1)

# print(spx)

# print(prices)
log_returns = np.log(spx / spx.shift(1)).dropna()

# %%
