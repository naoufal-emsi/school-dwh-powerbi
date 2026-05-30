# Data Marts

Au lieu d'un seul schema `MARTS` fourre-tout, vous créez un data mart par domaine métier. Chaque data mart est un schema Snowflake indépendant, consommé par la page Power BI correspondante.

**Structure Snowflake avec data marts séparés**

```
STAGING                        → zone de transformation intermédiaire dbt

MART_INSCRIPTIONS              → Page 1
MART_PERFORMANCE_ACADEMIQUE    → Page 2
MART_DIPLOMATION_INSERTION     → Page 3
MART_PROFESSEURS               → Page 4
MART_ADMINISTRATION            → Page 5
MART_CHARGE_TEMPORELLE         → Page 6
MART_VIE_ETUDIANTE             → Page 7
MART_FINANCE                   → Page 8
MART_SATISFACTION              → Page 9
MART_EXECUTIVE                 → Page 0 (agrège les autres marts)
```

**Ce que contient chaque mart**

```
MART_INSCRIPTIONS
  ├── dim_etudiant
  ├── dim_date
  └── fact_inscription

MART_PERFORMANCE_ACADEMIQUE
  ├── dim_etudiant
  ├── dim_module
  ├── dim_date
  └── fact_note

MART_DIPLOMATION_INSERTION
  ├── dim_etudiant
  ├── dim_date
  └── fact_insertion

MART_PROFESSEURS
  ├── dim_professeur
  ├── dim_module
  ├── dim_salle
  ├── dim_date
  ├── fact_seance_cours
  ├── fact_devoir
  └── fact_satisfaction

MART_ADMINISTRATION
  ├── dim_staff
  ├── dim_etudiant
  ├── dim_date
  ├── fact_demande_admin
  └── fact_accueil_staff

MART_CHARGE_TEMPORELLE
  ├── dim_etudiant
  ├── dim_module
  ├── dim_date
  ├── fact_charge_temps
  ├── fact_seance_cours
  └── fact_devoir

MART_VIE_ETUDIANTE
  ├── dim_etudiant
  ├── dim_club
  ├── dim_date
  ├── fact_presence
  ├── fact_participation
  ├── fact_aide_sociale
  ├── fact_signalement
  ├── fact_mobilite
  └── fact_visite_sante

MART_FINANCE
  ├── dim_etudiant
  ├── dim_date
  ├── fact_frais_scolarite
  ├── fact_budget
  └── fact_financement

MART_SATISFACTION
  ├── dim_etudiant
  ├── dim_professeur
  ├── dim_module
  ├── dim_date
  ├── fact_satisfaction
  └── ref_poids_levier

MART_EXECUTIVE
  └── kpi_summary (vue agrégée sur tous les marts)
```

---

**Les avantages de cette séparation**

Chaque équipe Power BI ne voit que les données qui la concernent — le membre qui construit la page Finance ne se noie pas dans les tables de satisfaction ou de présence.

Les droits d'accès sont plus fins — vous pouvez donner accès à `MART_FINANCE` uniquement à la direction financière par exemple.

Les performances sont meilleures — Power BI charge uniquement le mart nécessaire, pas toutes les tables.

La maintenance est plus claire — si un KPI de la page Professeurs est faux, vous savez exactement où chercher dans `MART_PROFESSEURS`.

---

**La seule nuance**

Les dimensions partagées comme `dim_etudiant`, `dim_date`, `dim_module` sont dupliquées dans plusieurs marts. C'est intentionnel et acceptable — chaque mart est autonome et indépendant. C'est le principe même d'un data mart.


