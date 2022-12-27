# %%
# prediction function:
def predict(rows, coeff):
    for i in range(len(row) - 1):
        y += coeff[i + 1] * row[i]
    return 1.0/(1.0 + exp(-y))
# %%
