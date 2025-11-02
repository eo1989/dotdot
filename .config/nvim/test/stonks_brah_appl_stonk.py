import matplotlib.pyplot as plt
import yfinance as yf

stonk = "AAPL"
start_date = "2020-01-01"
end_date = "2025-01-01"

stonk_datars = yf.download()
