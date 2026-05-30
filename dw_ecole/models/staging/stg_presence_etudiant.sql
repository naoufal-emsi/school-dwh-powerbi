with source as (select * from {{ source('raw', 'PRESENCE_ETUDIANT') }})
select
    cast(ID_PRESENCE as integer)    as id_presence,
    cast(ID_ETUDIANT as integer)    as id_etudiant,
    cast(ID_SEANCE as integer)      as id_seance,
    case when upper(PRESENT) in ('OUI','TRUE','1') then true else false end   as present,
    case when upper(JUSTIFIEE) in ('OUI','TRUE','1') then true else false end as justifiee
from source
where ID_PRESENCE is not null
