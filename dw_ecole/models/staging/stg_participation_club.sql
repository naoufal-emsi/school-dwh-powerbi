with source as (select * from {{ source('raw', 'PARTICIPATION_CLUB') }})
select
    cast(ID_PARTICIPATION as integer)   as id_participation,
    cast(ID_ETUDIANT as integer)        as id_etudiant,
    cast(ID_CLUB as integer)            as id_club,
    trim(ANNEE_UNIVERSITAIRE)           as annee_universitaire,
    trim(ROLE)                          as role
from source
where ID_PARTICIPATION is not null
