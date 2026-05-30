{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_club, nom_club, type_club, date_creation, annee_creation
from {{ ref('stg_club_association') }}
