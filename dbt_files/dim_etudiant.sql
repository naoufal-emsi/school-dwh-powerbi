-- models/mart_inscriptions/dim_etudiant.sql
-- Dimension étudiant pour le mart inscriptions

{{ config(
    materialized = 'table',
    schema       = 'mart_inscriptions'
) }}

with stg as (
    select * from {{ ref('stg_etudiant') }}
)

select
    id_etudiant,
    nom,
    prenom,
    sexe,
    date_naissance,

    -- Age calculé
    datediff('year', date_naissance, current_date())  as age,

    ville_origine,
    region,
    type_bac,
    mention_bac,
    boursier,
    date_inscription,
    statut,
    filiere,
    niveau_actuel,

    -- Année d'inscription extraite pour faciliter les filtres Power BI
    year(date_inscription)                            as annee_inscription

from stg
