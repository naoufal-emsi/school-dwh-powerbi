with source as (select * from {{ source('raw', 'MODULE') }})
select
    cast(ID_MODULE as integer)      as id_module,
    trim(NOM_MODULE)                as nom_module,
    trim(FILIERE)                   as filiere,
    trim(NIVEAU)                    as niveau,
    trim(DEPARTEMENT)               as departement,
    cast(CREDITS_ECTS as integer)   as credits_ects,
    cast(HEURES_PREVUES as integer) as heures_prevues,
    cast(ID_PROFESSEUR as integer)  as id_professeur
from source
where ID_MODULE is not null
