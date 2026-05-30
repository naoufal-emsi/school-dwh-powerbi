{{ config(materialized='table', schema='MART_PROFESSEURS') }}
select id_devoir, id_module, id_professeur, date_donne, date_rendu, type_devoir, duree_estimee_h
from {{ ref('stg_devoir') }}
