import requests as req
import json
import os
import pandas as pd
import matplotlib.pyplot as plt

from matplotlib import dates
from datetime import timedelta, datetime


CONTRACT_SIZE = 100

# Make sure to run this file in the lua/as or /as/plugins directories.
# Whichechever folder has the 'data' in it.

def run(ticker):
    spot_price, option_data = scrape_data(ticker)
    comp_tot_gex(spot_price, option_data)
    comp_gex_by_strike(spot_price, option_data)
    comp_gex_by_expiration(option_data)
    print_gex_surface(spot_price, option_data)


def scrape_data(ticker):
    """
    scrape data from CBOE website

    Args:
        ticker (TODO): str, ex: 'AAPL', 'MSFT', 'TSLA
    """
    if f"{ticker}.json" in os.listdir("data"):
        f = open(f"data/{ticker}.json")
        data = pd.DataFrame.from_dict(json.load(f))
    else:
        # req data
        data = req.get(
            f"https://cdn.cboe.com/api.global/delayed_quotes/options/_{ticker}.json"
        )
        with open(f"data/{ticker}.json", "w") as f:
            json.dump(data.json(), f)

        data = pd.DataFrame.from_dict(data.json())

    spot_price = data.loc["current_price", "data"]
    option_data = pd.DataFrame(data.loc["options", "data"])

    return spot_price, fix_option_data(option_data)


def fix_option_data(data):

    data["type"] = data.option.str.extract(r"\d([A-Z])\d")
    data["strike"] = data.option.str.extract(r"\d[A-Z](\d+)\d\d\d").astype(int)
    data["expiration"] = data.option.str.extract(r"[A-Z](\d+)").astype(str)

    # conv expiration to datetime format
    data["expiration"] = pd.to_datetime(data["expiration"], format="%y%m%d")
    return data


def comp_tot_gex(spot, data):
    data["GEX"] = spot * data.gamma * \
        data.open_interest * CONTRACT_SIZE * spot * 0.01

    data["GEX"] = data.apply(
        lambda x: -x.GEX if x.type == "P" else x.GEX, axis=1)
    print(f"Total notional GEX: ${round(data.GEX.sum() / 10**9, 4)} Bn")


def comp_gex_by_strike(spot, data):
    gex_by_strike = data.groupby("strike")["GEX"].sum() / 10**9

    # data limited to +/- 25%
    limit_criteria = (gex_by_strike.index > spot * 0.75) & (
        gex_by_strike.index < spot * 1.25
    )

    plt.bar(
        gex_by_strike.loc[limit_criteria].index,
        gex_by_strike.loc[limit_criteria],
        width=5,
        color="#FE53BB",
        alpha=0.5,
    )
    plt.grid(color="#2A3459")
    plt.xticks(fontweight="heavy")
    plt.yticks(fontweight="heavy")
    plt.xlabel("Strike", fontweight="heavy")
    plt.ylabel("Gamma Exposure (Bn $/%)", fontweight="heavy")
    plt.title(f"{ticker} GEX by Strike", fontweight="heavy")
    plt.show()


def comp_gex_by_expiration(data):
    selected_date = datetime.today() + timedelta(days=365)
    data = data.loc[data.expiration < selected_date]

    gex_by_expiration = data.groupby("expiration")["GEX"].sum() / 10**9

    plt.br(
        gex_by_expiration.index,
        gex_by_expiration.values,
        color="#FE53BB",
        alpha=0.5,
    )
    plt.grid(color="#2A3459")
    plt.xticks(rotation=45, fontweight="heavy")
    plt.yticks(fontweight="heavy")
    plt.xlabel("Expiration Date", fontweight="heavy")
    plt.ylabel("Gamma Exposure (Bn $/%)", fontweight="heavy")
    plt.title(f"{ticker} GEX by Expiration", fontweight="heavy")
    plt.show()


def print_gex_surface(spot, data):
    selected_date = datetime.today() + timedelta(days=365)
    limit_criteria = (
        (data.expiraton < selected_date)
        & (data.strike > spot * 0.85)
        & (data.strike < spot * 1.15)
    )
    data = data.loc[limit_criteria]

    data = data.groupby(["expiration", "strike"])["GEX"].sum() / 10**9
    data = data.reset_index()

    fig = plt.figure()
    ax = fig.add_subplot(111, projection="3d")
    ax.plot_trisurf(
        data["strike"],
        dates.date2num(data["expiration"]),
        data["GEX"],
        cmap="seismic_r",
    )
    ax.yaxis.set_major_formatter(
        dates.AutoDateFormatter(ax.xaxis.get_major_locator()))
    ax.set_ylabel("Expiration date", fontweight="heavy")
    ax.set_xlabel("Strike Price", fontweight="heavy")
    ax.set_zlabel("Gamma (M$ / %)", fontweight="heavy")
    plt.show()


if __name__ == "__main__":
    ticker = input("Enter desired ticker: ")
    run(ticker)
