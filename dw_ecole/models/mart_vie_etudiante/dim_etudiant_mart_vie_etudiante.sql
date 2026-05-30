{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_etudiant, nom, prenom, filiere, niveau_actuel, boursier
from {{ ref('stg_etudiant') }}
