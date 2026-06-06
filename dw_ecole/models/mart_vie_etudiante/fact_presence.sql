{{ config(materialized='table', schema='MART_VIE_ETUDIANTE') }}
with p as (select * from {{ ref('stg_presence_etudiant') }}),
     s as (select id_seance, date_seance from {{ ref('stg_seance_cours') }})
select
    p.id_presence, p.id_etudiant, p.id_seance, p.present, p.justifiee,
    s.date_seance,
    cast(to_char(s.date_seance, 'YYYYMMDD') as integer) as id_date,
    case when not p.present and not p.justifiee then true else false end as is_absence_injustifiee
from p
left join s on p.id_seance = s.id_seance
