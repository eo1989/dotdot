import sqlite3 as sql
import string

import numpy as np
import pandas as pd

rng = np.random.default_rng(42)
start_date = pd.Timestamp("2003-01-01")
end_date = pd.Timestamp("2022-12-31")

_dummy_years = np.arange(start=start_date.year, stop=end_date.year + 1, step=1)
_dummy_months = pd.date_range(start=start_date, end=end_date, freq="MS")
_dummy_days = pd.date_range(start=start_date, end=end_date, freq="D")

# Create stock dummy data
_num_stocks = 100

industries = pd.DataFrame(
    {
        "industry": [
            "Agriculture",
            "Construction",
            "Finance",
            "Manufacturing",
            "Mining",
            "Public",
            "Retail",
            "Services",
            "Transportation",
            "Utilities",
            "WholeSale",
        ],
        "n": [81, 287, 4682, 8584, 1287, 1974, 1571, 4277, 1249, 457, 904],
        "prob": [
            0.00319,
            0.0113,
            0.185,
            0.339,
            0.0508,
            0.0779,
            0.0620,
            0.169,
            0.0493,
            0.0180,
            0.03451,
        ],
    }
)

exchanges = pd.DataFrame(
    {
        "exchange": ["AMEX", "NASDAQ", "NYSE"],
        "n": [2893, 17236, 5553],
        "prob": [0.113, 0.671, 0.216],
    }
)

stock_identifiers_list = []
for x in range(1, _num_stocks + 1):
    exchange = np.random.choice(exchanges["exchange"], p=exchanges["prob"])
    industry = np.random.choice(industries["industry"], p=industries["prob"])

    exchcd_mapping = {
        "NYSE": np.random.choice([1, 31]),
        "AMEX": np.random.choice([2, 32]),
        "NASDAQ": np.random.choice([3, 33]),
    }

    siccd_mapping = {
        "Agriculture": np.random.randint(1, 1000),
        "Mining": np.random.randint(1000, 1500),
        "Construction": np.random.randint(1500, 1800),
        "Manufacturing": np.random.randint(1800, 4000),
        "Transportation": np.random.randint(4000, 4900),
        "Utilities": np.random.randint(4900, 5000),
        "Wholesale": np.random.randint(5000, 5200),
        "Retail": np.random.randint(5200, 6000),
        "Finance": np.random.randint(6000, 6800),
        "Services": np.random.randint(7000, 9000),
        "Public": np.random.randint(9000, 10_000),
    }

    stock_identifiers_list.append(
        {
            "permno": x,
            "gvkey": str(x + 10_000),
            "exchange": exchange,
            "industry": industry,
            "exchcd": exchcd_mapping[exchange],
            "siccd": siccd_mapping[industry],
        }
    )


stock_identifiers = pd.DataFrame(stock_identifiers_list)

stock_panel_yearly = pd.DataFrame(
    {
        "gvkey": np.tile(stock_identifiers["gvkey"], len(_dummy_years)),
        "year": np.repeat(_dummy_years, len(stock_identifiers)),
    }
)

stock_panel_monthly = pd.DataFrame(
    {
        "permo": np.tile(stock_identifiers["permo"], len(_dummy_months)),
        "gvkey": np.tile(stock_identifiers["gvkey"], len(_dummy_months)),
        "date": np.repeat(_dummy_months, len(stock_identifiers)),
        "siccd": np.tile(stock_identifiers["siccd"], len(_dummy_months)),
        "industry": np.tile(stock_identifiers["industry"], len(_dummy_months)),
        "exchcd": np.tile(stock_identifiers["exchcd"], len(_dummy_months)),
        "exchange": np.tile(stock_identifiers["exchange"], len(_dummy_months)),
    }
)

stock_panel_daily = pd.DataFrame(
    {
        "permo": np.tile(stock_identifiers["permo"], len(_dummy_days)),
        "date": np.repeat(_dummy_days, len(stock_identifiers)),
    }
)


# Dummy `beta` table

beta_dummy = stock_panel_monthly.assign(
    beta_monthly=rng.normal(loc=1, scale=1, size=len(stock_panel_monthly)),
    beta_daily=lambda x: (
        x["beta_monthly"] + rng.normal(scale=0.01, size=len(x))
    ),
)

(
    beta_dummy.to_sql(
        name="beta", con=tidy_finance, if_exists="replace", index=False
    )
)

# Dummy `Compustat` table

relevant_cols = [
    "seq",
    "ceq",
    "at",
    "lt",
    "txditc",
    "txdb",
    "itcb",
    "pstkrv",
    "pstkl",
    "pstk",
    "capx",
    "oancf",
    "sale",
    "cogs",
    "xint",
    "xsga",
    "be",
    "op",
    "at_lag",
    "inv",
]

commands = {
    col: np.random.rand(len(stock_panel_yearly)) for col in relevant_cols
}

compustat_dummy = stock_panel_yearly.assign(
    datadate=lambda x: pd.to_datetime(x["year"].astype(str) + "-12-31")
).assign(**commands)

(
    compustat_dummy.to_sql(
        name="computstat", con=tidy_finance, if_exists="replace", index=False
    )
)


# Dummy `crsp_monthly` table

crsp_monthly_dummy = stock_panel_monthly.assign(ret=lam)
