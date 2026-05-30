-- models/staging/stg_inscription.sql
-- Nettoie et type les données brutes de la table inscription

with source as (
    select * from {{ source('raw', 'inscription') }}
),

cleaned as (
    select
        cast(id_inscription       as integer)  as id_inscription,
        cast(id_etudiant          as integer)  as id_etudiant,
        trim(annee_universitaire)              as annee_universitaire,
        trim(type)                             as type_inscription,
        cast(date_inscription     as date)     as date_inscription,
        trim(filiere)                          as filiere,
        trim(niveau)                           as niveau
    from source
    where id_inscription is not null
      and id_etudiant    is not null
)

select * from cleaned
