with source as (select * from {{ source('raw', 'MOBILITE_INTERNATIONALE') }})
select
    cast(ID_MOBILITE as integer)            as id_mobilite,
    cast(ID_ETUDIANT as integer)            as id_etudiant,
    trim(TYPE)                              as type_mobilite,
    trim(PAYS_DESTINATION)                  as pays_destination,
    trim(UNIVERSITE_PARTENAIRE)             as universite_partenaire,
    try_cast(DATE_DEBUT as date)            as date_debut,
    try_cast(DATE_FIN as date)              as date_fin,
    trim(PROGRAMME)                         as programme,
    datediff('day', try_cast(DATE_DEBUT as date), try_cast(DATE_FIN as date)) as duree_mobilite_jours
from source
where ID_MOBILITE is not null
