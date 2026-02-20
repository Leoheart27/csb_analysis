# %%
import pandas as pd
import sqlalchemy as sa

# %%
# Load the cleaned dataset
df = pd.read_csv("data_clean\\customer_shopping_behavior_cleaned.csv")

# %%
# print dataset
df.head()

# %%
# PostgreSQL conection
engine = sa.create_engine("postgresql://postgres:postpass27@localhost:5432/project_csb")

# %%

table_name = "customer_shopping_behavior"
df.to_sql(table_name, engine, if_exists="replace", index=False)
print(f" DataFrame has been successfully written to the PostgreSQL {table_name} table.")
# %%
