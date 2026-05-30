# dbt models for MART_INSCRIPTIONS

Voici les modèles dbt complets pour `MART_INSCRIPTIONS`.

**Structure des fichiers**

```
models/
  ├── staging/
  │     ├── stg_etudiant.sql
  │     └── stg_inscription.sql
  ├── mart_inscriptions/
  │     ├── dim_etudiant.sql
  │     ├── dim_date.sql
  │     ├── fact_inscription.sql
  │     └── mart_inscriptions.yml
  └── sources.yml
```

---Voici les 7 fichiers du `MART_INSCRIPTIONS`. Voici comment tout s'articule :

**Ordre d'exécution dbt**

```
sources.yml          → déclare les tables RAW Snowflake
      ↓
stg_etudiant.sql     → nettoie etudiant (types, trim, casse)
stg_inscription.sql  → nettoie inscription
      ↓
dim_etudiant.sql     → dimension étudiant finale + age calculé
dim_date.sql         → dimension date 2020-2030 + annee_universitaire
      ↓
fact_inscription.sql → joint tout + calcule is_nouvel_inscrit, is_abandon, is_reinscrit
```

**Pour lancer uniquement ce mart**

```bash
dbt run --select mart_inscriptions
dbt test --select mart_inscriptions
```

**Ce que Power BI consomme directement**

Les KPIs de la Page 1 sont déjà prêts dans `fact_inscription` — effectif total, nouveaux vs réinscrits, taux d'abandon, répartition par filière, niveau, genre. Power BI n'a plus qu'à aggréger.

Vous voulez qu'on continue avec le prochain mart — `MART_PERFORMANCE_ACADEMIQUE` ?
