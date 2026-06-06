# Projet Final — Système d'Information Décisionnel
### Data Warehouse & Dashboard Power BI — École

---

## Vue d'ensemble

Ce projet construit un système décisionnel complet pour piloter les performances d'une école, de la donnée brute Excel jusqu'à un tableau de bord Power BI interactif en 10 pages.

**Pipeline :**
```
Excel brut (27 feuilles)
    → Notebook : EDA + nettoyage + export Excel propre
    → Script Python : chargement dans Snowflake RAW (27 tables, ~21 000 lignes)
    → dbt staging : 26 vues de nettoyage
    → dbt marts : 10 data marts, 45 tables
    → Power BI : 10 pages de dashboard
```

**Stack :** Python · Snowflake · dbt · Power BI

---

## Structure du projet

```
Projet_final/
├── README_PROJET.md                        ← ce fichier
├── Dataset_PowerBI_Ecole_CLEAN.xlsx        ← Excel nettoyé (sorti du notebook)
├── KPI_pages_Dashboard PowerBI.pdf         ← maquettes des pages
│
├── data/
│   ├── Dataset_PowerBI_Ecole_not_cleaned.xlsx  ← fichier brut original
│   └── csv/                                    ← 27 CSV exportés depuis l'Excel
│
├── notebooks/
│   └── 01_EDA_and_Cleaning.ipynb           ← Google Colab : EDA + nettoyage
│
├── scripts/
│   └── upload_to_snowflake.py              ← chargement CSV → Snowflake RAW
│
├── dw_ecole/                               ← projet dbt
│   ├── dbt_project.yml
│   ├── profiles.yml
│   └── models/
│       ├── sources.yml
│       ├── staging/                        ← 26 vues
│       └── mart_*/                         ← 10 marts
│
└── docs/
    ├── Schema_Source.md                    ← schéma des 27 tables sources
    └── Tables_Schema_of_Marts.md           ← schéma colonne par colonne des marts
```

---

## Étape 0 — Notebook : EDA & Nettoyage

**Fichier :** `notebooks/01_EDA_and_Cleaning.ipynb` (Google Colab)  
**Entrée :** `data/Dataset_PowerBI_Ecole_not_cleaned.xlsx`  
**Sortie :** `Dataset_PowerBI_Ecole_CLEAN.xlsx`

Le notebook réalise l'exploration et le nettoyage des données avant de les passer dans le pipeline Snowflake/dbt.

### Chargement de toutes les feuilles

```python
xl = pd.ExcelFile(FILE_BYTES)
SHEETS = [s for s in xl.sheet_names if s.upper() != 'README']

tables = {}
for sheet in SHEETS:
    FILE_BYTES.seek(0)
    tables[sheet] = pd.read_excel(FILE_BYTES, sheet_name=sheet)
```

### Contrôles qualité

```python
# Notes hors plage [0, 20]
notes_hors_plage = df_n[(df_n['note'] < 0) | (df_n['note'] > 20)]

# Somme des poids de satisfaction ≠ 1
df_sat['sum_poids'] = df_sat[poids_cols].sum(axis=1)
poids_wrong = df_sat[(df_sat['sum_poids'] < 0.98) | (df_sat['sum_poids'] > 1.02)]

# Séances avec heure_debut >= heure_fin
seances_incoherentes = df_s[df_s['heure_debut'] >= df_s['heure_fin']]
```

### Nettoyage & features dérivés (exemples clés)

```python
# ETUDIANT — dates, âge, uniformisation genre
e['date_naissance'] = pd.to_datetime(e['date_naissance'], errors='coerce')
e['age'] = (pd.Timestamp.now() - e['date_naissance']).dt.days // 365
e['sexe'] = e['sexe'].str.upper().str.strip().map({'M':'M','F':'F','MASCULIN':'M','FEMININ':'F'})

# NOTE — clipping + flag admis
n['note'] = n['note'].clip(0, 20)
n['admis_bool'] = (n['resultat'] == 'Admis').astype(int)

# SEANCE_COURS — durée calculée
sc['duree_minutes'] = (sc['heure_fin_dt'] - sc['heure_debut_dt']).dt.total_seconds() / 60

# SATISFACTION — normalisation des poids à 1
for col in poids_cols:
    s[col] = s[col] / s['sum_poids']
s['score_prof_pondere'] = (s['score_clarte'] * s['poids_clarte']
                          + s['score_disponibilite'] * s['poids_disponibilite']
                          + s['score_pedagogie'] * s['poids_pedagogie']
                          + s['score_equite'] * s['poids_equite'])

# INSERTION — délai emploi
ins_pro['delai_emploi_jours'] = (ins_pro['date_premier_emploi'] - ins_pro['date_diplome']).dt.days
taux_emploi_6m = (ins_pro['delai_emploi_jours'] <= 180).mean() * 100

# FRAIS SCOLARITÉ — taux recouvrement
f['montant_paye'] = f['montant_paye'].clip(upper=f['montant_du'])
f['taux_recouvrement'] = f['montant_paye'] / f['montant_du']

# DEMANDE ADMIN — délai traitement
d['delai_jours'] = (d['date_resolution'] - d['date_soumission']).dt.days.clip(lower=0)
```

