# ETL Pipeline Documentation — École DWH Project

## Project Overview

This document describes the complete ETL pipeline built to transform raw school data from Excel into a production-ready Data Warehouse (DWH) in Snowflake, optimized for Power BI dashboards.

**Project Goal**: Create a 10-page analytical dashboard tracking school performance across 9 key domains (inscriptions, academics, employment, professors, administration, workload, student life, finance, satisfaction).

---

## Architecture

### High-Level Flow

```
Excel File (27 sheets)
    ↓
CSV Export (27 files)
    ↓
Snowflake RAW Schema (27 tables)
    ↓
dbt Staging Layer (26 cleaned views)
    ↓
dbt Mart Layer (10 marts, 45 tables)
    ↓
Power BI Dashboards (10 pages)
```

### Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Source** | Excel (Dataset_PowerBI_Ecole_CLEAN.xlsx) | Raw operational data |
| **Extract** | Python + Snowflake Connector | Load CSVs into Snowflake RAW |
| **Transform** | dbt (Data Build Tool) | Clean, structure, aggregate data |
| **Load** | dbt + Snowflake | Materialize tables in marts |
| **DWH** | Snowflake | Cloud data warehouse |
| **BI** | Power BI | Visualization & dashboards |
| **Orchestration** | dbt (local) | Manual runs; can add Airflow later |

---

## What We Built

### 1. Data Extraction (Python Script)

**File**: `upload_to_snowflake.py`

**What it does**:
- Reads all 27 sheets from Excel
- Converts each sheet to a pandas DataFrame
- Uploads directly to Snowflake `DW_ECOLE.RAW` schema
- Handles data type inference automatically

**Result**: 27 tables in RAW schema with ~21,000 rows total

**Source Tables**:
```
ETUDIANT, INSCRIPTION, MODULE, NOTE, PRESENCE_ETUDIANT,
PROFESSEUR, SEANCE_COURS, SALLE, DEVOIR, SATISFACTION_ENQUETE,
INSERTION_PROFESSIONNELLE, DEMANDE_ADMINISTRATIVE, BUDGET_DEPARTEMENT,
FRAIS_SCOLARITE, STAFF_ADMINISTRATIF, ACCUEIL_STAFF,
CHARGE_TEMPS_ETUDIANT, CLUB_ASSOCIATION, PARTICIPATION_CLUB,
AIDE_SOCIALE, SIGNALEMENT_DISCIPLINAIRE, MOBILITE_INTERNATIONALE,
VISITE_SANTE, FINANCEMENT_EXTERNE, POIDS_LEVIER_SATISFACTION, SEUIL_ALERTE, KPIs_Synthese
```

---

### 2. Data Transformation (dbt)

**Project**: `dw_ecole/` directory

**Structure**:
```
dw_ecole/
  ├── dbt_project.yml          ← Project config
  ├── profiles.yml             ← Snowflake connection
  ├── packages.yml             ← dbt_utils dependency
  ├── models/
  │   ├── sources.yml          ← Declares all 27 RAW tables
  │   ├── staging/             ← 26 cleaning views
  │   │   ├── stg_etudiant.sql
  │   │   ├── stg_note.sql
  │   │   └── ... (24 more)
  │   └── mart_*/              ← 10 marts with 45 tables
  │       ├── mart_inscriptions/
  │       ├── mart_performance_academique/
  │       ├── mart_diplomation_insertion/
  │       ├── mart_professeurs/
  │       ├── mart_administration/
  │       ├── mart_charge_temporelle/
  │       ├── mart_vie_etudiante/
  │       ├── mart_finance/
  │       ├── mart_satisfaction/
  │       └── mart_executive/
```

#### Staging Layer (26 views)

**Purpose**: Clean and standardize raw data

**Transformations applied**:
- Type casting (integers, dates, booleans)
- Text normalization (trim, uppercase, initcap)
- Boolean conversion (Oui/Non → true/false)
- Null handling
- Calculated fields (age, delays, ratios)

**Example** (`stg_etudiant.sql`):
```sql
select
    cast(ID_ETUDIANT as integer) as id_etudiant,
    trim(upper(NOM)) as nom,
    trim(initcap(PRENOM)) as prenom,
    try_cast(DATE_NAISSANCE as date) as date_naissance,
    case when upper(BOURSIER) in ('OUI','TRUE','1') then true else false end as boursier,
    ...
from {{ source('raw', 'ETUDIANT') }}
where ID_ETUDIANT is not null
```

#### Mart Layer (10 marts, 45 tables)

**Purpose**: Organize data by business domain for Power BI consumption

Each mart contains:
- **Dimensions** (reference tables): dim_etudiant, dim_date, dim_module, etc.
- **Facts** (measurement tables): fact_inscription, fact_note, fact_satisfaction, etc.

**Marts**:

| Mart | Page | Tables | Purpose |
|------|------|--------|---------|
| MART_INSCRIPTIONS | 1 | 3 | Student enrollment tracking |
| MART_PERFORMANCE_ACADEMIQUE | 2 | 3 | Academic grades & success rates |
| MART_DIPLOMATION_INSERTION | 3 | 2 | Graduation & employment outcomes |
| MART_PROFESSEURS | 4 | 7 | Professor performance & satisfaction |
| MART_ADMINISTRATION | 5 | 5 | Admin service quality |
| MART_CHARGE_TEMPORELLE | 6 | 4 | Student workload analysis |
| MART_VIE_ETUDIANTE | 7 | 9 | Student life & wellbeing |
| MART_FINANCE | 8 | 5 | Budget & fees |
| MART_SATISFACTION | 9 | 6 | Overall satisfaction metrics |
| MART_EXECUTIVE | 0 | 1 | Executive summary KPIs |

