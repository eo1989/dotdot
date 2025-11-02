# %%
from datetime import datetime
from typing import Concatenate, Optional

import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import yfinance as yf

mpl.use("inline")

# %%
# For now:
# stock = input("Enter the ticker symbol (e.g., AAPL, MSFT): ").upper()

stocks: list[str] = [
    "aapl",
    "msft",
    "mdgl",
    "lly",
    "leu",
    "oklo",
    "smr",
    "nvda",
    "amd",
]

# lengths = map(len, strings)
# lengths = map(lambda x: x + "s", strings)
# def add_s(string):
#     return string + "s"
# lengths = map(add_s, strings)
# print(list(lengths))

strings = ["my", "world", "view", "is", "small"]


def longer_than_4(string):
    return len(string) > 4

# filtered = filter()

# start=start_date, end=end_date, interval=interval

# NOTE: end defaults to today!


def fetch_stock_data(
    _ticker_symbol: str | list[str],
    _start_date,
    _end_date: str | None,
    _interval: str = "1d",
) -> None:
    for ticker in stocks:
        yf.Tickers(tickers=_ticker_symbol).history(
            period="1y",
            start=_start_date,
            end=pd.Timestamp.today(),
            interval=_interval,
        )


# %%
# end_date=pd.Timestamp.today().strftime("%Y-%m-%d"),

stock_data = fetch_stock_data(stocks, _start_date="2024-01-01")


# NOTE: Need the subset to include only the 'Close' col

close_prices = stock_data[["Close"]]
close_prices = close_prices.reset_index(drop=True)

# display it to make sure its right.
print(f"close_prices info: {close_prices.info()}")
print(f"close_prices head: {close_prices.head()}")
print(f"close_prices tail: {close_prices.tail()}")

# plotting
plt.subplots()
plt.plot(close_prices)
plt.xlabel("Trading days\nJanruary 1, 2025 through August 14, 2025")
plt.ylabel("Closing Price (USD)")
plt.title(f"{stock} Closing Prices")
plt.grid()
plt.show()


max_close = close_prices["Close"].max()
min_close = close_prices["Close"].min()
print(max_close)
print(min_close)

# test for non-stationarirty in quadrants
rng = np.random.default_rng(42)
plt.figure(figsize=(12, 10))