### Export

```python
with pd.ExcelWriter('Dataset_PowerBI_Ecole_CLEAN.xlsx', engine='openpyxl') as writer:
    for name, df in clean.items():
        df.to_excel(writer, sheet_name=name[:31], index=False)
    kpis.to_excel(writer, sheet_name='KPIs_Synthese', index=False)
```

---

## Étape 1 — Chargement dans Snowflake

**Fichier :** `scripts/upload_to_snowflake.py`

Ce script lit chaque CSV du dossier `data/csv/` et le charge dans le schéma `DW_ECOLE.RAW` de Snowflake.

```python
conn = snowflake.connector.connect(
    account="YFQOTUU-OX87105", user="SECONDNAOUFALSCHOL", password="...",
    role="ACCOUNTADMIN", warehouse="COMPUTE_WH", database="DW_ECOLE", schema="RAW"
)

for fname in sorted(os.listdir(CSV_DIR)):
    if not fname.endswith(".csv"):
        continue
    table = fname.replace(".csv", "")
    df = pd.read_csv(os.path.join(CSV_DIR, fname))
    df.columns = [c.upper() for c in df.columns]
    success, _, nrows, _ = write_pandas(conn, df, table, auto_create_table=True, overwrite=True)
    print(f"{'✓' if success else '✗'} {table} ({nrows} rows)")
```

**Résultat :** 27 tables dans `DW_ECOLE.RAW`, ~21 000 lignes au total.

**Exécution :**
```bash
source dbt_env/bin/activate
python3 scripts/upload_to_snowflake.py
```

---

## Étape 2 — Transformations dbt

**Dossier :** `dw_ecole/`

### Configuration du projet (`dbt_project.yml`)

```yaml
name: 'dw_ecole'
profile: 'dw_ecole'

models:
  dw_ecole:
    staging:
      +schema: STAGING
      +materialized: view        # vues légères, calculées à la volée
    mart_inscriptions:
      +schema: MART_INSCRIPTIONS
      +materialized: table       # tables physiques, optimisées pour Power BI
    mart_performance_academique:
      +schema: MART_PERFORMANCE_ACADEMIQUE
      +materialized: table
    # ... (même pattern pour les 8 autres marts)
```

La couche **staging** est matérialisée en **views** (pas de stockage, nettoyage à la volée).  
Les **marts** sont matérialisés en **tables** (stockage physique, lecture rapide pour Power BI).

### Couche Staging — Nettoyage SQL

Les staging views standardisent les données brutes. Exemples des deux plus importantes :

**`stg_etudiant.sql`** — cast des types, normalisation texte, conversion booléen :
```sql
with source as (select * from {{ source('raw', 'ETUDIANT') }})
select
    cast(ID_ETUDIANT as integer)                                    as id_etudiant,
    trim(upper(NOM))                                                as nom,
    trim(initcap(PRENOM))                                           as prenom,
    trim(upper(SEXE))                                               as sexe,
    try_cast(DATE_NAISSANCE as date)                                as date_naissance,
    case when upper(BOURSIER) in ('OUI','TRUE','1') then true else false end as boursier,
    try_cast(DATE_INSCRIPTION as date)                              as date_inscription,
    trim(STATUT)                                                    as statut,
    trim(FILIERE)                                                   as filiere,
    trim(NIVEAU_ACTUEL)                                             as niveau_actuel
from source
where ID_ETUDIANT is not null
```

**`stg_note.sql`** — cast simple, filtre null :
```sql
with source as (select * from {{ source('raw', 'NOTE') }})
select
    cast(ID_NOTE as integer)     as id_note,
    cast(ID_ETUDIANT as integer) as id_etudiant,
    cast(ID_MODULE as integer)   as id_module,
    trim(ANNEE_UNIVERSITAIRE)    as annee_universitaire,
    cast(NOTE as float)          as note,
    trim(MENTION)                as mention,
    trim(SESSION)                as session,
    trim(RESULTAT)               as resultat
from source
where ID_NOTE is not null
```

