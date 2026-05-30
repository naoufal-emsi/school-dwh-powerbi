{{ config(materialized='table', schema='MART_FINANCE') }}
select id_frais, id_etudiant, annee_universitaire, date_paiement, montant_du, montant_paye,
       statut, montant_impaye, taux_recouvrement
from {{ ref('stg_frais_scolarite') }}
