# Tables Schema of Marts

Voici le détail complet colonne par colonne pour chaque mart.

---

**MART_INSCRIPTIONS**

```
dim_etudiant
  id_etudiant, nom, prenom, sexe, date_naissance,
  ville_origine, region, type_bac, mention_bac,
  boursier, date_inscription, statut, filiere, niveau_actuel

dim_date
  id_date, date_complete, jour, semaine, mois,
  trimestre, annee, annee_universitaire

fact_inscription
  id_inscription, id_etudiant, id_date,
  annee_universitaire, type, filiere, niveau
```

---

**MART_PERFORMANCE_ACADEMIQUE**

```
dim_etudiant
  id_etudiant, nom, prenom, filiere, niveau_actuel, statut

dim_module
  id_module, nom_module, filiere, niveau,
  departement, credits_ects, heures_prevues

dim_date
  id_date, annee_universitaire, semestre

fact_note
  id_note, id_etudiant, id_module, id_date,
  note, mention, session, resultat,
  annee_universitaire,
  taux_reussite_module (calculé dbt),
  taux_echec_module (calculé dbt),
  is_module_a_risque (calculé dbt — true si échec > 30%)
```

---

**MART_DIPLOMATION_INSERTION**

```
dim_etudiant
  id_etudiant, nom, prenom, filiere, boursier, region

dim_date
  id_date, annee, annee_universitaire

fact_insertion
  id_insertion, id_etudiant, id_date_diplome,
  date_diplome, date_fin_etudes, date_premier_emploi,
  salaire_embauche, secteur, type_poursuite,
  delai_insertion_jours (calculé dbt),
  duree_etudes_mois (calculé dbt),
  is_emploi_6mois (calculé dbt — true si délai <= 180j)
```

---

**MART_PROFESSEURS**

```
dim_professeur
  id_professeur, nom, prenom, grade,
  departement, specialite, charge_prevue_h, nb_publications

dim_module
  id_module, nom_module, filiere, niveau, credits_ects

dim_salle
  id_salle, nom_salle, capacite, type, batiment

dim_date
  id_date, date_complete, semaine, mois, annee_universitaire

fact_seance_cours
  id_seance, id_module, id_professeur, id_salle, id_date,
  heure_debut, heure_fin, effectuee, retard_minutes,
  nb_etudiants_presents,
  duree_seance_h (calculé dbt),
  taux_occupation_salle (calculé dbt — nb_presents / capacite),
  is_en_retard (calculé dbt — true si retard > 0)

fact_devoir
  id_devoir, id_module, id_professeur, id_date,
  type, date_donne, date_rendu, duree_estimee_h

fact_satisfaction_prof
  id_enquete, id_professeur, id_module, id_date,
  score_clarte, poids_clarte,
  score_disponibilite, poids_disponibilite,
  score_pedagogie, poids_pedagogie,
  score_equite, poids_equite,
  score_satisfaction_prof (calculé dbt — moyenne pondérée des 4 critères)
```

---

**MART_ADMINISTRATION**

```
dim_staff
  id_staff, nom, prenom, role, departement, date_recrutement

dim_etudiant
  id_etudiant, nom, prenom, filiere, niveau_actuel

dim_date
  id_date, date_complete, mois, annee_universitaire

fact_demande_admin
  id_demande, id_etudiant, id_staff, id_date,
  type_demande, date_soumission, date_resolution,
  resolu_premier_contact, satisfaction_service,
  delai_traitement_jours (calculé dbt)

fact_accueil_staff
  id_accueil, id_etudiant, id_staff, id_date,
  heure_debut, heure_fin, initie_par, motif,
  duree_accueil_minutes (calculé dbt),
  is_initie_staff (calculé dbt — true si initié par staff)
```

---

**MART_CHARGE_TEMPORELLE**

