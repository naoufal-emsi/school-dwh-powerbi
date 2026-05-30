with source as (select * from {{ source('raw', 'AIDE_SOCIALE') }})
select
    cast(ID_AIDE as integer)                as id_aide,
    cast(ID_ETUDIANT as integer)            as id_etudiant,
    trim(TYPE_AIDE)                         as type_aide,
    try_cast(DATE_DEMANDE as date)          as date_demande,
    try_cast(DATE_TRAITEMENT as date)       as date_traitement,
    trim(STATUT)                            as statut,
    cast(MONTANT_MAD as float)              as montant_mad,
    datediff('day', try_cast(DATE_DEMANDE as date), try_cast(DATE_TRAITEMENT as date)) as delai_traitement_jours
from source
where ID_AIDE is not null
