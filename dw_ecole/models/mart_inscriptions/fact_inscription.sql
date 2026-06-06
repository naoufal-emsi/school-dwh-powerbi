{{ config(materialized='table', schema='MART_INSCRIPTIONS') }}
with i as (select * from {{ ref('stg_inscription') }}),
     e as (select id_etudiant, statut from {{ ref('stg_etudiant') }}),
     ranked as (
         select *, row_number() over (partition by id_etudiant order by date_inscription) as rang
         from i
     )
select
    r.id_inscription, r.id_etudiant, r.annee_universitaire,
    r.type_inscription, r.date_inscription,
    cast(to_char(r.date_inscription, 'YYYYMMDD') as integer) as id_date,
    r.filiere, r.niveau,
    case when r.rang = 1 then true else false end                        as is_nouvel_inscrit,
    case when r.type_inscription = 'Réinscrit' then true else false end  as is_reinscrit,
    case when e.statut = 'Abandon' then true else false end              as is_abandon,
    case when e.statut = 'Actif' then true else false end                as is_actif,
    case when e.statut = 'Diplômé' then true else false end              as is_diplome,
    left(r.annee_universitaire, 4)::integer                             as annee_debut
from ranked r
left join e on r.id_etudiant = e.id_etudiant
