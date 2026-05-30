{{ config(materialized='table', schema='MART_ADMINISTRATION') }}
select id_demande, id_etudiant, id_staff, date_soumission, type_demande,
       date_resolution, resolu_premier_contact, satisfaction_service, delai_traitement_jours
from {{ ref('stg_demande_administrative') }}
