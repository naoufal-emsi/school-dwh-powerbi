{{ config(materialized='table', schema='MART_FINANCE') }}
select id_etudiant, nom, prenom, filiere, boursier, statut
from {{ ref('stg_etudiant') }}
