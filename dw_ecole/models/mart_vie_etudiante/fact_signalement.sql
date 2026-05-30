{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_signalement, id_etudiant, date_signalement, type_signalement, gravite, statut
from {{ ref('stg_signalement_disciplinaire') }}
