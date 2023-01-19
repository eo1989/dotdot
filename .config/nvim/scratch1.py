# from typing import Tuple
#
#
# def heya(names: Tuple[str]):
#     for name in names:
#         print(f"Hi {names}!")
# %%

# %%
import numpy as np

np.set_printoptions(precision=3)
import matplotlib.pyplot as plt

x = np.random.rand(10_000)
print(x)  # prints [0.840783 0.2334 ..]
plt.hist(x)
