with source as (select * from {{ source('raw', 'PROFESSEUR') }})
select
    cast(ID_PROFESSEUR as integer)      as id_professeur,
    trim(upper(NOM))                    as nom,
    trim(initcap(PRENOM))               as prenom,
    trim(GRADE)                         as grade,
    trim(DEPARTEMENT)                   as departement,
    trim(SPECIALITE)                    as specialite,
    cast(CHARGE_PREVUE_H as integer)    as charge_prevue_h,
    cast(NB_PUBLICATIONS as integer)    as nb_publications,
    try_cast(DATE_RECRUTEMENT as date)  as date_recrutement,
    year(try_cast(DATE_RECRUTEMENT as date)) as annee_recrutement
from source
where ID_PROFESSEUR is not null
