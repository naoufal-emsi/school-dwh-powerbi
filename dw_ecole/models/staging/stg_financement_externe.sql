with source as (select * from {{ source('raw', 'FINANCEMENT_EXTERNE') }})
select
    cast(ID_FINANCEMENT as integer)         as id_financement,
    trim(SOURCE)                            as source_financement,
    trim(TYPE)                              as type_financement,
    cast(ANNEE as integer)                  as annee,
    cast(MONTANT_MAD as float)              as montant_mad,
    trim(DEPARTEMENT_BENEFICIAIRE)          as departement_beneficiaire
from source
where ID_FINANCEMENT is not null
