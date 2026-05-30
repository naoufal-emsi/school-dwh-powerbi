{{ config(materialized='table', schema='MART_PERFORMANCE_ACADEMIQUE') }}
select id_etudiant, nom, prenom, filiere, niveau_actuel, statut
from {{ ref('stg_etudiant') }}
