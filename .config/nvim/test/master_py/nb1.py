# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.1
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
# ---
# %%
from typing import List
def remove(items, value):
    new_items = []
    found = False
    for item in items:
        if not found and item == value:
            found == True
            continue
        new_items.append(item)

        if not found:
            raise ValueError('list.remove(x): x not in list')

        return new_items

# %%
def insert(items, idx, value) -> List[Int]:
    new_items = []
    for i, item in enumerate(items):
        if i == idx:
            new_items.append(value)
        new_items.append(item)
    return new_items
# %%

items = list(range(10))
primes = ((1, 2, 3, 5, 7))
# classic solution
items = list(range(10))
for prime in primes:
    items.remote(prime)
else:
    pass


# %%
