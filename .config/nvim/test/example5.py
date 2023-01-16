# %%
import numpy as np


def compute_sum_of_powers():
    numbers = np.arange(1_000_000)
    powers = np.power(numbers, 2)
    return np.sum(powers)


total = compute_sum_of_powers()
print(total)
# %%
