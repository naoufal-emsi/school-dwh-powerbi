{{ config(materialized='table', schema='MART_PROFESSEURS') }}
with seance as (select * from {{ ref('stg_seance_cours') }}),
     salle as (select * from {{ ref('stg_salle') }})
select
    s.id_seance, s.id_module, s.id_professeur, s.id_salle, s.date_seance,
    cast(to_char(s.date_seance, 'YYYYMMDD') as integer) as id_date,
    s.heure_debut, s.heure_fin, s.effectuee, s.retard_minutes, s.nb_etudiants_presents,
    case when s.heure_fin is not null and s.heure_debut is not null
         then datediff('hour', s.heure_debut::time, s.heure_fin::time)
         else null end                                           as duree_seance_h,
    case when s.nb_etudiants_presents > 0 and sa.capacite > 0
         then s.nb_etudiants_presents::float / sa.capacite
         else null end                                           as taux_occupation_salle,
    case when s.retard_minutes > 0 then true else false end     as is_en_retard
from seance s
left join salle sa on s.id_salle = sa.id_salle
