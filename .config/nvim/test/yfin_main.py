import pandas as pd
import yfinance as yf
from pyrate_limiter import Duration, Limiter, RequestRate

# from requests import Session
from requests_cache import CacheMixin, SQLiteCache
from requests_ratelimiter import LimiterMixin, MemoryQueueBucket
from sqlmodel.orm import session


class CachedLimiterSession(Session):
    pass


# session.Session()


sesh = CachedLimiterSession(
    limiter=Limiter(
        RequestRate(2, Duration.SECOND * 5)
    ),  # max 2 requests per 5 sec
    bucket_class=MemoryQueueBucket,
    backend=SQLiteCache("yfinance_.cache"),
)


def getTickerData(ticker) -> pd.DataFrame:
    data = yf.Ticker(ticker)

    # basic
    income_stmt = data.financials.loc[
        ["Operating Income", "Tax Provision", "Total Revenue", "Diluted EPS"], :
    ]
    balance_sht = data.balance_sheet.loc[
        ["Invested Capital", "Common Stock Equity"], :
    ]
    ttm_eps = data.info["trailingEps"]
    pe = data.info["trailingPE"]
    fcf = data.cash_flow.loc[["Free Cash Flow"], :]

    # calc roic
    tax_rate = (
        income_stmt.loc["Tax Provision"] / income_stmt.loc["Operating Income"]
    )
    nopat = income_stmt.loc["Operating Income"] * (1 - tax_rate)
    roic = nopat / balance_sht.loc["Invested Capital"]

    df = pd.DataFrame(
        {
            "Revenue": income_stmt.loc["Total Revenue"],
            "Equity": balance_sht.loc["Common Stock Equity"],
            "FCF": fcf.loc["Free Cash Flow"],
            "EPS": income_stmt.loc["Diluted EPS"],
            "TTM EPS": ttm_eps,
            "PE": pe,
            "ROIC": roic,
        }
    )

    # calc growth
    df = df[::-1]
    df["Revenue Growth"] = (
        (df["Revenue"] - df["Revenue"].shift(1)) / df["Revenue"].shift(1)
    ) * 100
    df["Equity Growth"] = (
        (df["Equity"] - df["Equity"].shift(1)) / df["Equity"].shift(1)
    ) * 100
    df["FCF Growth"] = (
        (df["FCF"] - df["FCF"].shift(1)) / df["FCF"].shift(1)
    ) * 100
    df["EPS Growth"] = (
        (df["EPS"] - df["EPS"].shift(1)) / df["EPS"].shift(1)
    ) * 100
    df["ROIC Growth"] = (
        (df["ROIC"] - df["ROIC"].shift(1)) / df["ROIC"].shift(1)
    ) * 100

    # calc avg & checking if passes
    avg_revenue_growth = df["Revenue Growth"].mean()
    avg_equity_growth = df["Equity Growth"].mean()


ticker = "MSFT"
historical_df = getTickerData(ticker)

# historical_df.loc[:]
