{{ config(materialized='table', schema='MART_INSCRIPTIONS') }}
select
    id_etudiant, nom, prenom, sexe, date_naissance,
    datediff('year', date_naissance, current_date()) as age,
    ville_origine, region, type_bac, mention_bac, boursier,
    date_inscription, statut, filiere, niveau_actuel,
    year(date_inscription) as annee_inscription
from {{ ref('stg_etudiant') }}
