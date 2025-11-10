#!uv run python

import os
import subprocess
import sys
from datetime import date, datetime

import matplotlib as mpl
from rich import print

# import matplotlib.pyplot as plt

mpl.use(backend="macosx")


def if_missing_install(package) -> None:
    if "volvisualizer" in sys.modules != True:
        print(f"'{package}' not found in sys.modules")
        try:
            # subprocess.check_call([sys.executable, "-m", "pip", "install", package])
            os.system(f"pip install {package}")
            print(f"Package {package_name} installed.")
        except subprocess.CalledProcessError as e:
            print(f"Error installing package '{package}': {e}")
            print(
                "Please ensure pip is installed and accessible in your environment."
            )
    else:
        print(f"Package '{package}' is already loaded in sys.modules")


# HAS_VOLVIS = "volvisualizer" in sys.modules
# if HAS_VOLVIS:
#     !pip install volvisualizer


def main():

    try:
        from volvisualizer.volatility import Volatility
    except ImportError as e:
        print(f"Couldnt load volvisualizer: {e}")

    spooz = Volatility(
        ticker="^SPX", start_date="2025-06-01", wait=1, monthlies=True, q=0.013
    )

    return spooz.visualize(graphtype="surface", surfacetype="mesh")


if __name__ == "__main__":
    main()