```
dim_etudiant
  id_etudiant, nom, prenom, filiere, niveau_actuel

dim_module
  id_module, nom_module, filiere, niveau

dim_date
  id_date, semaine, mois, annee_universitaire

fact_charge_temps
  id_charge, id_etudiant, id_date,
  semaine, heures_cours, heures_devoirs,
  heures_projets, heures_temps_mort, charge_totale,
  ratio_cours_travail_perso (calculé dbt),
  is_surcharge (calculé dbt — true si charge_totale > seuil)

fact_seance_cours
  id_seance, id_module, id_date,
  heure_debut, heure_fin, duree_seance_h,
  heures_temps_mort_avant (calculé dbt)

fact_devoir
  id_devoir, id_module, id_date,
  type, duree_estimee_h
```

---

**MART_VIE_ETUDIANTE**

```
dim_etudiant
  id_etudiant, nom, prenom, filiere, niveau_actuel, boursier

dim_club
  id_club, nom_club, type, date_creation

dim_date
  id_date, semaine, mois, annee_universitaire

fact_presence
  id_presence, id_etudiant, id_seance, id_date,
  present, justifiee,
  is_absence_injustifiee (calculé dbt)

fact_participation
  id_participation, id_etudiant, id_club, id_date,
  annee_universitaire, role

fact_aide_sociale
  id_aide, id_etudiant, id_date,
  type_aide, statut, montant_mad,
  delai_traitement_jours (calculé dbt)

fact_signalement
  id_signalement, id_etudiant, id_date,
  type, gravite, statut

fact_mobilite
  id_mobilite, id_etudiant, id_date_debut,
  type, pays_destination, universite_partenaire,
  programme, date_debut, date_fin,
  duree_mobilite_jours (calculé dbt)

fact_visite_sante
  id_visite, id_etudiant, id_date,
  type_service, motif
```

---

**MART_FINANCE**

```
dim_etudiant
  id_etudiant, nom, prenom, filiere, boursier, statut

dim_date
  id_date, mois, trimestre, annee, annee_universitaire

fact_frais_scolarite
  id_frais, id_etudiant, id_date,
  montant_du, montant_paye, statut,
  montant_impaye (calculé dbt — montant_du - montant_paye),
  taux_recouvrement (calculé dbt — montant_paye / montant_du)

fact_budget
  id_budget, departement, id_date,
  budget_prevu, budget_execute, type_depense,
  ecart_budget (calculé dbt — budget_prevu - budget_execute),
  taux_execution (calculé dbt — budget_execute / budget_prevu)

fact_financement
  id_financement, id_date,
  source, type, montant_mad, departement_beneficiaire
```

---

**MART_SATISFACTION**

```
dim_etudiant
  id_etudiant, nom, prenom, filiere, niveau_actuel

dim_professeur
  id_professeur, nom, prenom, departement

dim_module
  id_module, nom_module, filiere, niveau

dim_date
  id_date, mois, annee_universitaire

fact_satisfaction
  id_enquete, id_etudiant, id_professeur, id_module, id_date,
  score_clarte, poids_clarte,
  score_disponibilite, poids_disponibilite,
  score_pedagogie, poids_pedagogie,
  score_equite, poids_equite,
  score_admin, score_vie_etudiante,
  score_charge, score_finances,
  score_global, nps,
  score_prof_pondere (calculé dbt),
  score_global_pondere (calculé dbt)

ref_poids_levier
  id_poids, annee_universitaire, levier, poids

ref_seuil_alerte
  id_seuil, kpi, seuil_alerte, niveau, message
```

---

**MART_EXECUTIVE**

```
kpi_summary
  annee_universitaire,
  satisfaction_globale_ponderee  (depuis MART_SATISFACTION),
  taux_diplomation               (depuis MART_DIPLOMATION_INSERTION),
  taux_retention                 (depuis MART_INSCRIPTIONS),
  taux_occupation_salles         (depuis MART_PROFESSEURS),
  budget_execute_total           (depuis MART_FINANCE),
  nps_etudiant                   (depuis MART_SATISFACTION),
  taux_emploi_6mois              (depuis MART_DIPLOMATION_INSERTION)
```

---

Les colonnes marquées **calculé dbt** sont des métriques que vous n'avez pas dans vos CSV bruts — dbt les calcule en SQL lors de la transformation. Voulez-vous qu'on commence à écrire les modèles dbt pour un mart en particulier ?
