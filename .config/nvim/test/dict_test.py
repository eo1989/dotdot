# def print_number(x):
#     print(f"NUMBER IS {x}")


# rename_print = print_number
# rename_print(100)
# print_number(100)


color = "Red"


def run():
    print("VROOM")


corvette = {
    "color": "Red",
    "run": run,
}

# print("LITTLE", corvette["color"], "CORVETTE")

print("My", corvette["color"], "can go")


corvette["run"]()


becky = {"name": "Becky", "age": 34, "eyes": "green"}

# def talk(who, words):
#     print(f"I am {who['name']} and {words}")


# talk(becky, "I am talking here!")

# %%
# from dask import datasets
# import dask.dataframe as dd

# df = dd.read_csv("../../../Downloads/covid19_tweets.csv")

# sentiment_counts = df.groupby()

def fname():
    pass
