{{ config(materialized='table', schema='MART_CHARGE_TEMPORELLE') }}
select id_etudiant, nom, prenom, filiere, niveau_actuel
from {{ ref('stg_etudiant') }}
