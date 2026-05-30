import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
import pandas as pd
import os

ACCOUNT   = "YFQOTUU-OX87105"
USER      = "SECONDNAOUFALSCHOL"
PASSWORD  = "ASDFASDQWE@.xc344"
ROLE      = "ACCOUNTADMIN"
WAREHOUSE = "COMPUTE_WH"
DATABASE  = "DW_ECOLE"
SCHEMA    = "RAW"

CSV_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "csv")

conn = snowflake.connector.connect(
    account=ACCOUNT, user=USER, password=PASSWORD,
    role=ROLE, warehouse=WAREHOUSE, database=DATABASE, schema=SCHEMA
)
cur = conn.cursor()
cur.execute(f"CREATE DATABASE IF NOT EXISTS {DATABASE}")
cur.execute(f"CREATE SCHEMA IF NOT EXISTS {DATABASE}.{SCHEMA}")
cur.execute(f"USE DATABASE {DATABASE}")
cur.execute(f"USE SCHEMA {SCHEMA}")

for fname in sorted(os.listdir(CSV_DIR)):
    if not fname.endswith(".csv"):
        continue
    table = fname.replace(".csv", "")
    df = pd.read_csv(os.path.join(CSV_DIR, fname))
    df.columns = [c.upper() for c in df.columns]

    cur.execute(f"DROP TABLE IF EXISTS {table}")
    success, nchunks, nrows, _ = write_pandas(conn, df, table, auto_create_table=True, overwrite=True)
    print(f"{'✓' if success else '✗'} {table} ({nrows} rows)")

cur.close()
conn.close()
print("\nAll tables loaded into DW_ECOLE.RAW")
