{{ config(materialized='table', schema='MART_PROFESSEURS') }}
select id_professeur, nom, prenom, grade, departement, specialite, charge_prevue_h, nb_publications, annee_recrutement
from {{ ref('stg_professeur') }}
