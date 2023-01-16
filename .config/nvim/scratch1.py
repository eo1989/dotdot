# from typing import Tuple
#
#
# def heya(names: Tuple[str]):
#     for name in names:
#         print(f"Hi {names}!")
# %%

# %%
import numpy as np
import matplotlib.pyplot as plt

x = np.random.rand(10_000)
plt.hist(x)
