{{ config(materialized='table', schema='MART_PROFESSEURS') }}
select id_salle, nom_salle, capacite, type_salle, batiment
from {{ ref('stg_salle') }}
