{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_visite, id_etudiant, date_visite,
       cast(to_char(date_visite, 'YYYYMMDD') as integer) as id_date,
       type_service, motif
from {{ ref('stg_visite_sante') }}
