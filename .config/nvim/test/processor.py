import math as mt
import time
import warnings
from functools import wraps

# import glob
from pathlib import Path

import pandas as pd
from memory_profiler import memory_usage
from rich import print


def convert_size(size_bytes):
    if size_bytes == 0:
        return "0B"

    size_name = {"B", "KB", "GB", "TB", "PB", "EB", "ZB", "YB"}
    i = int(mt.floor(mt.log(size_bytes, 1024)))
    p = mt.pow(1024, i)
    s = round(size_bytes / p, 2)
    return "%s %s" % (s, size_name[i])
    # return f"{s, size_name[i]}"


# decorator to measure execution time and memory usage
def measure_performance(func, return_output=False) -> None:
    @wraps(func)
    def wrapper(return_output=False, *args, **kwargs):
        warnings.filterwarnings("ignore")
        start_time = time.time()
        mem_usage = memory_usage((func, args, kwargs), interval=0.1)
        end_time = time.time()
        warnings.filterwarnings("always")

        exec_time = end_time - start_time
        peak_mem = max(mem_usage)
        exec_time_formatted = f"\033[92m{exec_time:.4f} sec\033[0m"
        peak_mem_formatted = f"\033[92m{convert_size(1024 * peak_mem)}\033[0m"

        print(
            f"{func.__name__} - Execution Time: {exec_time_formatted} | Peak Memory Usage: {peak_mem_formatted}"
        )
        if return_output is True:
            return func(*args, **kwargs)

    return wrapper


# Apply the decorator to functions
@measure_performance
def process_csv(*args, **kwargs):
    df = pd.read_csv("data/RPindividus_24.csv")
    return (
        df.loc[df["DEPT"] == 36]
        .groupby(["AGED", "DEPT"])["IPONDI"]
        .sum()
        .reset_index()
        .rename(columns={"IPONDI": "n_indiv"})
    )


@measure_performance
def process_parquet(*args, **kwargs):
    df = pd.read_parquet("data/RPindividus_24.parquet")
    return (
        df.loc[df["DEPT"] == 36]
        .groupby(["AGED", "DEPT"])["IPONDI"]
        .sum()
        .reset_index()
        .rename(columns={"IPONDI": "n_indiv"})
    )


process_csv()
process_parquet()
