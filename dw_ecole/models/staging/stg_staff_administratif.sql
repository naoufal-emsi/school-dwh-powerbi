with source as (select * from {{ source('raw', 'STAFF_ADMINISTRATIF') }})
select
    cast(ID_STAFF as integer)           as id_staff,
    trim(upper(NOM))                    as nom,
    trim(initcap(PRENOM))               as prenom,
    trim(ROLE)                          as role,
    trim(DEPARTEMENT)                   as departement,
    try_cast(DATE_RECRUTEMENT as date)  as date_recrutement,
    year(try_cast(DATE_RECRUTEMENT as date)) as annee_recrutement
from source
where ID_STAFF is not null
