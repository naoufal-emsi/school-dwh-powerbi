{{ config(materialized='table', schema='MART_ADMINISTRATION') }}
select id_accueil, id_etudiant, id_staff, date_accueil, heure_debut, heure_fin,
       initie_par, motif, is_initie_staff,
       datediff('minute', heure_debut::time, heure_fin::time) as duree_accueil_minutes
from {{ ref('stg_accueil_staff') }}
