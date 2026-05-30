with source as (select * from {{ source('raw', 'SALLE') }})
select
    cast(ID_SALLE as integer)   as id_salle,
    trim(NOM_SALLE)             as nom_salle,
    cast(CAPACITE as integer)   as capacite,
    trim(TYPE)                  as type_salle,
    trim(BATIMENT)              as batiment
from source
where ID_SALLE is not null
