# 📊 School Data Warehouse & Power BI Dashboard

A complete ETL pipeline transforming school operational data from Excel into a Snowflake data warehouse with Power BI dashboards.

## 🎯 Project Overview

This project implements a modern data stack for a school's decision support system:
- **Source**: 27 Excel sheets (~21,000 rows of school data)
- **Pipeline**: Python ETL → Snowflake RAW → dbt Staging/Marts
- **Analytics**: 10 Power BI dashboard pages covering key metrics
- **Architecture**: Star schema with 10 separate data marts

## 📁 Project Structure

```
├── docs/                          # Documentation
│   ├── README.md                 # Project overview
│   ├── QUICK_REFERENCE.md        # Quick start guide
│   ├── DOCUMENTATION.md          # Full technical docs
│   ├── POWERBI_CONNECTION.txt    # Power BI setup steps
│   └── POWERBI_CREDENTIALS.md    # Connection details
│
├── dw_ecole/                     # dbt project
│   ├── models/
│   │   ├── sources.yml           # RAW table declarations
│   │   ├── staging/              # 26 cleaning views
│   │   └── mart_*/               # 10 marts (45 tables)
│   ├── dbt_project.yml
│   ├── profiles.yml
│   └── packages.yml
│
├── scripts/
│   └── upload_to_snowflake.py    # Data loader script
│
├── data/
│   └── csv/                      # 27 CSV files (exported from Excel)
│
└── dbt_files/                    # Original dbt templates
```

## 🚀 Quick Start

### For Power BI Users
1. Read `docs/POWERBI_CONNECTION.txt`
2. Copy credentials from `docs/QUICK_REFERENCE.md`
3. Connect Power BI to Snowflake
4. Select schema for your dashboard page

### For Data Engineers
1. Review `docs/DOCUMENTATION.md` for architecture
2. Set up dbt environment:
   ```bash
   cd dw_ecole
   python -m venv dbt_env
   source dbt_env/bin/activate
   pip install -r requirements.txt
   ```
3. Configure `profiles.yml` with Snowflake credentials
4. Run transformations:
   ```bash
   dbt run --profiles-dir .
   ```

## 📊 Data Architecture

### Data Flow
```
Excel (27 sheets)
  ↓
CSV Files (27 files)
  ↓
Snowflake RAW (27 tables, ~21K rows)
  ↓
dbt Staging (26 cleaned views)
  ↓
dbt Marts (10 marts, 45 tables)
  ↓
Power BI Dashboards (10 pages)
```

### Snowflake Schemas
- **RAW**: 27 source tables
- **STAGING_STAGING**: 26 cleaning views
- **STAGING_MART_INSCRIPTIONS**: Enrollment & Retention (3 tables)
- **STAGING_MART_PERFORMANCE_ACADEMIQUE**: Academic Performance (3 tables)
- **STAGING_MART_DIPLOMATION_INSERTION**: Graduation & Employment (2 tables)
- **STAGING_MART_PROFESSEURS**: Professor Performance (7 tables)
- **STAGING_MART_ADMINISTRATION**: Admin Services (5 tables)
- **STAGING_MART_CHARGE_TEMPORELLE**: Student Workload (4 tables)
- **STAGING_MART_VIE_ETUDIANTE**: Student Life & Wellbeing (9 tables)
- **STAGING_MART_FINANCE**: Budget & Finances (5 tables)
- **STAGING_MART_SATISFACTION**: Overall Satisfaction (6 tables)
- **STAGING_MART_EXECUTIVE**: Executive Summary (1 table)

## 📈 Dashboard Pages

| Page | Focus | Schema |
|------|-------|--------|
| 0 | Executive Summary | STAGING_MART_EXECUTIVE |
| 1 | Enrollment & Retention | STAGING_MART_INSCRIPTIONS |
| 2 | Academic Performance | STAGING_MART_PERFORMANCE_ACADEMIQUE |
| 3 | Graduation & Employment | STAGING_MART_DIPLOMATION_INSERTION |
| 4 | Professor Performance | STAGING_MART_PROFESSEURS |
| 5 | Admin Services | STAGING_MART_ADMINISTRATION |
| 6 | Student Workload | STAGING_MART_CHARGE_TEMPORELLE |
| 7 | Student Life & Wellbeing | STAGING_MART_VIE_ETUDIANTE |
| 8 | Budget & Finances | STAGING_MART_FINANCE |
| 9 | Overall Satisfaction | STAGING_MART_SATISFACTION |

## 🔧 Technology Stack

- **Data Warehouse**: Snowflake
- **Transformation**: dbt (data build tool)
- **Data Loading**: Python (pandas, snowflake-connector-python)
- **Analytics**: Power BI
- **Version Control**: Git

## 📊 Key Statistics

| Metric | Value |
|--------|-------|
| Source Tables | 27 |
| Source Rows | ~21,000 |
| Staging Views | 26 |
| Mart Schemas | 10 |
| Mart Tables | 45 |
| Total Objects | 98 |
| Dashboard Pages | 10 |

## 📚 Documentation

- **[QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)** - Quick overview with credentials and key metrics
- **[DOCUMENTATION.md](docs/DOCUMENTATION.md)** - Complete technical documentation
- **[POWERBI_CONNECTION.txt](docs/POWERBI_CONNECTION.txt)** - Step-by-step Power BI setup
- **[POWERBI_CREDENTIALS.md](docs/POWERBI_CREDENTIALS.md)** - Detailed connection guide

## ✅ Verification

All data is loaded and ready. Verify with these queries in Snowflake:

```sql
-- Check RAW data
SELECT COUNT(*) FROM DW_ECOLE.RAW.ETUDIANT;  -- 1,200

-- Check STAGING
SELECT COUNT(*) FROM DW_ECOLE.STAGING_STAGING.stg_etudiant;  -- 1,200

-- Check MARTS
SELECT COUNT(*) FROM DW_ECOLE.STAGING_MART_INSCRIPTIONS.fact_inscription;  -- 3,013
SELECT COUNT(*) FROM DW_ECOLE.STAGING_MART_PERFORMANCE_ACADEMIQUE.fact_note;  -- 3,000
SELECT COUNT(*) FROM DW_ECOLE.STAGING_MART_SATISFACTION.fact_satisfaction;  -- 800
```

## 🔄 Data Refresh

To refresh data after updating Excel:

```bash
# 1. Export Excel sheets to CSV
# 2. Run data loader
python3 scripts/upload_to_snowflake.py

# 3. Run dbt transformations
cd dw_ecole
source dbt_env/bin/activate
dbt run --profiles-dir .

# 4. Refresh Power BI dataset
```

## 📝 License

This project is part of a school decision support system.

## 👥 Contributors

School Data Team

---

**Status**: ✅ Production Ready  
**Last Updated**: May 30, 2024
