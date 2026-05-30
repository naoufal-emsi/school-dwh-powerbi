{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_participation, id_etudiant, id_club, annee_universitaire, role
from {{ ref('stg_participation_club') }}
