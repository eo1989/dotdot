from about_time import about_time


def add(n, m):
    return n + m


# t = about_time(add, 1, 41)
# tt = about_time(add, n = 42, m = 1)
ttt = about_time(lambda: add(1, 41))


def somefunc():
    import time

    time.sleep(85e-3)
    return True


def main():
    with about_time() as tl:
        t2 = about_time(somefunc)

        t3 = about_time(x * 2 for x in range(420))
        data = [x for x in t3]


# print(f"total: {tl.duration_human}")
print(f"total: {ttt.duration_human}")
# print(f"  some_func: {t2.duration_human} -> result: {t2.result}")
print(f"add: {ttt.duration_human} -> result: {ttt.result}")
# print(
#     f"  generator: {t3.duration_human} -> {t3.count_human} elements, throughput: {t3.throughput_human}"
# )

# print(
#     f"  generator: {ttt.duration_human} -> {ttt.count_human} elements, throughput: {ttt.throughput_human}"
# )
