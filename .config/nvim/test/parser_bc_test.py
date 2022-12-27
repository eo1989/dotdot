import numpy as np
from math import exp
import matplotlib.pyplot as plt


def parser1(x):
    if x:
        if x[-1] == '-':
            return x[:-1]
        return x + ' '
    else:
        return ''


def parser2(x):
    x = x[:-1]
    if '- ' in x:
        return x.replace("- ", '')
    elif '-' in x:
        if '10 - 15' in x:
            return x
    return x

def msigma(x, a, b, c, d):
    return a/(1 + np.exp(b*x + c)) + d

def dm_sigma(x, a, b, c, d):
    return -a*b*exp(b*x + c) / (1 + exp(b*x + c))**2

def my_fun(x, t, y):
    return x[0]/(1 + np.exp(x[1] * t + x[2])) + x[3] - y

def jac_fun(x, t, y):
    return np.array(
        [1. / (1 + np.exp(x[1] * t + x[2])),
         -x[0] * np.exp(x[1] * t + x[2]) * t / (1 + np.exp(x[1] * t + x[2]))**2,
         -x[0] * np.exp(x[1] * t + x[2]) / (1 + np.exp(x[1] * t + x[2]))**2,
         ]
    )
