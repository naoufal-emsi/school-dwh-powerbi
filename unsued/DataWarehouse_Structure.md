# Data Warehouse Structure — École (Star Schema)

> Source : `Dataset_PowerBI_Ecole_CLEAN.xlsx` — 27 feuilles, ~21 000 lignes totales
> Cible : DW analytique pour Power BI (10 pages de dashboard)

---

## Étapes du processus ETL

```
[Sources OLTP]          [ETL]                  [DW — Couche analytique]
Excel (27 feuilles) ──► Nettoyage / Typage ──► Dimensions + Tables de faits
                     ──► Calcul des clés SK ──► Agrégats / KPIs
                     ──► Chargement         ──► Power BI (Import)
```

### Étape 1 — Extraction
- Lire chaque feuille Excel avec `openpyxl` ou Power Query
- Identifier les clés naturelles (`id_*`) et les colonnes calculées déjà présentes

### Étape 2 — Transformation
- Convertir les dates en clé entière `YYYYMMDD` → jointure avec `DIM_TEMPS`
- Normaliser les booléens (`Oui/Non` → `1/0`)
- Dédupliquer les dimensions
- Extraire `DIM_DEPARTEMENT` depuis PROFESSEUR, MODULE, STAFF, BUDGET, FINANCEMENT
- Calculer `sk_annee` dans FACT_INSERTION depuis `date_diplome`

### Étape 3 — Chargement (Load)
- Charger d'abord les **dimensions** (pas de dépendances)
- Puis les **tables de faits** (dépendent des dimensions via SK)
- `DIM_TEMPS` : générée une seule fois pour toutes les dates du dataset

---

## Dimensions (DIM_*)

### DIM_ETUDIANT
> Source : `ETUDIANT` (1 200 lignes)

| Colonne | Type | Remarque |
|---|---|---|
| sk_etudiant | INT (PK) | Surrogate key DW |
| id_etudiant | INT | Natural key source |
| sexe | VARCHAR(1) | M / F |
| ville_origine | VARCHAR(100) | |
| region | VARCHAR(100) | |
| type_bac | VARCHAR(50) | Sciences Math B, etc. |
| mention_bac | VARCHAR(20) | Passable / AB / Bien / TB |
| boursier | BIT | 0/1 |
| statut | VARCHAR(20) | Actif / Diplômé / Abandon |
| filiere | VARCHAR(100) | |
| niveau_actuel | VARCHAR(5) | S1 → S6 |
| annee_inscription | INT | |
| age | INT | pré-calculé dans la source |

---

### DIM_PROFESSEUR
> Source : `PROFESSEUR` (80 lignes)

| Colonne | Type | Remarque |
|---|---|---|
| sk_professeur | INT (PK) | |
| id_professeur | INT | NK |
| grade | VARCHAR(10) | PES / PA / PH |
| sk_departement | INT (FK) | → DIM_DEPARTEMENT |
| specialite | VARCHAR(100) | |
| charge_prevue_h | INT | |
| nb_publications | INT | |
| annee_recrutement | INT | extrait de `date_recrutement` |

---

### DIM_MODULE
> Source : `MODULE` (60 lignes)

| Colonne | Type | Remarque |
|---|---|---|
| sk_module | INT (PK) | |
| id_module | INT | NK |
| nom_module | VARCHAR(100) | |
| filiere | VARCHAR(100) | |
| niveau | VARCHAR(5) | |
| sk_departement | INT (FK) | → DIM_DEPARTEMENT |
| credits_ects | INT | |
| heures_prevues | INT | |

---

### DIM_SALLE
> Source : `SALLE` (40 lignes)

| Colonne | Type | Remarque |
|---|---|---|
| sk_salle | INT (PK) | |
| id_salle | INT | NK |
| nom_salle | VARCHAR(50) | |
| capacite | INT | |
| type | VARCHAR(20) | Amphi / TD / Labo |
| batiment | VARCHAR(50) | |

---

### DIM_STAFF
> Source : `STAFF_ADMINISTRATIF` (30 lignes)

| Colonne | Type | Remarque |
|---|---|---|
| sk_staff | INT (PK) | |
| id_staff | INT | NK |
| role | VARCHAR(50) | |
| sk_departement | INT (FK) | → DIM_DEPARTEMENT |
| annee_recrutement | INT | |

