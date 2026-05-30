# 📚 Project Documentation Index

## 📖 Documentation Files

All documentation is in `/home/school/Documents/4.2/01-Systeme d'information decisionnel/Projet_final/`

### 1. **QUICK_REFERENCE.md** ⭐ START HERE
- **Purpose**: Quick overview of the entire project
- **Best for**: Getting started quickly, finding key metrics
- **Contains**: Credentials, schemas, data counts, troubleshooting

### 2. **POWERBI_CONNECTION.txt** ⭐ FOR POWER BI USERS
- **Purpose**: Step-by-step Power BI connection guide
- **Best for**: Connecting Power BI to Snowflake
- **Contains**: Copy-paste credentials, connection steps, table lists by page

### 3. **POWERBI_CREDENTIALS.md**
- **Purpose**: Detailed Power BI connection documentation
- **Best for**: Understanding all available tables and fields
- **Contains**: Full schema descriptions, field definitions, troubleshooting

### 4. **DOCUMENTATION.md** ⭐ COMPREHENSIVE GUIDE
- **Purpose**: Complete technical documentation
- **Best for**: Understanding the full architecture and design
- **Contains**: Architecture, transformations, KPIs, maintenance, future enhancements

---

## 🔐 Snowflake Credentials (Copy-Paste)

```
Account:    YFQOTUU-OX87105
Server:     YFQOTUU-OX87105.snowflakecomputing.com
Username:   SECONDNAOUFALSCHOL
Password:   ASDFASDQWE@.xc344
Role:       ACCOUNTADMIN
Warehouse:  COMPUTE_WH
Database:   DW_ECOLE
```

---

## 📊 What Was Built

### Data Pipeline
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

### Database Structure
```
DW_ECOLE/
  ├── RAW/                              (27 tables)
  ├── STAGING_STAGING/                 (26 views)
  ├── STAGING_MART_INSCRIPTIONS/        (3 tables)
  ├── STAGING_MART_PERFORMANCE_ACADEMIQUE/  (3 tables)
  ├── STAGING_MART_DIPLOMATION_INSERTION/   (2 tables)
  ├── STAGING_MART_PROFESSEURS/             (7 tables)
  ├── STAGING_MART_ADMINISTRATION/          (5 tables)
  ├── STAGING_MART_CHARGE_TEMPORELLE/       (4 tables)
  ├── STAGING_MART_VIE_ETUDIANTE/           (9 tables)
  ├── STAGING_MART_FINANCE/                 (5 tables)
  ├── STAGING_MART_SATISFACTION/            (6 tables)
  └── STAGING_MART_EXECUTIVE/               (1 table)
```

---

## 🎯 Dashboard Pages

| Page | Schema | Purpose | Tables |
|------|--------|---------|--------|
| 0 | STAGING_MART_EXECUTIVE | Executive Summary | 1 |
| 1 | STAGING_MART_INSCRIPTIONS | Enrollment & Retention | 3 |
| 2 | STAGING_MART_PERFORMANCE_ACADEMIQUE | Academic Performance | 3 |
| 3 | STAGING_MART_DIPLOMATION_INSERTION | Graduation & Employment | 2 |
| 4 | STAGING_MART_PROFESSEURS | Professor Performance | 7 |
| 5 | STAGING_MART_ADMINISTRATION | Admin Services | 5 |
| 6 | STAGING_MART_CHARGE_TEMPORELLE | Student Workload | 4 |
| 7 | STAGING_MART_VIE_ETUDIANTE | Student Life & Wellbeing | 9 |
| 8 | STAGING_MART_FINANCE | Budget & Finances | 5 |
| 9 | STAGING_MART_SATISFACTION | Overall Satisfaction | 6 |

---

## 📁 Project Files

