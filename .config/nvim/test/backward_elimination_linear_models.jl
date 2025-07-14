# using StatsModels, RDatasets, DataFrames, GLM, Random
using

Random.seed!(0)

n = 30

df = dataset("MASS", "cpus")[1:n, :]

df.Freq = map(x -> 10^9 / x, df.CycT)

df = df[:, [:Perf, :MMax, :Cach, :ChMax, :Freq]]

df.Junk1 = rand(n)
df.Junk2 = rand(n)

function stepReg(df, reVar, pThresh)
    predVars = setdiff(propertynames(df), [revar])
    numVars = length(predVars)
    return model = nothing
end
