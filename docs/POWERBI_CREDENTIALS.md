# Power BI — Snowflake Connection Credentials

## Connection Details

Use these credentials to connect Power BI to Snowflake and build dashboards.

### Snowflake Account Information

```
Account Identifier:  YFQOTUU-OX87105
Server URL:          YFQOTUU-OX87105.snowflakecomputing.com
Username:            SECONDNAOUFALSCHOL
Password:            ASDFASDQWE@.xc344
Role:                ACCOUNTADMIN
Warehouse:           COMPUTE_WH
Database:            DW_ECOLE
```

---

## Power BI Connection Steps

### Step 1: Open Power BI Desktop

1. Launch **Power BI Desktop**
2. Click **Get Data** (top left)
3. Search for **Snowflake**
4. Click **Snowflake** → **Connect**

### Step 2: Enter Server Details

In the Snowflake connection dialog:

| Field | Value |
|-------|-------|
| **Server** | `YFQOTUU-OX87105.snowflakecomputing.com` |
| **Warehouse** | `COMPUTE_WH` |
| **Database** | `DW_ECOLE` |
| **Schema** | See below (depends on which page) |

### Step 3: Authentication

- **Authentication type**: Basic
- **Username**: `SECONDNAOUFALSCHOL`
- **Password**: `ASDFASDQWE@.xc344`

### Step 4: Select Schema & Tables

Choose the mart schema for your dashboard:

---

## Mart Schemas by Dashboard Page

### Page 0 — Executive Summary
**Schema**: `STAGING_MART_EXECUTIVE`

**Tables to import**:
- `kpi_summary`

---

### Page 1 — Inscriptions & Effectifs
**Schema**: `STAGING_MART_INSCRIPTIONS`

**Tables to import**:
- `dim_etudiant_mart_inscriptions`
- `dim_date_mart_inscriptions`
- `fact_inscription`

**Key fields**:
- `id_etudiant`, `nom`, `prenom`, `filiere`, `niveau_actuel`, `statut`
- `annee_universitaire`, `type_inscription`
- `is_nouvel_inscrit`, `is_abandon`, `is_actif`, `is_diplome`

---

### Page 2 — Performance Académique
**Schema**: `STAGING_MART_PERFORMANCE_ACADEMIQUE`

**Tables to import**:
- `dim_etudiant_mart_performance_academique`
- `dim_module_mart_performance_academique`
- `fact_note`

**Key fields**:
- `note`, `mention`, `resultat`, `session`
- `taux_reussite_module`, `taux_echec_module`
- `is_module_a_risque`

---

### Page 3 — Diplômation & Insertion
**Schema**: `STAGING_MART_DIPLOMATION_INSERTION`

**Tables to import**:
- `dim_etudiant_mart_diplomation_insertion`
- `fact_insertion`

**Key fields**:
- `date_diplome`, `date_premier_emploi`
- `salaire_embauche`, `secteur`, `type_poursuite`
- `delai_insertion_jours`, `is_emploi_6mois`

---

### Page 4 — Professeurs
**Schema**: `STAGING_MART_PROFESSEURS`

**Tables to import**:
- `dim_professeur_mart_professeurs`
- `dim_module_mart_professeurs`
- `dim_salle_mart_professeurs`
- `dim_date_mart_professeurs`
- `fact_seance_cours`
- `fact_devoir`
- `fact_satisfaction_prof`

**Key fields**:
- `grade`, `departement`, `specialite`, `charge_prevue_h`
- `effectuee`, `retard_minutes`, `nb_etudiants_presents`
- `duree_seance_h`, `taux_occupation_salle`, `is_en_retard`
- `score_satisfaction_prof`

---

### Page 5 — Administration & Staff
**Schema**: `STAGING_MART_ADMINISTRATION`

**Tables to import**:
- `dim_staff_mart_administration`
- `dim_etudiant_mart_administration`
- `dim_date_mart_administration`
- `fact_demande_admin`
- `fact_accueil_staff`

**Key fields**:
- `type_demande`, `resolu_premier_contact`, `satisfaction_service`
- `delai_traitement_jours`
- `initie_par`, `motif`, `duree_accueil_minutes`

---

