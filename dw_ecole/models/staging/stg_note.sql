with source as (select * from {{ source('raw', 'NOTE') }})
select
    cast(ID_NOTE as integer)            as id_note,
    cast(ID_ETUDIANT as integer)        as id_etudiant,
    cast(ID_MODULE as integer)          as id_module,
    trim(ANNEE_UNIVERSITAIRE)           as annee_universitaire,
    cast(NOTE as float)                 as note,
    trim(MENTION)                       as mention,
    trim(SESSION)                       as session,
    trim(RESULTAT)                      as resultat
from source
where ID_NOTE is not null
