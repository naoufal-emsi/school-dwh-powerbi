{{ config(materialized='table', schema='MART_ADMINISTRATION') }}
select id_staff, nom, prenom, role, departement, annee_recrutement
from {{ ref('stg_staff_administratif') }}
