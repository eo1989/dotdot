import pandas as pd

df = pd.DataFrame(
    {
        "Name": ["Alice", "Leah", "Jessica", "Kenny", "Brad"],
        "Age": [50, 27, 22, 30, 40],
        "Salary": [100_000, 154_000, 120_000, 78_000, 88_000],
        "Occupation": ["Doctor", "Soldier", "Doctor", "Accountant", "Florist"],
    }
)

df[df["Age"] > 30]

# & operator (binary and)
df[(df["Age"] > 25) & (df["Salary"] < 100_000)]

# | operator (binary or)
df[(df["Salary"] < 100_000) | (df["Occupation"] == "Soldier")]

# filter data w/ the str func for cols of certain values
df[df["Occupation"].str.contains("Sol")]
