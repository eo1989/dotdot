import argparse
import sys
from datetime import datetime

import requests as req
import yfinance as yf
# from IPython.display import Markdown, display

from rich.console import Console
from rich.markdown import Markdown
from rich.prompt import Prompt

console = Console()


def parse_args():

    md = Markdown

    help_text = md(
        """
    Arguments:
        -s, --stock: Stock Symbol
                (e.g. AAPL, MSFT, TSLA)
        -d, --days: Days to expiration
                (e.g. 7, 14, 30, 45, 60, 90, 120)

    Usage:
        To get an expected percentage, w/ standard deviation, and price for the stock for a certain period
        (e.g. TSLA in 7 days):
            python expected_move.py -s TSLA -d 7
                Last close price: 350.00
                TSLA IV: 55.8%
                TSLA Expected Move: ±$12.5030234
                High: $362.5030234, Low: $337.4969766

        """
    )

    # help_text = display(
    #     Markdown("""
    # Arguments:
    #     -s, --stock: Stock Symbol
    #             (e.g. AAPL, MSFT, TSLA)
    #     -d, --days: Days to expiration
    #             (e.g. 7, 14, 30, 45, 60, 90, 120)
    #
    # Usage:
    #     To get an expected percentage, w/ standard deviation, and price for the stock for a certain period
    #     (e.g. TSLA in 7 days):
    #         python expected_move.py -s TSLA -d 7
    #             Last close price: 350.00
    #             TSLA IV: 55.8%
    #             TSLA Expected Move: ±$12.5030234
    #             High: $362.5030234, Low: $337.4969766
    #
    #
    # """)
    # )

    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--stock", help="Stock Symbol")
    parser.add_argument(
        "-d", "--days", help="How many days away is the exiry from today?"
    )
    args = parser.parse_args()

    if not args.stock and not args.days:
        print(help_text)
        sys.exit(1)

    return args.stock, args.days


def get_expected_move(stock_name: str, days: str = "1d"):
    stock = yf.Ticker(stock_name)

    history = stock.history(period=days)
    pre_close = float(history.Close[0])
    print(f"Last close price: {pre_close}:.2d")

    response_content = req.get(
        f"https://marketchameleon.com/Overview/{stock_name}/IV/"
    ).content

    return response_content
