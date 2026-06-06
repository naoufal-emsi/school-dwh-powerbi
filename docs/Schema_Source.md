# Schéma Source — Données Opérationnelles de l'École

> Ces tables représentent les données brutes collectées au quotidien par l'école.  
> Elles servent de **source** pour alimenter le Data Warehouse et générer le Dashboard Power BI.

---

## 1. ETUDIANT

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_etudiant | Entier | 1001 | Identifiant unique de l'étudiant |
| nom | Texte | Alaoui | Nom de famille |
| prenom | Texte | Yassine | Prénom |
| sexe | Texte | M / F | Genre |
| date_naissance | Date | 2001-05-14 | Date de naissance |
| ville_origine | Texte | Casablanca | Ville d'origine |
| region | Texte | Casablanca-Settat | Région d'origine |
| type_bac | Texte | Sciences Math B | Filière du baccalauréat |
| mention_bac | Texte | Bien | Mention obtenue au bac |
| boursier | Oui/Non | Oui | Bénéficie d'une bourse |
| date_inscription | Date | 2022-09-01 | Date de première inscription |
| statut | Texte | Actif | Actif / Diplômé / Abandon |
| filiere | Texte | Génie Informatique | Filière actuelle |
| niveau_actuel | Texte | S4 | Semestre actuel |

---

## 2. INSCRIPTION

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_inscription | Entier | 2001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| annee_universitaire | Texte | 2023-2024 | Année universitaire |
| type | Texte | Nouveau | Nouveau / Réinscrit |
| date_inscription | Date | 2023-09-01 | Date d'inscription |
| filiere | Texte | Génie Informatique | Filière inscrite |
| niveau | Texte | S3 | Semestre inscrit |

---

## 3. MODULE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_module | Entier | 301 | Identifiant unique du module |
| nom_module | Texte | Bases de Données | Nom du module |
| filiere | Texte | Génie Informatique | Filière concernée |
| niveau | Texte | S3 | Semestre du module |
| departement | Texte | Informatique | Département responsable |
| credits_ects | Entier | 4 | Nombre de crédits |
| heures_prevues | Entier | 30 | Volume horaire prévu |
| id_professeur | Entier | 401 | Référence vers PROFESSEUR |

---

## 4. NOTE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_note | Entier | 5001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| id_module | Entier | 301 | Référence vers MODULE |
| annee_universitaire | Texte | 2023-2024 | Année universitaire |
| note | Décimal | 14.5 | Note sur 20 |
| mention | Texte | Bien | Passable / AB / Bien / TB |
| session | Texte | Normale | Normale / Rattrapage |
| resultat | Texte | Admis | Admis / Échec |

---

