{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
select id_mobilite, id_etudiant, date_debut, date_fin, type_mobilite, pays_destination,
       universite_partenaire, programme, duree_mobilite_jours
from {{ ref('stg_mobilite_internationale') }}
