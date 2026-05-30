# Quick Reference Card

## 🎯 Project Summary

**Goal**: Build a 10-page analytical dashboard for school performance  
**Status**: ✅ Complete & Production Ready  
**Data**: 27 Excel sheets → 98 Snowflake tables → Power BI dashboards

---

## 📊 What Was Built

| Layer | Count | Purpose |
|-------|-------|---------|
| **RAW** | 27 tables | Source data from Excel |
| **STAGING** | 26 views | Cleaned & typed data |
| **MARTS** | 45 tables | Business-ready analytics |
| **Total** | 98 objects | Full DWH |

---

## 🔐 Snowflake Credentials (Copy-Paste Ready)

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

## 📱 Power BI Connection

1. **Get Data** → **Snowflake**
2. Enter server: `YFQOTUU-OX87105.snowflakecomputing.com`
3. Enter warehouse: `COMPUTE_WH`
4. Enter database: `DW_ECOLE`
5. Enter schema: `STAGING_MART_*` (choose based on page)
6. Username: `SECONDNAOUFALSCHOL`
7. Password: `ASDFASDQWE@.xc344`

---

## 📑 Dashboard Pages & Schemas

| Page | Schema | Tables | Focus |
|------|--------|--------|-------|
| 0 | STAGING_MART_EXECUTIVE | 1 | KPI Summary |
| 1 | STAGING_MART_INSCRIPTIONS | 3 | Enrollment |
| 2 | STAGING_MART_PERFORMANCE_ACADEMIQUE | 3 | Grades |
| 3 | STAGING_MART_DIPLOMATION_INSERTION | 2 | Employment |
| 4 | STAGING_MART_PROFESSEURS | 7 | Professors |
| 5 | STAGING_MART_ADMINISTRATION | 5 | Admin |
| 6 | STAGING_MART_CHARGE_TEMPORELLE | 4 | Workload |
| 7 | STAGING_MART_VIE_ETUDIANTE | 9 | Student Life |
| 8 | STAGING_MART_FINANCE | 5 | Budget |
| 9 | STAGING_MART_SATISFACTION | 6 | Satisfaction |

---

## 🔄 Data Refresh Process

```bash
# 1. Update Excel file
# 2. Export all sheets to CSV

# 3. Load into Snowflake
source /home/school/Documents/4.2/00-Dashboard/env/bin/activate
python3 upload_to_snowflake.py

# 4. Run dbt transformations
source /home/school/Documents/4.2/01-Systeme\ d\'information\ decisionnel/Projet_final/dbt_env/bin/activate
cd /home/school/Documents/4.2/01-Systeme\ d\'information\ decisionnel/Projet_final/dw_ecole
dbt run --profiles-dir .

# 5. Refresh Power BI dataset
```

---

## 📂 Project Files

```
Projet_final/
  ├── DOCUMENTATION.md              ← Full technical docs
  ├── POWERBI_CREDENTIALS.md        ← Connection guide
  ├── upload_to_snowflake.py        ← Data loader script
  ├── dw_ecole/                     ← dbt project
  │   ├── dbt_project.yml
  │   ├── profiles.yml
  │   ├── models/
  │   │   ├── sources.yml
  │   │   ├── staging/              ← 26 cleaning views
  │   │   └── mart_*/               ← 10 marts
  │   └── dbt_env/                  ← Python venv
  ├── csv/                          ← 27 CSV files
  └── dbt_files/                    ← Original templates
```

---

## 🚀 Key Metrics

### Page 0 — Executive
- Satisfaction globale pondérée
- Taux de diplomation
- Taux de rétention
- Taux d'occupation salles
- Budget exécuté
- NPS étudiant
- Taux d'emploi 6 mois

### Page 1 — Inscriptions
- Effectif total: **1,200 étudiants**
- Inscriptions: **3,013 records**
- Répartition par filière/niveau

### Page 2 — Performance
- Notes: **3,000 records**
- Taux de réussite par module
- Modules à risque (>30% échec)

### Page 3 — Insertion
- Diplômés: **346 records**
- Délai moyen d'insertion
- Taux d'emploi 6 mois

### Page 4 — Professeurs
- Professeurs: **80**
- Séances: **2,000 records**
- Satisfaction pondérée

### Page 5 — Administration
- Staff: **30 personnes**
- Demandes: **600 records**
- Accueils: **700 records**

### Page 6 — Charge
- Charge étudiante: **2,001 records**
- Ratio cours/travail perso
- Détection surcharge

### Page 7 — Vie Étudiante
- Présences: **2,500 records**
- Clubs: **15 associations**
- Participations: **754 records**
- Aide sociale: **250 records**
- Signalements: **150 records**
- Mobilité: **180 records**
- Visites santé: **300 records**

### Page 8 — Finance
- Frais scolarité: **1,989 records**
- Budget: **72 records**
- Financement: **100 records**

### Page 9 — Satisfaction
- Enquêtes: **800 records**
- Poids leviers: **5 records**
- Seuils alerte: **7 records**

---

## ✅ Verification Queries

Run these in Snowflake to verify data:

```sql
-- Check RAW data loaded
SELECT COUNT(*) FROM DW_ECOLE.RAW.ETUDIANT;  -- Should be 1,200

-- Check STAGING cleaned
SELECT COUNT(*) FROM DW_ECOLE.STAGING_STAGING.stg_etudiant;  -- Should be 1,200

-- Check MART data
SELECT COUNT(*) FROM DW_ECOLE.STAGING_MART_INSCRIPTIONS.fact_inscription;  -- Should be 3,013
SELECT COUNT(*) FROM DW_ECOLE.STAGING_MART_PERFORMANCE_ACADEMIQUE.fact_note;  -- Should be 3,000
SELECT COUNT(*) FROM DW_ECOLE.STAGING_MART_SATISFACTION.fact_satisfaction;  -- Should be 800
```

---

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| Power BI won't connect | Check server URL, username, password |
| No tables in Power BI | Verify schema name (STAGING_MART_*) |
| Slow queries | Increase warehouse size or add filters |
| Data not updated | Re-run `dbt run` and refresh Power BI |
| dbt fails | Run `dbt debug --profiles-dir .` |

---

## 📞 Support

- **dbt docs**: https://docs.getdbt.com
- **Snowflake docs**: https://docs.snowflake.com
- **Power BI docs**: https://docs.microsoft.com/power-bi

---

**Created**: May 30, 2024  
**Status**: Production Ready  
**Version**: 1.0