---

### DIM_CLUB
> Source : `CLUB_ASSOCIATION` (15 lignes)

| Colonne | Type | Remarque |
|---|---|---|
| sk_club | INT (PK) | |
| id_club | INT | NK |
| nom_club | VARCHAR(100) | |
| type | VARCHAR(20) | Technique / Culturel / Sportif / Social |
| annee_creation | INT | |

---

### DIM_DEPARTEMENT *(nouvelle)*
> Extrait depuis PROFESSEUR, MODULE, STAFF_ADMINISTRATIF, BUDGET_DEPARTEMENT, FINANCEMENT_EXTERNE
> 6 valeurs distinctes : Informatique, Management, Génie Civil, Electrotechnique, Economie, Juridique

| Colonne | Type | Remarque |
|---|---|---|
| sk_departement | INT (PK) | |
| nom_departement | VARCHAR(100) | clé naturelle |

> Remplace les jointures VARCHAR sur `departement` dans FACT_BUDGET et les dimensions.
> Toutes les requêtes cross-tables par département passent par cette clé INT.

---

### DIM_TEMPS
> Générée synthétiquement à partir de toutes les dates du dataset

| Colonne | Type | Remarque |
|---|---|---|
| sk_date | INT (PK) | format YYYYMMDD — jointure rapide sans conversion |
| date_complete | DATE | |
| jour | INT | 1-31 |
| nom_jour | VARCHAR(10) | Lundi … Dimanche — pour labels Power BI |
| mois | INT | 1-12 |
| nom_mois | VARCHAR(10) | Janvier … Décembre — pour labels Power BI |
| trimestre | INT | 1-4 |
| annee | INT | |
| semestre_univ | VARCHAR(10) | ex: 2023-2024 |
| semaine_iso | VARCHAR(10) | ex: 2023-S42 |

---

### DIM_ANNEE_UNIV *(mini-dimension)*
> Valeurs distinctes de `annee_universitaire` présentes dans les faits

| Colonne | Type | Remarque |
|---|---|---|
| sk_annee | INT (PK) | |
| annee_universitaire | VARCHAR(10) | ex: 2023-2024 |
| annee_debut | INT | |
| annee_fin | INT | |

---

## Tables de Faits (FACT_*)

### FACT_NOTE
> Source : `NOTE` (3 000 lignes) — grain : 1 note par étudiant × module × année

| Colonne | Type | Remarque |
|---|---|---|
| sk_note | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_module | INT (FK) | → DIM_MODULE |
| sk_annee | INT (FK) | → DIM_ANNEE_UNIV |
| note | DECIMAL(4,2) | /20 |
| admis_bool | BIT | |
| session | VARCHAR(20) | Normale / Rattrapage |
| mention | VARCHAR(20) | |

---

### FACT_SEANCE
> Source : `SEANCE_COURS` (2 000 lignes) — grain : 1 séance planifiée

| Colonne | Type | Remarque |
|---|---|---|
| sk_seance | INT (PK) | |
| id_seance | INT | clé dégénérée (NK, pas de FK vers autre fait) |
| sk_module | INT (FK) | → DIM_MODULE |
| sk_professeur | INT (FK) | → DIM_PROFESSEUR |
| sk_salle | INT (FK) | → DIM_SALLE |
| sk_date | INT (FK) | → DIM_TEMPS |
| effectuee | BIT | |
| retard_minutes | INT | |
| nb_etudiants_presents | INT | |
| duree_minutes | INT | pré-calculé dans la source |

---

### FACT_PRESENCE
> Source : `PRESENCE_ETUDIANT` (2 500 lignes) — grain : 1 présence par étudiant × séance
>
> ⚠️ Fix appliqué : `sk_seance` n'est plus une FK vers FACT_SEANCE.
> Les clés de contexte (module, date, salle) sont dénormalisées directement ici
> pour éviter les jointures fact-to-fact qui cassent le star schema.

| Colonne | Type | Remarque |
|---|---|---|
| sk_presence | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| id_seance | INT | clé dégénérée — référence naturelle vers SEANCE_COURS |
| sk_module | INT (FK) | → DIM_MODULE — dénormalisé depuis SEANCE_COURS |
| sk_date | INT (FK) | → DIM_TEMPS — dénormalisé depuis SEANCE_COURS |
| sk_salle | INT (FK) | → DIM_SALLE — dénormalisé depuis SEANCE_COURS |
| present | BIT | |
| justifiee | BIT | |