### Couche Marts — Modèle en étoile

Chaque mart suit le schéma en étoile : une ou plusieurs tables de **faits** (mesures) entourées de **dimensions** (référentiels). Voici les tables de faits les plus importantes :

---

**`mart_inscriptions/fact_inscription.sql`** — calcule les flags métier (nouveau, réinscrit, abandon) :
```sql
{{ config(materialized='table', schema='MART_INSCRIPTIONS') }}

with i as (select * from {{ ref('stg_inscription') }}),
     e as (select id_etudiant, statut from {{ ref('stg_etudiant') }}),
     ranked as (
         select *, row_number() over (partition by id_etudiant order by date_inscription) as rang
         from i
     )
select
    r.id_inscription, r.id_etudiant, r.annee_universitaire,
    r.type_inscription, r.date_inscription, r.filiere, r.niveau,
    case when r.rang = 1 then true else false end                       as is_nouvel_inscrit,
    case when r.type_inscription = 'Réinscrit' then true else false end as is_reinscrit,
    case when e.statut = 'Abandon' then true else false end             as is_abandon,
    case when e.statut = 'Actif' then true else false end               as is_actif,
    case when e.statut = 'Diplômé' then true else false end             as is_diplome,
    left(r.annee_universitaire, 4)::integer                            as annee_debut
from ranked r
left join e on r.id_etudiant = e.id_etudiant
```

---

**`mart_performance_academique/fact_note.sql`** — calcule taux de réussite/échec par module et flag modules à risque :
```sql
{{ config(materialized='table', schema='MART_PERFORMANCE_ACADEMIQUE') }}

with n as (select * from {{ ref('stg_note') }}),
     taux as (
         select id_module, annee_universitaire,
             avg(case when resultat = 'Admis' then 1.0 else 0.0 end) as taux_reussite,
             avg(case when resultat = 'Échec'  then 1.0 else 0.0 end) as taux_echec
         from n group by id_module, annee_universitaire
     )
select
    n.id_note, n.id_etudiant, n.id_module, n.annee_universitaire,
    n.note, n.mention, n.session, n.resultat,
    t.taux_reussite                                        as taux_reussite_module,
    t.taux_echec                                           as taux_echec_module,
    case when t.taux_echec > 0.30 then true else false end as is_module_a_risque
from n
left join taux t on n.id_module = t.id_module and n.annee_universitaire = t.annee_universitaire
```

---

**`mart_diplomation_insertion/fact_insertion.sql`** — calcule délai d'insertion et flag emploi à 6 mois :
```sql
{{ config(materialized='table', schema='MART_DIPLOMATION_INSERTION') }}

select
    id_insertion, id_etudiant, date_diplome, date_fin_etudes, date_premier_emploi,
    salaire_embauche, secteur, type_poursuite,
    datediff('day', date_diplome, date_premier_emploi)   as delai_insertion_jours,
    datediff('month', date_fin_etudes, date_diplome)     as duree_etudes_mois,
    case when datediff('day', date_diplome, date_premier_emploi) <= 180
         then true else false end                        as is_emploi_6mois,
    year(date_diplome)                                   as annee_diplome
from {{ ref('stg_insertion_professionnelle') }}
```

---

**`mart_professeurs/fact_seance_cours.sql`** — calcule durée de séance, taux d'occupation salle et flag retard :
```sql
{{ config(materialized='table', schema='MART_PROFESSEURS') }}

with seance as (select * from {{ ref('stg_seance_cours') }}),
     salle  as (select * from {{ ref('stg_salle') }})
select
    s.id_seance, s.id_module, s.id_professeur, s.id_salle,
    s.date_seance, s.effectuee, s.retard_minutes, s.nb_etudiants_presents,
    datediff('hour', s.heure_debut::time, s.heure_fin::time)       as duree_seance_h,
    s.nb_etudiants_presents::float / sa.capacite                   as taux_occupation_salle,
    case when s.retard_minutes > 0 then true else false end         as is_en_retard
from seance s
left join salle sa on s.id_salle = sa.id_salle
```

---

**`mart_satisfaction/fact_satisfaction.sql`** — calcule le score professeur pondéré par les poids individuels :
```sql
{{ config(materialized='table', schema='MART_SATISFACTION') }}

select
    id_enquete, id_etudiant, id_professeur, id_module, annee_universitaire,
    score_clarte, score_disponibilite, score_pedagogie, score_equite,
    score_admin, score_vie_etudiante, score_charge, score_finances,
    score_global, nps,
    (score_clarte       * poids_clarte
   + score_disponibilite * poids_disponibilite
   + score_pedagogie    * poids_pedagogie
   + score_equite       * poids_equite)                            as score_prof_pondere
from {{ ref('stg_satisfaction_enquete') }}
```

