{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_aide, id_etudiant, date_demande, type_aide, statut, montant_mad, delai_traitement_jours
from {{ ref('stg_aide_sociale') }}
