{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_presence, id_etudiant, id_seance, present, justifiee,
       case when not present and not justifiee then true else false end as is_absence_injustifiee
from {{ ref('stg_presence_etudiant') }}
