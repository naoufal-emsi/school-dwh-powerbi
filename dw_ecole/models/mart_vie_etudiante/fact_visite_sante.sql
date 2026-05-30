{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_visite, id_etudiant, date_visite, type_service, motif
from {{ ref('stg_visite_sante') }}
