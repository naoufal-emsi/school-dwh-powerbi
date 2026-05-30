{{ config(materialized='table', schema='MART_SATISFACTION') }}
select id_professeur, nom, prenom, departement
from {{ ref('stg_professeur') }}
