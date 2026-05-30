{{ config(materialized='table', schema='MART_FINANCE') }}
select id_financement, source_financement, type_financement, annee, montant_mad, departement_beneficiaire
from {{ ref('stg_financement_externe') }}
