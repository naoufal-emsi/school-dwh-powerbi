-- models/staging/stg_etudiant.sql
-- Nettoie et type les données brutes de la table etudiant

with source as (
    select * from {{ source('raw', 'etudiant') }}
),

cleaned as (
    select
        cast(id_etudiant         as integer)  as id_etudiant,
        trim(upper(nom))                       as nom,
        trim(initcap(prenom))                  as prenom,
        trim(upper(sexe))                      as sexe,
        cast(date_naissance      as date)      as date_naissance,
        trim(ville_origine)                    as ville_origine,
        trim(region)                           as region,
        trim(type_bac)                         as type_bac,
        trim(mention_bac)                      as mention_bac,
        case
            when upper(boursier) in ('OUI', 'TRUE', '1') then true
            else false
        end                                    as boursier,
        cast(date_inscription    as date)      as date_inscription,
        trim(statut)                           as statut,
        trim(filiere)                          as filiere,
        trim(niveau_actuel)                    as niveau_actuel
    from source
    where id_etudiant is not null
)

select * from cleaned
