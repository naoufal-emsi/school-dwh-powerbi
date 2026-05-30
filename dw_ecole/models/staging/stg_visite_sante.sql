with source as (select * from {{ source('raw', 'VISITE_SANTE') }})
select
    cast(ID_VISITE as integer)          as id_visite,
    cast(ID_ETUDIANT as integer)        as id_etudiant,
    try_cast(DATE_VISITE as date)       as date_visite,
    trim(TYPE_SERVICE)                  as type_service,
    trim(MOTIF)                         as motif
from source
where ID_VISITE is not null
