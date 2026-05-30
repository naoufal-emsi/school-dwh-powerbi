{{ config(materialized='table', schema='MART_SATISFACTION') }}
select
    id_enquete, id_etudiant, id_professeur, id_module, annee_universitaire,
    score_clarte, poids_clarte, score_disponibilite, poids_disponibilite,
    score_pedagogie, poids_pedagogie, score_equite, poids_equite,
    score_admin, score_vie_etudiante, score_charge, score_finances,
    score_global, nps,
    (score_clarte * poids_clarte + score_disponibilite * poids_disponibilite +
     score_pedagogie * poids_pedagogie + score_equite * poids_equite) as score_prof_pondere,
    score_global as score_global_pondere
from {{ ref('stg_satisfaction_enquete') }}
