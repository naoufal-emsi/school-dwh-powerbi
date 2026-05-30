with source as (select * from {{ source('raw', 'FRAIS_SCOLARITE') }})
select
    cast(ID_FRAIS as integer)               as id_frais,
    cast(ID_ETUDIANT as integer)            as id_etudiant,
    trim(ANNEE_UNIVERSITAIRE)               as annee_universitaire,
    cast(MONTANT_DU as float)               as montant_du,
    cast(MONTANT_PAYE as float)             as montant_paye,
    try_cast(DATE_PAIEMENT as date)         as date_paiement,
    trim(STATUT)                            as statut,
    cast(MONTANT_DU as float) - cast(MONTANT_PAYE as float) as montant_impaye,
    case when cast(MONTANT_DU as float) > 0
         then cast(MONTANT_PAYE as float) / cast(MONTANT_DU as float)
         else null end                      as taux_recouvrement
from source
where ID_FRAIS is not null
