{{ config(materialized='table', schema='MART_SATISFACTION') }}
select id_module, nom_module, filiere, niveau
from {{ ref('stg_module') }}
