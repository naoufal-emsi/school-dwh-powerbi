with source as (select * from {{ source('raw', 'CHARGE_TEMPS_ETUDIANT') }})
select
    cast(ID_CHARGE as integer)          as id_charge,
    cast(ID_ETUDIANT as integer)        as id_etudiant,
    trim(SEMAINE)                       as semaine,
    cast(split_part(trim(SEMAINE), '-S', 2) as integer) as semaine_num,
    cast(HEURES_COURS as float)         as heures_cours,
    cast(HEURES_DEVOIRS as float)       as heures_devoirs,
    cast(HEURES_PROJETS as float)       as heures_projets,
    cast(HEURES_TEMPS_MORT as float)    as heures_temps_mort,
    cast(CHARGE_TOTALE as float)        as charge_totale,
    case when (cast(HEURES_DEVOIRS as float) + cast(HEURES_PROJETS as float)) > 0
         then cast(HEURES_COURS as float) / (cast(HEURES_DEVOIRS as float) + cast(HEURES_PROJETS as float))
         else null end                  as ratio_cours_travail_perso,
    case when cast(CHARGE_TOTALE as float) > 40 then true else false end as is_surcharge
from source
where ID_CHARGE is not null
