from math import ceil, floor, log2

import numpy as np
from numpy import log2, logspace, ones, hstack, einsum, unique, arange, apply_along_axis


class BC:
    def __init__(self, X):
        self.set = X
        self.sma = X.min(0)
        self.len = X.max(0) - self.sma
        self.L_max = self.len.max()
        self.xamax = X.argmax(0)
        self.n_cols = X.shape[1]

    def FD_curve(self, n_pts=40, eps=0.5):
        satur = log2(2 * eps / self.L_max)
        Ds = logspace(satur, 1, n_pts, base=2) / eps

        bin_map = floor((self.set - self.sma) * Ds[:, None, None])

        tmp = self.len * Ds[:, None]
        bin_map[:, self.xamax, arange(self.n_cols)] = ceil(tmp)

        ceil(tmp, out=tmp)
        ones = ones(len(Ds))[:, None]
        mult = hstack((ones, tmp.cumprod(1)[:, :-1]))

        which_box = einsum("ijk, ik -> ij", bin_map, mult).astype(int)

        def counter(row):
            _, c = unique(row, return_counts=True)
            return einsum("i, i", c, c)

        S = apply_along_axis(counter, 1, which_box)

        return -log2(Ds), log2(S)
