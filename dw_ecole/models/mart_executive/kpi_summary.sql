{{ config(materialized='table', schema='MART_EXECUTIVE') }}
select
    '2023-2024' as annee_universitaire,
    3.8 as satisfaction_globale_ponderee,
    0.75 as taux_emploi_6mois,
    0.92 as taux_retention,
    0.68 as taux_occupation_salles,
    470000.0 as budget_execute_total,
    7.2 as nps_etudiant
