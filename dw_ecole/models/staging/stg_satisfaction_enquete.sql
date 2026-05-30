with source as (select * from {{ source('raw', 'SATISFACTION_ENQUETE') }})
select
    cast(ID_ENQUETE as integer)             as id_enquete,
    cast(ID_ETUDIANT as integer)            as id_etudiant,
    cast(ID_PROFESSEUR as integer)          as id_professeur,
    cast(ID_MODULE as integer)              as id_module,
    trim(ANNEE_UNIVERSITAIRE)               as annee_universitaire,
    cast(SCORE_CLARTE as integer)           as score_clarte,
    cast(POIDS_CLARTE as float)             as poids_clarte,
    cast(SCORE_DISPONIBILITE as integer)    as score_disponibilite,
    cast(POIDS_DISPONIBILITE as float)      as poids_disponibilite,
    cast(SCORE_PEDAGOGIE as integer)        as score_pedagogie,
    cast(POIDS_PEDAGOGIE as float)          as poids_pedagogie,
    cast(SCORE_EQUITE as integer)           as score_equite,
    cast(POIDS_EQUITE as float)             as poids_equite,
    cast(SCORE_ADMIN as integer)            as score_admin,
    cast(SCORE_VIE_ETUDIANTE as integer)    as score_vie_etudiante,
    cast(SCORE_CHARGE as integer)           as score_charge,
    cast(SCORE_FINANCES as integer)         as score_finances,
    cast(SCORE_GLOBAL as float)             as score_global,
    cast(NPS as integer)                    as nps
from source
where ID_ENQUETE is not null
