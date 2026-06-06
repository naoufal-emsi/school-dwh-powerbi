{{ config(materialized='table', schema='MART_EXECUTIVE') }}

with satisfaction as (
    select
        annee_universitaire,
        avg(score_global)                                   as satisfaction_globale_ponderee,
        avg(nps)                                            as nps_etudiant
    from {{ ref('fact_satisfaction') }}
    group by annee_universitaire
),
insertion as (
    select
        annee_diplome::varchar                              as annee_universitaire,
        avg(case when is_emploi_6mois then 1.0 else 0.0 end) as taux_emploi_6mois
    from {{ ref('fact_insertion') }}
    group by annee_diplome
),
inscriptions as (
    select
        annee_universitaire,
        avg(case when not is_abandon then 1.0 else 0.0 end) as taux_retention
    from {{ ref('fact_inscription') }}
    group by annee_universitaire
),
seances as (
    select
        left(annee_universitaire, 4)::varchar               as annee_universitaire,
        avg(taux_occupation_salle)                          as taux_occupation_salles
    from {{ ref('fact_seance_cours') }}
    left join {{ ref('dim_date_mart_professeurs') }} d on fact_seance_cours.id_date = d.id_date
    group by 1
),
budget as (
    select
        annee::varchar                                      as annee_universitaire,
        sum(budget_execute)                                 as budget_execute_total
    from {{ ref('fact_budget') }}
    group by annee
)

select
    s.annee_universitaire,
    round(s.satisfaction_globale_ponderee, 2)               as satisfaction_globale_ponderee,
    round(coalesce(i.taux_emploi_6mois, 0), 2)              as taux_emploi_6mois,
    round(coalesce(ins.taux_retention, 0), 2)               as taux_retention,
    round(coalesce(se.taux_occupation_salles, 0), 2)        as taux_occupation_salles,
    coalesce(b.budget_execute_total, 0)                     as budget_execute_total,
    round(s.nps_etudiant, 1)                                as nps_etudiant
from satisfaction s
left join insertion i       on s.annee_universitaire = i.annee_universitaire
left join inscriptions ins  on s.annee_universitaire = ins.annee_universitaire
left join seances se        on s.annee_universitaire = se.annee_universitaire
left join budget b          on left(s.annee_universitaire, 4) = b.annee_universitaire
