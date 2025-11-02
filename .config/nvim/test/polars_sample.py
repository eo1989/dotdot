# %%
from datetime import datetime, timedelta

import numpy as np
import polars as pl

# %%

# rng = np.random.default_rng(42)
np.random.seed(42)


def generate_coffee_data() -> dict["str", list | np.ndarray]:
    n_records = 2_000

    # coffee menu items w/ realistic prices
    menu_items = [
        "Espresso",
        "Cappucino",
        "Latte",
        "Americano",
        "Mocha",
        "Cold Brew",
    ]
    prices = [2.5, 4.0, 4.5, 3.0, 5.0, 3.5]
    price_map = dict(zip(menu_items, prices))

    # gen dates over 6 months
    start_date = datetime(2025, 9, 22)
    dates = [
        start_date + timedelta(days=np.random.randint(0, 180))
        for _ in range(n_records)
    ]

    # randomly select the drinks, then map the correct price for ea selected drink
    drinks = np.random.choice(menu_items, n_records)
    prices_chosen = [price_map[d] for d in drinks]

    data = {
        "date": dates,
        "drink": drinks,
        "price": prices_chosen,
        "quantity": np.random.choice([1, 1, 2, 2, 3], n_records),
        "customer_type": np.random.choice(
            ["Regular", "New", "Tourist"], n_records, p=[0.5, 0.3, 0.2]
        ),
        "payment_method": np.random.choice(
            ["Card", "Cash", "Mobile"], n_records, p=[0.6, 0.2, 0.2]
        ),
        "rating": np.random.choice(
            [2, 3, 4, 5], n_records, p=[0.1, 0.4, 0.4, 0.1]
        ),
    }
    return data


# creating coffee shop dataframe
coffee_data = generate_coffee_data()

df = pl.DataFrame(coffee_data)

# take a look at the data
print(f"First 5 transactions:\n {df.head()}")

print(f"\nWhat types of data?\n{df.schema}")

# & sign cant be escaped once w/o error, and twice \\ will print the escapes, adding the ampersand as unicode U+ff06 will print correctly
print(
    f"\nHow big is the dataset?\nThe dataset contains {df.height} transactions ＆ {df.width} columns"
)
# prints 2_000 transactions & 7 columns (corresponding w/ n_records & 7 dictionary keys in data)

## Adding new columns

# calc total sales amount and add useful date information
df_enhanced = df.with_columns(
    [
        # calc revenue per transaction
        (pl.col("price") * pl.col("quantity")).alias("total_sale"),
        # Extract useful date components
        pl.col("date").dt.weekday().alias("day_of_week"),
        pl.col("date").dt.month().alias("month"),
        pl.col("date").dt.hour().alias("hour_of_day"),
    ]
)

print(f"Sample of enhanced data:\n{df_enhanced.head()}")

## Grouping Data

# Q1. Which drinks are the best sellers?
# %% [markdown]
"""
This code groups all transactions by drink type, then calculates totals and averages for each group.
Its like sorting all your receipts into piles by drink type, then calculating the totals of each pile.
"""

drink_performance = (
    df_enhanced.group_by("drink")
    .agg(
        [
            pl.col("total_sale").sum().alias("total_revenue"),
            pl.col("quantity").sum().alias("total_sold"),
            pl.col("rating").mean().alias("avg_rating"),
        ]
    )
    .sort("total_revenue", descending=True)
)
print(f"Drink performance ranking:\n{drink_performance}")

# Q2. What do the daily sales look like?
# Finding the number of transactions and the corresponding revenue for each day of the week
daily_patterns = (
    df_enhanced.group_by("day_of_week")
    .agg(
        [
            pl.col("total_sale").sum().alias("daily_revenue"),
            pl.len().alias("number_of_transactions"),
        ]
    )
    .sort("day_of_week")
)

print(f"Daily business patters:\n{daily_patterns}")

# Filtering the data for high value transactions (>$10)
big_orders = df_enhanced.filter(pl.col("total_sale") > 10.0).sort(
    "total_sale", descending=True
)

print(
    f"We have {big_orders.height} over $10\nTop 5 biggest orders:\t{big_orders.head()}"
)
# 274 orders over $10, 5 biggest orders all mocha?


# Analyzing customer behavior by type
customer_analysis = (
    df_enhanced.group_by("customer_type")
    .agg(
        [
            pl.col("total_sale").mean().alias("avg_spending"),
            pl.col("total_sale").sum().alias("total_revenue"),
            pl.len().alias("visit_count"),
            pl.col("rating").mean().alias("avg_satisfaction"),
        ]
    )
    .with_columns(
        (pl.col("total_revenue") / pl.col("visit_count")).alias(
            "revenue_per_visit"
        )
    )
)

print(f"Customer behavior analysis:\n{customer_analysis}")
# 3,6

### Lets put it all together \dab
# comprehensive business summary
business_summary = {
    "total_revenue": df_enhanced["total_sale"].sum(),
    "total_transactions": df_enhanced.height,
    "average_transaction": df_enhanced["total_sale"].mean(),
    "best_selling_drink": drink_performance.row(0)[0],  # first row, first col
    "customer_satisfaction": df_enhanced["rating"].mean(),
}

print("\n=== BEAN THERE COFFEE SHOP - SUMMARY ===")
for key, value in business_summary.items():
    if isinstance(value, float) and key != "customer_satisfaction":
        print(f"{key.replace('_', ' ').title()}: ${value:.2f}")
    else:
        print(f"{key.replace('_', ' ').title()}: {value}")