---

### FACT_SATISFACTION
> Source : `SATISFACTION_ENQUETE` (800 lignes) — grain : 1 enquête par étudiant × prof × module × année

| Colonne | Type | Remarque |
|---|---|---|
| sk_enquete | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_professeur | INT (FK) | → DIM_PROFESSEUR |
| sk_module | INT (FK) | → DIM_MODULE |
| sk_annee | INT (FK) | → DIM_ANNEE_UNIV |
| score_clarte | INT | 1-5 |
| score_disponibilite | INT | |
| score_pedagogie | INT | |
| score_equite | INT | |
| score_admin | INT | |
| score_vie_etudiante | INT | |
| score_charge | INT | |
| score_finances | INT | |
| score_global | DECIMAL(3,2) | pré-calculé |
| score_prof_pondere | DECIMAL(3,2) | pré-calculé |
| nps | INT | 0-10 |

---

### FACT_INSERTION
> Source : `INSERTION_PROFESSIONNELLE` (346 lignes) — grain : 1 diplômé
>
> ⚠️ Fix appliqué : `sk_annee` ajouté pour filtrer par année universitaire sans passer par DIM_TEMPS.

| Colonne | Type | Remarque |
|---|---|---|
| sk_insertion | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_annee | INT (FK) | → DIM_ANNEE_UNIV — dérivé de `date_diplome` |
| sk_date_diplome | INT (FK) | → DIM_TEMPS |
| sk_date_emploi | INT (FK) | → DIM_TEMPS — NULL si pas d'emploi |
| salaire_embauche | DECIMAL(10,2) | MAD |
| secteur | VARCHAR(100) | |
| type_poursuite | VARCHAR(20) | Emploi / Master / Thèse / Rien |
| delai_insertion_jours | INT | calculé : date_emploi - date_diplome |

---

### FACT_FRAIS_SCOLARITE
> Source : `FRAIS_SCOLARITE` (1 989 lignes) — grain : 1 paiement par étudiant × année

| Colonne | Type | Remarque |
|---|---|---|
| sk_frais | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_annee | INT (FK) | → DIM_ANNEE_UNIV |
| sk_date_paiement | INT (FK) | → DIM_TEMPS |
| montant_du | DECIMAL(10,2) | |
| montant_paye | DECIMAL(10,2) | |
| statut | VARCHAR(20) | Payé / Partiel / Impayé |
| taux_recouvrement | DECIMAL(5,4) | pré-calculé |

---

### FACT_DEMANDE_ADMIN
> Source : `DEMANDE_ADMINISTRATIVE` (600 lignes) — grain : 1 demande par étudiant × staff

| Colonne | Type | Remarque |
|---|---|---|
| sk_demande | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_staff | INT (FK) | → DIM_STAFF |
| sk_date_soumission | INT (FK) | → DIM_TEMPS |
| type_demande | VARCHAR(50) | |
| resolu_premier_contact | BIT | |
| satisfaction_service | INT | 1-5 |
| delai_jours | INT | pré-calculé |

---

### FACT_CHARGE_ETUDIANT
> Source : `CHARGE_TEMPS_ETUDIANT` (2 001 lignes) — grain : 1 semaine × étudiant
>
> ⚠️ Fix appliqué : `semaine_iso` supprimé — déjà présent dans DIM_TEMPS via `sk_date`.

| Colonne | Type | Remarque |
|---|---|---|
| sk_charge | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_date | INT (FK) | → DIM_TEMPS (lundi de la semaine) |
| heures_cours | DECIMAL(4,1) | |
| heures_devoirs | DECIMAL(4,1) | |
| heures_projets | DECIMAL(4,1) | |
| heures_temps_mort | DECIMAL(4,1) | |
| charge_totale | DECIMAL(5,1) | |

---

### FACT_BUDGET
> Source : `BUDGET_DEPARTEMENT` (72 lignes) + `FINANCEMENT_EXTERNE` (100 lignes)
>
> ⚠️ Fix appliqué : `departement` VARCHAR remplacé par `sk_departement` INT → DIM_DEPARTEMENT.

