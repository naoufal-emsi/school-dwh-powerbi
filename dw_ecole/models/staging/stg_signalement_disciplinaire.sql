with source as (select * from {{ source('raw', 'SIGNALEMENT_DISCIPLINAIRE') }})
select
    cast(ID_SIGNALEMENT as integer)         as id_signalement,
    cast(ID_ETUDIANT as integer)            as id_etudiant,
    try_cast(DATE_SIGNALEMENT as date)      as date_signalement,
    trim(TYPE)                              as type_signalement,
    trim(GRAVITE)                           as gravite,
    trim(STATUT)                            as statut
from source
where ID_SIGNALEMENT is not null
