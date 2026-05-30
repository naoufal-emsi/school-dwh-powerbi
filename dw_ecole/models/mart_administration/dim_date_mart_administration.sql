{{ config(materialized='table', schema='MART_ADMINISTRATION') }}
with spine as (
    select dateadd('day', seq4(), '2020-01-01'::date) as date_day
    from table(generator(rowcount => 4018))
)
select
    cast(to_char(date_day, 'YYYYMMDD') as integer)  as id_date,
    date_day                                         as date_complete,
    month(date_day)                                  as mois,
    case when month(date_day) >= 9
         then concat(year(date_day), '-', year(date_day)+1)
         else concat(year(date_day)-1, '-', year(date_day))
    end                                              as annee_universitaire
from spine
