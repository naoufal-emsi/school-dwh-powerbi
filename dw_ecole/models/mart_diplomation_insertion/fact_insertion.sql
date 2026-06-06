{{ config(materialized='table', schema='MART_DIPLOMATION_INSERTION') }}
select
    id_insertion, id_etudiant, date_diplome,
    cast(to_char(date_diplome, 'YYYYMMDD') as integer) as id_date,
    date_fin_etudes, date_premier_emploi,
    salaire_embauche, secteur, type_poursuite,
    datediff('day', date_diplome, date_premier_emploi)    as delai_insertion_jours,
    datediff('month', date_fin_etudes, date_diplome)      as duree_etudes_mois,
    case when datediff('day', date_diplome, date_premier_emploi) <= 180
         then true else false end                         as is_emploi_6mois,
    year(date_diplome)                                    as annee_diplome
from {{ ref('stg_insertion_professionnelle') }}
