# %%
# import libraries
import sqlalchemy as sa
import pandas as pd

# %%
# Load the dataset

df = pd.read_csv("data_raw\\customer_shopping_behavior.csv")

# %%
# print dataset

df.head()

# %%
# describe the dataset

df.describe()

# %%
# dataset info

df.info()

# %%
# check for null values

df.isnull().sum()

# %%
# cells with null values

null_cells = df[df.isnull().any(axis=1)]
null_cells.head(10)

# %%
# fill null rows by category

df["Review Rating"] = df.groupby("Category")["Review Rating"].transform(lambda x: x.fillna(x.mean()))

# %% 
# formating columns names

df.columns = df.columns.str.lower().str.replace(" ", "_")
df = df.rename(columns={"purchase_amount_(usd)": "purchase_amount_usd"})

# %% 
# print columns names

print(df.columns)

# %%
# label age groups into categories

labels = ["Young Adult", "Adult", "Middle-aged", "Senior"]
df["age_group"] = pd.cut(df["age"], bins=[17, 29, 44, 60, 200], labels=labels)

# %%

# print age and it's groups
df[["age", "age_group"]].head(30)
# %%
# create column purchase_frequency_days

frequency_mapping ={
    "Weekly": 7,
    "Bi-Weekly": 14,
    "Fortnightly": 14,
    "Monthly": 30,
    "Every 3 Months": 90,
    "Quarterly": 90,
    "Annually": 365
}

df["purchase_frequency_days"] = df["frequency_of_purchases"].map(frequency_mapping)
# %%
# print purchase frequency in days + frequency of purchases

df[["purchase_frequency_days", "frequency_of_purchases"]].head(30)

# %%
# check if discount applied values is equal to promo code used values
(df["discount_applied"] == df["promo_code_used"]).all()

# %%
# drop promo_code_used column (is redudant)

df = df.drop(columns=["promo_code_used"])

# %%
# check columns names
df.columns

# %%
# save the cleaned dataset to a new csv file
df.to_csv("data_clean\\customer_shopping_behavior_cleaned.csv", index=False)
# %%