**Example** (`fact_inscription.sql`):
```sql
with inscriptions as (select * from {{ ref('stg_inscription') }}),
     etudiants as (select id_etudiant, statut from {{ ref('stg_etudiant') }})
select
    i.id_inscription, i.id_etudiant, i.annee_universitaire,
    case when i.rang_inscription = 1 then true else false end as is_nouvel_inscrit,
    case when e.statut = 'Abandon' then true else false end as is_abandon,
    ...
from inscriptions i
left join etudiants e on i.id_etudiant = e.id_etudiant
```

---

### 3. Data Loading

**Method**: dbt materialization

- **Staging views**: Materialized as SQL views (no storage, computed on query)
- **Mart tables**: Materialized as physical tables (optimized for Power BI)

**Execution**:
```bash
source dbt_env/bin/activate
cd dw_ecole
dbt run --profiles-dir .
```

**Result**: 71 models created
- 26 staging views in `STAGING_STAGING`
- 45 mart tables across 10 schemas

---

## Snowflake Structure

### Database: `DW_ECOLE`

```
DW_ECOLE/
  ├── RAW/                              (27 tables, ~21K rows)
  │   └── Source data from Excel
  │
  ├── STAGING_STAGING/                 (26 views)
  │   └── Cleaned, typed data
  │
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

### Warehouse: `COMPUTE_WH`

- **Size**: X-Small (1 credit/hour)
- **Auto-suspend**: 60 seconds
- **Auto-resume**: Enabled

---

## Key Metrics & KPIs

### Page 0 — Executive Summary
- Satisfaction globale pondérée
- Taux de diplomation
- Taux de rétention
- Taux d'occupation des salles
- Budget exécuté
- NPS étudiant
- Taux d'emploi 6 mois

### Page 1 — Inscriptions & Effectifs
- Effectif total
- Taux d'inscription YoY
- Répartition genre/filière/niveau
- Taux de rétention
- Taux d'abandon

### Page 2 — Performance Académique
- Moyenne générale GPA
- Taux de réussite par module
- Taux d'échec par module
- Modules à risque (>30% échec)

### Page 3 — Diplômation & Insertion
- Taux de diplomation
- Délai moyen d'insertion
- Taux d'emploi 6 mois
- Salaire médian

### Page 4 — Professeurs
- Nombre d'étudiants par prof
- Taux de retard
- Taux de satisfaction (pondéré)
- Charge horaire assurée vs prévue

### Page 5 — Administration & Staff
- Temps moyen par étudiant
- Taux de résolution au 1er contact
- Délai moyen de traitement
- Satisfaction du service

### Page 6 — Charge Temporelle
- Heures de cours/semaine
- Heures de travail personnel
- Ratio cours/travail perso
- Détection de surcharge

### Page 7 — Vie Étudiante & Bien-être
- Taux d'absentéisme
- Participation aux clubs
- Aide sociale accordée
- Signalements disciplinaires
- Mobilité internationale

### Page 8 — Finance & Dépenses
- Budget total vs exécuté
- Taux de recouvrement frais
- Coût par étudiant
- Financements externes

### Page 9 — Satisfaction Globale
- Score pondéré par levier
- Évolution temporelle
- Top 5 points forts/friction
- Alertes automatiques

---

## Data Quality & Validation

### Staging Transformations
- Null checks on primary keys
- Type validation (dates, integers, booleans)
- Text normalization (trim, case)
- Deduplication where needed

### Mart Calculations
- Aggregations (counts, averages, sums)
- Ratios (taux_reussite, taux_occupation)
- Date calculations (delays, durations)
- Boolean flags (is_abandon, is_surcharge)

### dbt Tests
- Uniqueness tests on primary keys
- Not-null tests on critical fields
- Referential integrity (foreign keys)
- Accepted values (enums)

---

## Team Responsibilities

| Role | Responsibility |
|------|-----------------|
| **Data Engineer** | Maintain dbt project, run transformations, monitor Snowflake |
| **Analytics** | Build Power BI dashboards, define KPIs |
| **Business** | Validate metrics, define thresholds, interpret results |

---

## Maintenance & Updates

### Daily/Weekly
```bash
# Refresh data from Excel
python3 upload_to_snowflake.py

# Run dbt transformations
cd dw_ecole
dbt run --profiles-dir .
```

### Monthly
- Review data quality metrics
- Check for anomalies in KPIs
- Update thresholds if needed

### Quarterly
- Audit mart schemas
- Optimize slow queries
- Plan new metrics

---

## Troubleshooting

### Issue: dbt models fail to run
**Solution**: Check Snowflake connection
```bash
dbt debug --profiles-dir .
```

### Issue: Data not updated in Power BI
**Solution**: Refresh Power BI dataset or re-run dbt
```bash
dbt run --profiles-dir .
```

### Issue: Slow Power BI queries
**Solution**: Check Snowflake warehouse size, consider clustering keys

---

## Future Enhancements

1. **Orchestration**: Add Airflow DAGs for automated daily runs
2. **Incremental Loading**: Implement incremental models for large tables
3. **Data Quality**: Add Great Expectations for automated validation
4. **Monitoring**: Set up Snowflake alerts for anomalies
5. **Documentation**: Auto-generate dbt docs site
6. **Version Control**: Move dbt project to GitHub

---

## Contact & Support

For questions or issues:
- Check dbt logs: `target/logs/dbt.log`
- Review Snowflake query history
- Consult dbt documentation: https://docs.getdbt.com

---

**Last Updated**: May 30, 2024  
**Version**: 1.0  
**Status**: Production Ready
