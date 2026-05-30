with source as (select * from {{ source('raw', 'DEMANDE_ADMINISTRATIVE') }})
select
    cast(ID_DEMANDE as integer)                 as id_demande,
    cast(ID_ETUDIANT as integer)                as id_etudiant,
    cast(ID_STAFF as integer)                   as id_staff,
    trim(TYPE_DEMANDE)                          as type_demande,
    try_cast(DATE_SOUMISSION as date)           as date_soumission,
    try_cast(DATE_RESOLUTION as date)           as date_resolution,
    case when upper(RESOLU_PREMIER_CONTACT) in ('OUI','TRUE','1') then true else false end as resolu_premier_contact,
    cast(SATISFACTION_SERVICE as integer)       as satisfaction_service,
    datediff('day', try_cast(DATE_SOUMISSION as date), try_cast(DATE_RESOLUTION as date)) as delai_traitement_jours
from source
where ID_DEMANDE is not null
