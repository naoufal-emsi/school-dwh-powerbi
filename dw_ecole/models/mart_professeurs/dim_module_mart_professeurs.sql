{{ config(materialized='table', schema='MART_PROFESSEURS') }}
select id_module, nom_module, filiere, niveau, credits_ects
from {{ ref('stg_module') }}
