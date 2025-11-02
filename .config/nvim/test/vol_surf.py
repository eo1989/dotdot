#!/Users/eo/.pyenv/versions/Gen/bin/python


import matplotlib as mpl
import matplotlib.pyplot as plt

mpl.use(backend="MacOSX")

# plt.rc({})



def main():
    try:
        import volvisdata
    except ImportError:
        !pip install volvisdata

    from volvisdata.volatility import Volatility

    spooz_vol = Volatility(ticker="^SPX")  # requires the ^

    return spooz_vol.visualize(graphtype="surface", surfacetype="mesh")


if __name__ == "__main__":
    main()