```
Projet_final/
├── 📄 DOCUMENTATION.md              ← Full technical docs
├── 📄 POWERBI_CREDENTIALS.md        ← Detailed connection guide
├── 📄 POWERBI_CONNECTION.txt        ← Quick connection steps
├── 📄 QUICK_REFERENCE.md            ← Quick overview
├── 📄 README.md                     ← This file
│
├── 🐍 upload_to_snowflake.py        ← Data loader script
│
├── 📁 dw_ecole/                     ← dbt project
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── packages.yml
│   ├── models/
│   │   ├── sources.yml              ← Declares 27 RAW tables
│   │   ├── staging/                 ← 26 cleaning views
│   │   └── mart_*/                  ← 10 marts with 45 tables
│   └── dbt_env/                     ← Python virtual environment
│
├── 📁 csv/                          ← 27 CSV files (exported from Excel)
│
├── 📁 dbt_files/                    ← Original dbt templates
│
├── 📊 Dataset_PowerBI_Ecole_CLEAN.xlsx  ← Source Excel file
├── 📊 KPI_Dashboard_PowerBI.pdf     ← Dashboard design
└── 📊 KPI_pages_Dashboard PowerBI.pdf   ← Page specifications
```

---

## 🚀 Quick Start

### For Power BI Users
1. Open **POWERBI_CONNECTION.txt**
2. Copy credentials
3. Open Power BI Desktop
4. Get Data → Snowflake
5. Paste credentials
6. Select schema for your page
7. Load tables
8. Build dashboard

### For Data Engineers
1. Read **DOCUMENTATION.md** for full architecture
2. Review dbt project in `dw_ecole/`
3. To refresh data:
   ```bash
   source dbt_env/bin/activate
   cd dw_ecole
   dbt run --profiles-dir .
   ```

### For Analysts
1. Check **QUICK_REFERENCE.md** for key metrics
2. Use **POWERBI_CREDENTIALS.md** to understand available fields
3. Connect to appropriate MART schema
4. Build visualizations

---

## 📊 Key Statistics

| Metric | Value |
|--------|-------|
| **Source Tables** | 27 |
| **Source Rows** | ~21,000 |
| **Staging Views** | 26 |
| **Mart Schemas** | 10 |
| **Mart Tables** | 45 |
| **Total Objects** | 98 |
| **Dashboard Pages** | 10 |

---

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

---

## 🔄 Data Refresh

To refresh data after updating Excel:

```bash
# 1. Export Excel sheets to CSV
# 2. Run data loader
python3 upload_to_snowflake.py

# 3. Run dbt transformations
source dbt_env/bin/activate
cd dw_ecole
dbt run --profiles-dir .

# 4. Refresh Power BI dataset
```

---

## 📞 Support & Troubleshooting

### Connection Issues
- See **POWERBI_CONNECTION.txt** → Troubleshooting section
- Verify credentials are exact (case-sensitive)
- Check warehouse `COMPUTE_WH` is running

### Data Issues
- Run verification queries above
- Check dbt logs: `target/logs/dbt.log`
- Review Snowflake query history

### Performance Issues
- Increase warehouse size temporarily
- Add date filters in Power BI
- Use aggregated tables (facts) instead of dimensions

---

## 📚 Additional Resources

- **dbt Documentation**: https://docs.getdbt.com
- **Snowflake Documentation**: https://docs.snowflake.com
- **Power BI Documentation**: https://docs.microsoft.com/power-bi

---

## 👥 Team Roles

| Role | Responsibility | Key Files |
|------|-----------------|-----------|
| **Power BI Developer** | Build dashboards | POWERBI_CONNECTION.txt |
| **Data Engineer** | Maintain pipeline | DOCUMENTATION.md |
| **Analyst** | Interpret metrics | QUICK_REFERENCE.md |
| **Admin** | Manage credentials | POWERBI_CREDENTIALS.md |

---

## 📝 Version History

| Version | Date | Status | Notes |
|---------|------|--------|-------|
| 1.0 | May 30, 2024 | Production Ready | Initial release |

---

## 🎉 You're All Set!

Everything is ready to use. Start with **QUICK_REFERENCE.md** or **POWERBI_CONNECTION.txt** depending on your role.

**Questions?** Check the relevant documentation file above.

---

**Last Updated**: May 30, 2024  
**Status**: ✅ Production Ready  
**Support**: See documentation files
