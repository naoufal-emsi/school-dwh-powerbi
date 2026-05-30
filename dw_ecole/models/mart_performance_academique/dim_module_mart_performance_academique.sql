{{ config(materialized='table', schema='MART_PERFORMANCE_ACADEMIQUE') }}
select id_module, nom_module, filiere, niveau, departement, credits_ects, heures_prevues
from {{ ref('stg_module') }}