## 5. PRESENCE_ETUDIANT

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_presence | Entier | 6001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| id_seance | Entier | 7001 | Référence vers SEANCE_COURS (permet de retrouver la salle et le module) |
| present | Oui/Non | Oui | L'étudiant était-il présent |
| justifiee | Oui/Non | Non | Absence justifiée ou non (utile pour taux d'absentéisme Page 7) |

---

## 6. PROFESSEUR

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_professeur | Entier | 401 | Identifiant unique |
| nom | Texte | Benali | Nom de famille |
| prenom | Texte | Karim | Prénom |
| grade | Texte | PES | PES / PA / PH |
| departement | Texte | Informatique | Département d'appartenance |
| specialite | Texte | Intelligence Artificielle | Domaine de spécialité |
| charge_prevue_h | Entier | 192 | Heures d'enseignement prévues par an |
| nb_publications | Entier | 5 | Nombre de publications scientifiques |
| date_recrutement | Date | 2015-09-01 | Date de recrutement |

---

## 7. SEANCE_COURS

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_seance | Entier | 7001 | Identifiant unique |
| id_module | Entier | 301 | Référence vers MODULE |
| id_professeur | Entier | 401 | Référence vers PROFESSEUR |
| id_salle | Entier | 501 | Référence vers SALLE |
| date_seance | Date | 2023-10-12 | Date de la séance |
| heure_debut | Heure | 08:30 | Heure de début |
| heure_fin | Heure | 10:30 | Heure de fin |
| effectuee | Oui/Non | Oui | La séance a-t-elle eu lieu |
| retard_minutes | Entier | 10 | Retard du professeur en minutes |
| nb_etudiants_presents | Entier | 35 | Nombre d'étudiants présents (pour taux occupation salle) |

---

## 8. SALLE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_salle | Entier | 501 | Identifiant unique |
| nom_salle | Texte | Amphi A | Nom de la salle |
| capacite | Entier | 120 | Nombre de places |
| type | Texte | Amphi | Amphi / TD / Labo |
| batiment | Texte | Bâtiment 2 | Bâtiment où se trouve la salle |

---

## 9. DEVOIR

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_devoir | Entier | 8001 | Identifiant unique |
| id_module | Entier | 301 | Référence vers MODULE |
| id_professeur | Entier | 401 | Référence vers PROFESSEUR |
| date_donne | Date | 2023-10-15 | Date à laquelle le devoir a été donné |
| date_rendu | Date | 2023-10-22 | Date limite de rendu |
| type | Texte | TP | DS / TP / Projet |
| duree_estimee_h | Décimal | 3.5 | Durée estimée de travail en heures |

---

## 10. SATISFACTION_ENQUETE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_enquete | Entier | 9001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| id_professeur | Entier | 401 | Référence vers PROFESSEUR |
| id_module | Entier | 301 | Référence vers MODULE |
| annee_universitaire | Texte | 2023-2024 | Année universitaire |
| score_clarte | Entier | 4 | Clarté du cours (1-5) |
| poids_clarte | Décimal | 0.30 | Poids donné par l'étudiant à ce critère (somme des 4 poids = 1) |
| score_disponibilite | Entier | 3 | Disponibilité du prof (1-5) |
| poids_disponibilite | Décimal | 0.20 | Poids donné par l'étudiant à ce critère |
| score_pedagogie | Entier | 4 | Qualité pédagogique (1-5) |
| poids_pedagogie | Décimal | 0.30 | Poids donné par l'étudiant à ce critère |
| score_equite | Entier | 5 | Équité dans la notation (1-5) |
| poids_equite | Décimal | 0.20 | Poids donné par l'étudiant à ce critère |
| score_admin | Entier | 3 | Satisfaction service administratif (1-5) |
| score_vie_etudiante | Entier | 4 | Satisfaction vie étudiante (1-5) |
| score_charge | Entier | 3 | Satisfaction charge de travail (1-5) |
| score_finances | Entier | 4 | Satisfaction frais et services financiers (1-5) |
| score_global | Décimal | 3.8 | Score global calculé (1-5) |
| nps | Entier | 7 | Note de recommandation (0-10) |

---

## 11. INSERTION_PROFESSIONNELLE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_insertion | Entier | 10001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| date_diplome | Date | 2023-07-01 | Date d'obtention du diplôme |
| date_fin_etudes | Date | 2023-07-01 | Date de fin effective des études (pour durée moyenne) |
| date_premier_emploi | Date | 2023-12-01 | Date du premier emploi |
| salaire_embauche | Décimal | 8500 | Salaire mensuel brut en MAD |
| secteur | Texte | Finance | Secteur d'activité |
| type_poursuite | Texte | Emploi | Emploi / Master / Thèse / Rien |

---

## 12. DEMANDE_ADMINISTRATIVE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_demande | Entier | 11001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| id_staff | Entier | 601 | Référence vers STAFF_ADMINISTRATIF |
| type_demande | Texte | Attestation | Type de demande |
| date_soumission | Date | 2023-11-05 | Date de dépôt de la demande |
| date_resolution | Date | 2023-11-07 | Date de résolution |
| resolu_premier_contact | Oui/Non | Oui | Résolu dès le premier contact |
| satisfaction_service | Entier | 4 | Satisfaction du service (1-5) |

---

## 13. BUDGET_DEPARTEMENT

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_budget | Entier | 12001 | Identifiant unique |
| departement | Texte | Informatique | Département concerné |
| annee | Entier | 2024 | Année budgétaire |
| budget_prevu | Décimal | 500000 | Budget alloué en MAD |
| budget_execute | Décimal | 470000 | Budget réellement dépensé en MAD |
| type_depense | Texte | Équipement | Salaires / Équipement / Fonctionnement |

---

## 14. FRAIS_SCOLARITE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_frais | Entier | 13001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| annee_universitaire | Texte | 2023-2024 | Année universitaire |
| montant_du | Décimal | 20000 | Montant total dû en MAD |
| montant_paye | Décimal | 20000 | Montant effectivement payé en MAD |
| date_paiement | Date | 2023-09-15 | Date du paiement |
| statut | Texte | Payé | Payé / Partiel / Impayé |

---

## 15. STAFF_ADMINISTRATIF

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_staff | Entier | 601 | Identifiant unique |
| nom | Texte | Chraibi | Nom de famille |
| prenom | Texte | Sara | Prénom |
| role | Texte | Scolarité | Rôle dans l'administration |
| departement | Texte | Scolarité | Département d'affectation |
| date_recrutement | Date | 2018-01-01 | Date de recrutement |

---

## 16. ACCUEIL_STAFF

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_accueil | Entier | 14001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| id_staff | Entier | 601 | Référence vers STAFF_ADMINISTRATIF |
| date_accueil | Date | 2023-11-10 | Date de l'accueil |
| heure_debut | Heure | 09:00 | Heure de début de l'accueil |
| heure_fin | Heure | 09:15 | Heure de fin de l'accueil |
| initie_par | Texte | Étudiant | Étudiant / Staff |
| motif | Texte | Attestation | Motif de la visite |

---

## 17. CHARGE_TEMPS_ETUDIANT

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_charge | Entier | 15001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| semaine | Texte | 2023-S42 | Semaine concernée (année-numéro) |
| heures_cours | Décimal | 18.0 | Heures de cours suivies cette semaine |
| heures_devoirs | Décimal | 6.5 | Heures consacrées aux devoirs |
| heures_projets | Décimal | 4.0 | Heures consacrées aux projets |
| heures_temps_mort | Décimal | 3.0 | Heures creuses entre séances |
| charge_totale | Décimal | 31.5 | Total heures de travail estimé |

---

## 18. CLUB_ASSOCIATION

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_club | Entier | 16001 | Identifiant unique |
| nom_club | Texte | Club Robotique | Nom du club |
| type | Texte | Technique | Technique / Culturel / Sportif / Social |
| date_creation | Date | 2019-01-01 | Date de création du club |

---

## 19. PARTICIPATION_CLUB

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_participation | Entier | 17001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| id_club | Entier | 16001 | Référence vers CLUB_ASSOCIATION |
| annee_universitaire | Texte | 2023-2024 | Année universitaire |
| role | Texte | Membre | Membre / Président / Vice-Président |

---

## 20. AIDE_SOCIALE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_aide | Entier | 18001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| type_aide | Texte | Bourse urgence | Type d'aide demandée |
| date_demande | Date | 2023-10-20 | Date de la demande |
| date_traitement | Date | 2023-10-25 | Date de traitement du dossier |
| statut | Texte | Accordée | Accordée / Refusée / En cours |
| montant_mad | Décimal | 1500 | Montant accordé en MAD |

---

## 21. SIGNALEMENT_DISCIPLINAIRE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_signalement | Entier | 19001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| date_signalement | Date | 2023-11-01 | Date du signalement |
| type | Texte | Absence injustifiée | Type de manquement |
| gravite | Texte | Mineure | Mineure / Majeure |
| statut | Texte | Traité | Traité / En cours |

---

## 22. MOBILITE_INTERNATIONALE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_mobilite | Entier | 20001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| type | Texte | Sortant | Sortant / Entrant |
| pays_destination | Texte | France | Pays de destination ou d'origine |
| universite_partenaire | Texte | Université Paris-Saclay | Établissement partenaire |
| date_debut | Date | 2024-01-15 | Début de la mobilité |
| date_fin | Date | 2024-06-30 | Fin de la mobilité |
| programme | Texte | Erasmus+ | Programme de mobilité |

---

## 23. VISITE_SANTE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_visite | Entier | 21001 | Identifiant unique |
| id_etudiant | Entier | 1001 | Référence vers ETUDIANT |
| date_visite | Date | 2023-12-05 | Date de la consultation |
| type_service | Texte | Médecin | Médecin / Psychologue / Soutien scolaire |
| motif | Texte | Stress | Motif de la consultation |

---

## 24. FINANCEMENT_EXTERNE

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_financement | Entier | 22001 | Identifiant unique |
| source | Texte | OCP Group | Nom du financeur |
| type | Texte | Partenariat | Subvention / Partenariat / Don |
| annee | Entier | 2024 | Année du financement |
| montant_mad | Décimal | 200000 | Montant reçu en MAD |
| departement_beneficiaire | Texte | Informatique | Département bénéficiaire |

---

## 25. POIDS_LEVIER_SATISFACTION

> Définit le poids de chaque levier dans le score de satisfaction global — nécessaire pour la Page 9

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_poids | Entier | 1 | Identifiant unique |
| annee_universitaire | Texte | 2023-2024 | Année universitaire concernée |
| levier | Texte | Professeurs | Professeurs / Admin / Charge / Vie étudiante / Finances |
| poids | Décimal | 0.30 | Poids du levier dans le score global (somme = 1) |

---

## 26. SEUIL_ALERTE

> Seuils de déclenchement des alertes automatiques du dashboard — nécessaire pour la Page 9

| Colonne | Type | Exemple | Description |
|---|---|---|---|
| id_seuil | Entier | 1 | Identifiant unique |
| kpi | Texte | taux_echec_module | Nom du KPI surveillé |
| seuil_alerte | Décimal | 0.30 | Valeur déclenchant une alerte (ex: 30% d'échec) |
| niveau | Texte | Critique | Info / Avertissement / Critique |
| message | Texte | Module à risque détecté | Message affiché dans le dashboard |

---

## Relations entre les tables

```
ETUDIANT ──────────── INSCRIPTION
ETUDIANT ──────────── NOTE ──────────────────────── MODULE ──── PROFESSEUR
ETUDIANT ──────────── PRESENCE_ETUDIANT ─────────── SEANCE_COURS ── SALLE
ETUDIANT ──────────── SATISFACTION_ENQUETE ─────── PROFESSEUR
ETUDIANT ──────────── INSERTION_PROFESSIONNELLE
ETUDIANT ──────────── DEMANDE_ADMINISTRATIVE ────── STAFF_ADMINISTRATIF
ETUDIANT ──────────── FRAIS_SCOLARITE
ETUDIANT ──────────── CHARGE_TEMPS_ETUDIANT
ETUDIANT ──────────── PARTICIPATION_CLUB ─────────── CLUB_ASSOCIATION
ETUDIANT ──────────── AIDE_SOCIALE
ETUDIANT ──────────── SIGNALEMENT_DISCIPLINAIRE
ETUDIANT ──────────── MOBILITE_INTERNATIONALE
ETUDIANT ──────────── VISITE_SANTE
ETUDIANT ──────────── ACCUEIL_STAFF ─────────────── STAFF_ADMINISTRATIF
PROFESSEUR ─────────── SEANCE_COURS ──────────────── SALLE
PROFESSEUR ─────────── DEVOIR ───────────────────── MODULE
BUDGET_DEPARTEMENT ─── (lié par nom departement)
FINANCEMENT_EXTERNE ── (lié par nom departement)
POIDS_LEVIER_SATISFACTION (table de configuration globale)
SEUIL_ALERTE          (table de configuration globale)
```

---

## Résumé — Couverture par page du Dashboard

| Page Dashboard | Tables source utilisées |
|---|---|
| Page 0 — Executive Summary | Toutes les tables (agrégats) |
| Page 1 — Inscriptions & Effectifs | ETUDIANT, INSCRIPTION |
| Page 2 — Performance académique | NOTE, MODULE, ETUDIANT |
| Page 3 — Diplômation & Insertion | INSERTION_PROFESSIONNELLE, INSCRIPTION |
| Page 4 — Professeurs | PROFESSEUR, SEANCE_COURS, DEVOIR, SATISFACTION_ENQUETE |
| Page 5 — Administration & Staff | STAFF_ADMINISTRATIF, ACCUEIL_STAFF, DEMANDE_ADMINISTRATIVE |
| Page 6 — Charge temporelle | CHARGE_TEMPS_ETUDIANT, SEANCE_COURS, DEVOIR, NOTE |
| Page 7 — Vie étudiante & Bien-être | PRESENCE_ETUDIANT, PARTICIPATION_CLUB, AIDE_SOCIALE, SIGNALEMENT_DISCIPLINAIRE, MOBILITE_INTERNATIONALE, VISITE_SANTE |
| Page 8 — Finance & Dépenses | FRAIS_SCOLARITE, BUDGET_DEPARTEMENT, FINANCEMENT_EXTERNE |
| Page 9 — Satisfaction globale | SATISFACTION_ENQUETE, POIDS_LEVIER_SATISFACTION, SEUIL_ALERTE, toutes les tables |
