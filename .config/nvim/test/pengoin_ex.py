import pingouin as pg
import seaborn as sns

df = pg.read_dataset("pairwise_corr")
# print(df.shape)
# print(df.head(10))
# print(df.info())

pg.multivariate_normality(df[["Neuroticism", "Openness"]])

sns.jointplot(data=df, x="Neuroticism", y="Openness", kind="reg")

pg.corr(df["Neuroticism"], df["Openness"], method="pearson")