| Colonne | Type | Remarque |
|---|---|---|
| sk_budget | INT (PK) | |
| sk_departement | INT (FK) | → DIM_DEPARTEMENT |
| annee | INT | |
| budget_prevu | DECIMAL(12,2) | |
| budget_execute | DECIMAL(12,2) | |
| type_depense | VARCHAR(50) | |
| taux_execution | DECIMAL(5,4) | pré-calculé |
| financement_externe | DECIMAL(12,2) | agrégé depuis FINANCEMENT_EXTERNE |

---

### FACT_VIE_ETUDIANTE *(summary — ne remplace pas les détails)*
> Sources : `PARTICIPATION_CLUB`, `AIDE_SOCIALE`, `SIGNALEMENT_DISCIPLINAIRE`, `MOBILITE_INTERNATIONALE`, `VISITE_SANTE`
> Grain : 1 étudiant × année universitaire
>
> ⚠️ Fix appliqué : cette table est une vue agrégée pour le dashboard Page 7.
> Les tables de détail ci-dessous sont conservées séparément pour le drill-down.

| Colonne | Type | Source |
|---|---|---|
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_annee | INT (FK) | → DIM_ANNEE_UNIV |
| nb_clubs | INT | PARTICIPATION_CLUB |
| aide_accordee | BIT | AIDE_SOCIALE |
| montant_aide | DECIMAL(10,2) | AIDE_SOCIALE |
| nb_signalements | INT | SIGNALEMENT_DISCIPLINAIRE |
| en_mobilite | BIT | MOBILITE_INTERNATIONALE |
| nb_visites_sante | INT | VISITE_SANTE |

---

### FACT_PARTICIPATION_CLUB *(détail)*
> Source : `PARTICIPATION_CLUB` (754 lignes) — grain : 1 participation par étudiant × club × année

| Colonne | Type | Remarque |
|---|---|---|
| sk_participation | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_club | INT (FK) | → DIM_CLUB |
| sk_annee | INT (FK) | → DIM_ANNEE_UNIV |
| role | VARCHAR(30) | Membre / Président / Vice-Président |

---

### FACT_AIDE_SOCIALE *(détail)*
> Source : `AIDE_SOCIALE` (250 lignes) — grain : 1 demande d'aide par étudiant

| Colonne | Type | Remarque |
|---|---|---|
| sk_aide | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_date_demande | INT (FK) | → DIM_TEMPS |
| type_aide | VARCHAR(50) | |
| statut | VARCHAR(20) | Accordée / Refusée / En cours |
| montant_mad | DECIMAL(10,2) | |

---

### FACT_SIGNALEMENT *(détail)*
> Source : `SIGNALEMENT_DISCIPLINAIRE` (150 lignes) — grain : 1 signalement par étudiant

| Colonne | Type | Remarque |
|---|---|---|
| sk_signalement | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_date | INT (FK) | → DIM_TEMPS |
| type | VARCHAR(50) | |
| gravite | VARCHAR(20) | Mineure / Majeure |
| statut | VARCHAR(20) | Traité / En cours |

---

### FACT_MOBILITE *(détail)*
> Source : `MOBILITE_INTERNATIONALE` (180 lignes) — grain : 1 mobilité par étudiant

| Colonne | Type | Remarque |
|---|---|---|
| sk_mobilite | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_date_debut | INT (FK) | → DIM_TEMPS |
| sk_date_fin | INT (FK) | → DIM_TEMPS |
| type | VARCHAR(20) | Sortant / Entrant |
| pays_destination | VARCHAR(100) | |
| universite_partenaire | VARCHAR(200) | |
| programme | VARCHAR(50) | Erasmus+, etc. |

---

### FACT_VISITE_SANTE *(détail)*
> Source : `VISITE_SANTE` (300 lignes) — grain : 1 visite par étudiant

| Colonne | Type | Remarque |
|---|---|---|
| sk_visite | INT (PK) | |
| sk_etudiant | INT (FK) | → DIM_ETUDIANT |
| sk_date | INT (FK) | → DIM_TEMPS |
| type_service | VARCHAR(50) | Médecin / Psychologue / Soutien scolaire |
| motif | VARCHAR(100) | |

---

## Tables de configuration (inchangées)

