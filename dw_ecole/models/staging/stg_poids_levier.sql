with source as (select * from {{ source('raw', 'POIDS_LEVIER_SATISFACTION') }})
select
    cast(ID_POIDS as integer)       as id_poids,
    trim(ANNEE_UNIVERSITAIRE)       as annee_universitaire,
    trim(LEVIER)                    as levier,
    cast(POIDS as float)            as poids
from source
