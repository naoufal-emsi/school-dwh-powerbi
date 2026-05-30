{{ config(materialized='table', schema='MART_PERFORMANCE_ACADEMIQUE') }}
with n as (select * from {{ ref('stg_note') }}),
     taux as (
         select id_module, annee_universitaire,
             avg(case when resultat = 'Admis' then 1.0 else 0.0 end) as taux_reussite,
             avg(case when resultat = 'Échec'  then 1.0 else 0.0 end) as taux_echec
         from n group by id_module, annee_universitaire
     )
select
    n.id_note, n.id_etudiant, n.id_module, n.annee_universitaire,
    n.note, n.mention, n.session, n.resultat,
    t.taux_reussite                                         as taux_reussite_module,
    t.taux_echec                                            as taux_echec_module,
    case when t.taux_echec > 0.30 then true else false end  as is_module_a_risque
from n
left join taux t on n.id_module = t.id_module and n.annee_universitaire = t.annee_universitaire