| Table | Lignes | Rôle |
|---|---|---|
| `POIDS_LEVIER_SATISFACTION` | 5 | Poids des leviers pour score global (Page 9) |
| `SEUIL_ALERTE` | 7 | Seuils KPI pour alertes dashboard (Page 9) |
| `KPIs_Synthese` | 22 | Valeurs de référence des KPIs par page |

---

## Schéma global

```
                              DIM_TEMPS
                                  │
DIM_DEPARTEMENT ──┬── DIM_PROFESSEUR ──┬── FACT_SEANCE ──── DIM_SALLE
                  ├── DIM_MODULE       │       │
                  ├── DIM_STAFF        │       │ (id_seance dégénéré)
                  └── FACT_BUDGET      │       ▼
                                       │   FACT_PRESENCE ── DIM_ETUDIANT
                                       │
DIM_ETUDIANT ──────────────────────────┼── FACT_NOTE ──────── DIM_MODULE
                                       ├── FACT_SATISFACTION ─ DIM_MODULE
                                       ├── FACT_INSERTION
                                       ├── FACT_FRAIS_SCOLARITE
                                       ├── FACT_DEMANDE_ADMIN ── DIM_STAFF
                                       ├── FACT_CHARGE_ETUDIANT
                                       ├── FACT_VIE_ETUDIANTE (summary)
                                       ├── FACT_PARTICIPATION_CLUB ── DIM_CLUB
                                       ├── FACT_AIDE_SOCIALE
                                       ├── FACT_SIGNALEMENT
                                       ├── FACT_MOBILITE
                                       └── FACT_VISITE_SANTE

Toutes les FACT_* avec sk_annee → DIM_ANNEE_UNIV
```

---

## Fixes appliqués (résumé)

| # | Problème | Fix |
|---|---|---|
| 1 | FACT_PRESENCE → FK vers FACT_SEANCE | `sk_seance` remplacé par `id_seance` dégénéré + `sk_module`, `sk_date`, `sk_salle` dénormalisés |
| 2 | FACT_BUDGET jointure par VARCHAR `departement` | `sk_departement` INT → nouvelle `DIM_DEPARTEMENT` |
| 3 | FACT_VIE_ETUDIANTE écrasait le détail | Conservée comme summary + 5 tables de détail séparées |
| 4 | FACT_INSERTION sans `sk_annee` | `sk_annee → DIM_ANNEE_UNIV` ajouté |
| 5 | DIM_TEMPS sans labels texte | `nom_jour` et `nom_mois` ajoutés |
| 6 | `semaine_iso` dupliqué dans FACT_CHARGE | Supprimé — lu depuis DIM_TEMPS |

---

## Couverture Dashboard → DW

| Page | Tables DW utilisées |
|---|---|
| Page 0 — Executive Summary | Toutes les FACT_* (agrégats) |
| Page 1 — Inscriptions & Effectifs | DIM_ETUDIANT, DIM_ANNEE_UNIV |
| Page 2 — Performance académique | FACT_NOTE, DIM_MODULE, DIM_ETUDIANT |
| Page 3 — Diplômation & Insertion | FACT_INSERTION, DIM_ETUDIANT, DIM_ANNEE_UNIV |
| Page 4 — Professeurs | DIM_PROFESSEUR, FACT_SEANCE, FACT_SATISFACTION, DIM_DEPARTEMENT |
| Page 5 — Administration & Staff | DIM_STAFF, FACT_DEMANDE_ADMIN, DIM_DEPARTEMENT |
| Page 6 — Charge temporelle | FACT_CHARGE_ETUDIANT, FACT_SEANCE, DIM_TEMPS |
| Page 7 — Vie étudiante & Bien-être | FACT_VIE_ETUDIANTE, FACT_PARTICIPATION_CLUB, FACT_AIDE_SOCIALE, FACT_SIGNALEMENT, FACT_MOBILITE, FACT_VISITE_SANTE, FACT_PRESENCE |
| Page 8 — Finance & Dépenses | FACT_FRAIS_SCOLARITE, FACT_BUDGET, DIM_DEPARTEMENT |
| Page 9 — Satisfaction globale | FACT_SATISFACTION, POIDS_LEVIER_SATISFACTION, SEUIL_ALERTE |
