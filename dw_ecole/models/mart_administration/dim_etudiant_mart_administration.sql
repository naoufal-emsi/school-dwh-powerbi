{{ config(materialized='table', schema='MART_ADMINISTRATION') }}
select id_etudiant, nom, prenom, filiere, niveau_actuel
from {{ ref('stg_etudiant') }}
