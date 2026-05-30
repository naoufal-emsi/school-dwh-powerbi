{{ config(materialized='table', schema='MART_CHARGE_TEMPORELLE') }}
select id_module, nom_module, filiere, niveau
from {{ ref('stg_module') }}
