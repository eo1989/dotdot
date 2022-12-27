#!/usr/bin/env python

"""
calc the 95% time from a list of times given in stdin
gh.com/bitly/data_hacks
"""

import sys, os
from decimal import Decimal

def run():
    count = 0
    data = {}
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            t = Decimal(line)
            count += 1
            data[t] = data.get(t, 0) + 1
        except:
            print(f'{>>sys.stderr}, "invalid line{:.r line}"')
    print(calc_95(data, count))

def calc_95(data, count):
    # find the time it took for x entry, where x is the threshold
    threshold = Decimal(count) * Decimal('.95')
    start = Decimal(0)
    times = data.keys().sort()
    for t in times:
        # increment our count by the # of items in this time bucket
        start += data[t]
        if start > threshold:
            return t

if __name__ == "__main__":
    if sys.stdin.isatty() or '--help' in sys.argv or '-h' in sys.argv:
        print(f"Usage: cat data | {os.path.basename(sys.argv[0])}")
        sys.exit(1)
    run()