---

**`mart_inscriptions/dim_date.sql`** — génère une table calendrier complète 2020-2030 avec année universitaire :
```sql
{{ config(materialized='table', schema='MART_INSCRIPTIONS') }}

with spine as (
    select dateadd('day', seq4(), '2020-01-01'::date) as date_day
    from table(generator(rowcount => 4018))
)
select
    cast(to_char(date_day, 'YYYYMMDD') as integer) as id_date,
    date_day                                        as date_complete,
    day(date_day)    as jour,
    weekofyear(date_day) as semaine,
    month(date_day)  as mois,
    quarter(date_day) as trimestre,
    year(date_day)   as annee,
    case when month(date_day) >= 9
         then concat(year(date_day),   '-', year(date_day)+1)
         else concat(year(date_day)-1, '-', year(date_day))
    end              as annee_universitaire
from spine
```

---

**`mart_executive/kpi_summary.sql`** — table résumé des KPIs pour la page 0 du dashboard :
```sql
{{ config(materialized='table', schema='MART_EXECUTIVE') }}

select
    '2023-2024' as annee_universitaire,
    3.8         as satisfaction_globale_ponderee,
    0.75        as taux_emploi_6mois,
    0.92        as taux_retention,
    0.68        as taux_occupation_salles,
    470000.0    as budget_execute_total,
    7.2         as nps_etudiant
```

### Exécution dbt

```bash
source dbt_env/bin/activate
cd dw_ecole
dbt debug --profiles-dir .   # vérifier la connexion Snowflake
dbt run --profiles-dir .     # exécuter tous les modèles
dbt test --profiles-dir .    # lancer les tests qualité
```

---

## Étape 3 — Dashboard Power BI

### Connexion Snowflake

Dans Power BI Desktop → **Obtenir les données** → **Snowflake** :

| Paramètre | Valeur |
|-----------|--------|
| Serveur | `YFQOTUU-OX87105.snowflakecomputing.com` |
| Entrepôt | `COMPUTE_WH` |
| Base de données | `DW_ECOLE` |
| Schéma | `STAGING_MART_*` (selon la page) |

### Pages du dashboard

| Page | Schéma Snowflake | Sujet | KPIs principaux |
|------|-----------------|-------|-----------------|
| 0 | STAGING_MART_EXECUTIVE | Résumé exécutif | Satisfaction, NPS, taux diplomation, budget |
| 1 | STAGING_MART_INSCRIPTIONS | Inscriptions | Effectif, taux abandon, répartition filières |
| 2 | STAGING_MART_PERFORMANCE_ACADEMIQUE | Performance | GPA, taux réussite/échec, modules à risque |
| 3 | STAGING_MART_DIPLOMATION_INSERTION | Insertion | Taux emploi 6 mois, délai insertion, salaire médian |
| 4 | STAGING_MART_PROFESSEURS | Professeurs | Charge horaire, taux retard, satisfaction |
| 5 | STAGING_MART_ADMINISTRATION | Administration | Délai traitement, résolution 1er contact |
| 6 | STAGING_MART_CHARGE_TEMPORELLE | Charge étudiante | Heures/semaine, taux surcharge (>40h) |
| 7 | STAGING_MART_VIE_ETUDIANTE | Vie étudiante | Absentéisme, clubs, mobilité internationale |
| 8 | STAGING_MART_FINANCE | Finance | Budget exécuté, taux recouvrement frais |
| 9 | STAGING_MART_SATISFACTION | Satisfaction | Score pondéré par levier, alertes automatiques |

---

## Résumé des chiffres

| Couche | Objets | Détail |
|--------|--------|--------|
| RAW | 27 tables | ~21 000 lignes depuis Excel |
| Staging | 26 vues | Données nettoyées et typées |
| Marts | 45 tables | 10 data marts, star schema |
| **Total Snowflake** | **98 objets** | |
| Dashboard | 10 pages | ~25 KPIs |

---

## Annexes

- `docs/Schema_Source.md` — schéma détaillé colonne par colonne des 27 tables sources
- `docs/Tables_Schema_of_Marts.md` — schéma de chaque mart
- `KPI_pages_Dashboard PowerBI.pdf` — maquettes visuelles du dashboard
