with source as (select * from {{ source('raw', 'INSCRIPTION') }})
select
    cast(ID_INSCRIPTION as integer)     as id_inscription,
    cast(ID_ETUDIANT as integer)        as id_etudiant,
    trim(ANNEE_UNIVERSITAIRE)           as annee_universitaire,
    trim(TYPE)                          as type_inscription,
    try_cast(DATE_INSCRIPTION as date)  as date_inscription,
    trim(FILIERE)                       as filiere,
    trim(NIVEAU)                        as niveau
from source
where ID_INSCRIPTION is not null and ID_ETUDIANT is not null
