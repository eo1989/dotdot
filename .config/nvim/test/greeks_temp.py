# %%
import matplotlib.pylab as plt
import numpy as np
from scipy.stats import norm

# %%
s = np.linspace(1.5, 4.0, 200)
k = 2.5
r = 0.0


iv_front = 11.00  # 1100%
iv_back = 2.8
T_front = 1 / 365
T_back = 28 / 365


# %%
def call_price(S, K, T, r, sigma):
    if T == 0:
        return np.maximum(S - K, 0)
    d1 = (np.log(S / K) + (r + 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))
    d2 = d1 - sigma * np.sqrt(T)
    return S * norm.cdf(d1) - K * np.exp(-r * T) * norm.cdf(d2)


def call_delta(S, K, T, r, sigma):
    if T == 0:
        return (S > K).astype(float)
    d1 = (np.log(S / K) + (r + 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))
    return norm.cdf(d1)


def call_gamma(S, K, T, r, sigma):
    if T == 0:
        return 0.0
    d1 = (np.log(S / K) + (r + 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))
    return norm.pdf(d1) / (S * sigma * np.sqrt(T))


def call_vega(S, K, T, r, sigma):
    if T == 0:
        return 0.0
    d1 = (np.log(S / K) + (r + 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))
    return S * norm.pdf(d1) * np.sqrt(T)


# At initiation, net position
price_front = call_price(S, K, T_front, r, iv_front)
price_back = call_price(S, K, T_back, r, iv_back)
spread_price = -price_front + price_back

delta_front = call_delta(S, K, T_front, r, iv_front)
delta_back = call_delta(S, K, T_back, r, iv_back)
spread_delta = -delta_front + delta_back

gamma_front = call_gamma(S, K, T_front, r, iv_front)
gamma_back = call_gamma(S, K, T_back, r, iv_back)
spread_gamma = -gamma_front + gamma_back

vega_front = call_vega(S, K, T_front, r, iv_front)
vega_back = call_vega(S, K, T_back, r, iv_back)
spread_vega = -vega_front + vega_back

# OnL after 1 day (front expired, back 27d to expiry)
price_back_day1 = call_price(S, K, (T_back - T_front), r, iv_back)
pnl = price_back_day1 - (price_back - price_front)

# Plotting
fig, axes = plt.subplots(2, 2, figsize=(14, 10))
axes[0, 0].plot(S, spread_delta)
axes[0, 0].set_title("Delta of Calendar Spread at Initiation")
axes[0, 0].set_xlabel("Stock Price")
axes[0, 0].set_ylabel("Delta")

axes[0, 1].plot(S, spread_gamma)
axes[0, 1].set_title("Gamma of Calendar Spread at Initiation")
axes[0, 1].set_xlabel("Stock Price")
axes[0, 1].set_ylabel("Gamma")

axes[1, 0].plot(S, spread_vega)
axes[1, 0].set_title("Vega of Calendar Spread at Initiation")
axes[1, 0].set_xlabel("Stock Price")
axes[1, 0].set_ylabel("Vega")

axes[1, 1].plot(S, pnl)
axes[1, 1].set_title("OnL After Front Leg Expiry")
axes[1, 1].set_xlabel("Stock Price at Expiry")
axes[1, 1].set_ylabel("OnL")

plt.tight_layout()
# plt.show()

# %%


def d1(S, K, T, r, sigma):
    return (np.log(S / K) + (r + 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))


def vanna(S, K, T, r, sigma):
    if T == 0:
        return 0.0
    d1_ = d1(S, K, T, r, sigma)
    return -norm.pdf(d1_) * d1_ * np.sqrt(T) / sigma


vanna_front = vanna(S, K, T_front, r, iv_front)
vanna_back = vanna(S, K, T_back, r, iv_back)
net_vanna = -vanna_front + vanna_back

plt.figure(figsize=(8, 5))
plt.plot(S, net_vanna, label="Net Vanna (Calendar)")
plt.axvline(K, color="gray", linestyle="--", label="Strike ($2.5)")
plt.title("Vanna (dDelta/dIV) of Calendar Spread at Initiation")
plt.xlabel("Underlying Price")
plt.ylabel("Net Vanna")
plt.legend()
plt.grid(True)
plt.show()
