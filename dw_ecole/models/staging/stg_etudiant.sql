with source as (select * from {{ source('raw', 'ETUDIANT') }})
select
    cast(ID_ETUDIANT as integer)                                    as id_etudiant,
    trim(upper(NOM))                                                as nom,
    trim(initcap(PRENOM))                                           as prenom,
    trim(upper(SEXE))                                               as sexe,
    try_cast(DATE_NAISSANCE as date)                                as date_naissance,
    trim(VILLE_ORIGINE)                                             as ville_origine,
    trim(REGION)                                                    as region,
    trim(TYPE_BAC)                                                  as type_bac,
    trim(MENTION_BAC)                                               as mention_bac,
    case when upper(BOURSIER) in ('OUI','TRUE','1') then true else false end as boursier,
    try_cast(DATE_INSCRIPTION as date)                              as date_inscription,
    trim(STATUT)                                                    as statut,
    trim(FILIERE)                                                   as filiere,
    trim(NIVEAU_ACTUEL)                                             as niveau_actuel
from source
where ID_ETUDIANT is not null
