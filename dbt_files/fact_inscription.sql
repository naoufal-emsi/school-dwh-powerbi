-- models/mart_inscriptions/fact_inscription.sql
-- Fact table inscriptions avec KPIs calculés pour Power BI

{{ config(
    materialized = 'table',
    schema       = 'mart_inscriptions'
) }}

with inscriptions as (
    select * from {{ ref('stg_inscription') }}
),

etudiants as (
    select * from {{ ref('stg_etudiant') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

-- Calcul du taux de rétention et abandon par étudiant
statuts as (
    select
        id_etudiant,
        statut,
        case when statut = 'Abandon'  then true else false end as is_abandon,
        case when statut = 'Actif'    then true else false end as is_actif,
        case when statut = 'Diplômé'  then true else false end as is_diplome
    from etudiants
),

-- Identification nouveaux inscrits vs réinscrits par année
inscription_ranked as (
    select
        id_inscription,
        id_etudiant,
        annee_universitaire,
        type_inscription,
        date_inscription,
        filiere,
        niveau,
        row_number() over (
            partition by id_etudiant
            order by date_inscription asc
        ) as rang_inscription
    from inscriptions
),

joined as (
    select
        i.id_inscription,
        i.id_etudiant,
        d.id_date,
        i.annee_universitaire,
        i.type_inscription,
        i.date_inscription,
        i.filiere,
        i.niveau,

        -- KPIs calculés
        case
            when i.rang_inscription = 1 then true
            else false
        end                                              as is_nouvel_inscrit,

        case
            when i.type_inscription = 'Réinscrit' then true
            else false
        end                                              as is_reinscrit,

        s.is_abandon,
        s.is_actif,
        s.is_diplome,

        -- Année d'inscription numérique pour tri Power BI
        left(i.annee_universitaire, 4)::integer          as annee_debut

    from inscription_ranked  i
    left join statuts         s on i.id_etudiant   = s.id_etudiant
    left join dates           d on i.date_inscription = d.date_complete
)

select * from joined
