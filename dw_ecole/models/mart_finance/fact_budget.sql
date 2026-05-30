{{ config(materialized='table', schema='MART_FINANCE') }}
select id_budget, departement, annee, budget_prevu, budget_execute, type_depense,
       taux_execution, ecart_budget
from {{ ref('stg_budget_departement') }}
