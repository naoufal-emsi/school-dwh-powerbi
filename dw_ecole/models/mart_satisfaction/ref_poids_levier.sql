{{ config(materialized='table', schema='MART_SATISFACTION') }}
select id_poids, annee_universitaire, levier, poids
from {{ ref('stg_poids_levier') }}
