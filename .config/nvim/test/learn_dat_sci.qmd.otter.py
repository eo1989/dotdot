














import pandas as pd
import numpy as np
from scipy.stats import multivariate_normal, multivariate_hypergeom

proportions = np.array([0.4818, 0.4746, 1 - (0.4818 + 0.4746)])
n = 1_500
N = 6_165_478
votes = np.trunc(N * proportions).astype(int)
votes

# array([2970527, 2926135,  268814])

multivariate_hypergeom.rvs(votes, n)
# array([715, 710, 75])





multivariate_hypergeom.rvs(votes, n=n)
# array([725, 712, 63])