### Page 6 — Charge Temporelle
**Schema**: `STAGING_MART_CHARGE_TEMPORELLE`

**Tables to import**:
- `dim_etudiant_mart_charge_temporelle`
- `dim_module_mart_charge_temporelle`
- `dim_date_mart_charge_temporelle`
- `fact_charge_temps`

**Key fields**:
- `heures_cours`, `heures_devoirs`, `heures_projets`, `heures_temps_mort`
- `charge_totale`, `ratio_cours_travail_perso`
- `is_surcharge`

---

### Page 7 — Vie Étudiante & Bien-être
**Schema**: `STAGING_MART_VIE_ETUDIANTE`

**Tables to import**:
- `dim_etudiant_mart_vie_etudiante`
- `dim_club_mart_vie_etudiante`
- `dim_date_mart_vie_etudiante`
- `fact_presence`
- `fact_participation`
- `fact_aide_sociale`
- `fact_signalement`
- `fact_mobilite`
- `fact_visite_sante`

**Key fields**:
- `present`, `justifiee`, `is_absence_injustifiee`
- `role` (in clubs)
- `type_aide`, `montant_mad`, `delai_traitement_jours`
- `type_signalement`, `gravite`
- `type_mobilite`, `pays_destination`, `duree_mobilite_jours`
- `type_service`, `motif`

---

### Page 8 — Finance & Dépenses
**Schema**: `STAGING_MART_FINANCE`

**Tables to import**:
- `dim_etudiant_mart_finance`
- `dim_date_mart_finance`
- `fact_frais_scolarite`
- `fact_budget`
- `fact_financement`

**Key fields**:
- `montant_du`, `montant_paye`, `statut`
- `montant_impaye`, `taux_recouvrement`
- `budget_prevu`, `budget_execute`, `type_depense`
- `taux_execution`, `ecart_budget`
- `source_financement`, `montant_mad`

---

### Page 9 — Satisfaction Globale
**Schema**: `STAGING_MART_SATISFACTION`

**Tables to import**:
- `dim_etudiant_mart_satisfaction`
- `dim_professeur_mart_satisfaction`
- `dim_module_mart_satisfaction`
- `dim_date_mart_satisfaction`
- `fact_satisfaction`
- `ref_poids_levier`

**Key fields**:
- `score_clarte`, `score_disponibilite`, `score_pedagogie`, `score_equite`
- `score_admin`, `score_vie_etudiante`, `score_charge`, `score_finances`
- `score_global`, `nps`
- `score_prof_pondere`, `score_global_pondere`
- `levier`, `poids`

---

## Quick Connection Test

After connecting, run this query in Power BI to verify:

```sql
SELECT COUNT(*) as total_records FROM STAGING_MART_INSCRIPTIONS.fact_inscription
```

Expected result: **3,013 records**

---

## Troubleshooting

### Connection Error: "Invalid account identifier"
- Verify server URL: `YFQOTUU-OX87105.snowflakecomputing.com`
- Check account ID: `YFQOTUU-OX87105`

### Authentication Failed
- Username: `SECONDNAOUFALSCHOL` (case-sensitive)
- Password: `ASDFASDQWE@.xc344` (case-sensitive)
- Role: `ACCOUNTADMIN`

### No tables appear
- Verify database: `DW_ECOLE`
- Verify schema: `STAGING_MART_*` (not `RAW` or `STAGING_STAGING`)
- Check warehouse is running: `COMPUTE_WH`

### Slow query performance
- Increase warehouse size temporarily
- Limit date range in Power BI filters
- Use aggregated tables (facts) instead of dimensions

---

## Security Notes

⚠️ **Important**: These credentials are for development/testing only.

For production:
1. Create a dedicated Power BI service account in Snowflake
2. Grant minimal required permissions (SELECT on marts only)
3. Rotate passwords regularly
4. Use Snowflake SSO if available

---

## Support

For connection issues:
1. Test Snowflake connection directly: https://YFQOTUU-OX87105.snowflakecomputing.com
2. Check Snowflake query history for errors
3. Verify warehouse `COMPUTE_WH` is running
4. Contact your Snowflake admin

---

**Last Updated**: May 30, 2024  
**Version**: 1.0
