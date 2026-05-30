{{ config(materialized='table', schema='MART_DIPLOMATION_INSERTION') }}
select id_etudiant, nom, prenom, filiere, boursier, region
from {{ ref('stg_etudiant') }}
