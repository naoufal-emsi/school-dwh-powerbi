{{ config(materialized='table', schema='MART_CHARGE_TEMPORELLE') }}
select id_charge, id_etudiant, semaine, heures_cours, heures_devoirs, heures_projets,
       heures_temps_mort, charge_totale, ratio_cours_travail_perso, is_surcharge
from {{ ref('stg_charge_temps_etudiant') }}
