with source as (select * from {{ source('raw', 'INSERTION_PROFESSIONNELLE') }})
select
    cast(ID_INSERTION as integer)           as id_insertion,
    cast(ID_ETUDIANT as integer)            as id_etudiant,
    try_cast(DATE_DIPLOME as date)          as date_diplome,
    try_cast(DATE_FIN_ETUDES as date)       as date_fin_etudes,
    try_cast(DATE_PREMIER_EMPLOI as date)   as date_premier_emploi,
    cast(SALAIRE_EMBAUCHE as float)         as salaire_embauche,
    trim(SECTEUR)                           as secteur,
    trim(TYPE_POURSUITE)                    as type_poursuite
from source
where ID_INSERTION is not null
