with source as (select * from {{ source('raw', 'ACCUEIL_STAFF') }})
select
    cast(ID_ACCUEIL as integer)         as id_accueil,
    cast(ID_ETUDIANT as integer)        as id_etudiant,
    cast(ID_STAFF as integer)           as id_staff,
    try_cast(DATE_ACCUEIL as date)      as date_accueil,
    trim(HEURE_DEBUT)                   as heure_debut,
    trim(HEURE_FIN)                     as heure_fin,
    trim(INITIE_PAR)                    as initie_par,
    trim(MOTIF)                         as motif,
    case when upper(INITIE_PAR) = 'STAFF' then true else false end as is_initie_staff
from source
where ID_ACCUEIL is not null
