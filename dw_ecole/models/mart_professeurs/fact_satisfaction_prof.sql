{{ config(materialized='table', schema='MART_PROFESSEURS') }}
select
    id_enquete, id_professeur, id_module, score_clarte, poids_clarte,
    score_disponibilite, poids_disponibilite, score_pedagogie, poids_pedagogie,
    score_equite, poids_equite,
    (score_clarte * poids_clarte + score_disponibilite * poids_disponibilite +
     score_pedagogie * poids_pedagogie + score_equite * poids_equite) as score_satisfaction_prof
from {{ ref('stg_satisfaction_enquete') }}
