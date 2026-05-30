with source as (select * from {{ source('raw', 'CLUB_ASSOCIATION') }})
select
    cast(ID_CLUB as integer)            as id_club,
    trim(NOM_CLUB)                      as nom_club,
    trim(TYPE)                          as type_club,
    try_cast(DATE_CREATION as date)     as date_creation,
    year(try_cast(DATE_CREATION as date)) as annee_creation
from source
where ID_CLUB is not null
