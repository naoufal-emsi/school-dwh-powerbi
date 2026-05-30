with source as (select * from {{ source('raw', 'SEANCE_COURS') }})
select
    cast(ID_SEANCE as integer)              as id_seance,
    cast(ID_MODULE as integer)              as id_module,
    cast(ID_PROFESSEUR as integer)          as id_professeur,
    cast(ID_SALLE as integer)               as id_salle,
    try_cast(DATE_SEANCE as date)           as date_seance,
    trim(HEURE_DEBUT)                       as heure_debut,
    trim(HEURE_FIN)                         as heure_fin,
    case when upper(EFFECTUEE) in ('OUI','TRUE','1') then true else false end as effectuee,
    cast(RETARD_MINUTES as integer)         as retard_minutes,
    cast(NB_ETUDIANTS_PRESENTS as integer)  as nb_etudiants_presents
from source
where ID_SEANCE is not null
