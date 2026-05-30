-- models/mart_inscriptions/dim_date.sql
-- Dimension date générée pour couvrir 2020 à 2030

{{ config(
    materialized = 'table',
    schema       = 'mart_inscriptions'
) }}

with date_spine as (
    {{
        dbt_utils.date_spine(
            datepart   = 'day',
            start_date = "cast('2020-01-01' as date)",
            end_date   = "cast('2030-12-31' as date)"
        )
    }}
)

select
    cast(to_char(date_day, 'YYYYMMDD') as integer)   as id_date,
    date_day                                          as date_complete,
    dayofweek(date_day)                               as jour_semaine,
    day(date_day)                                     as jour,
    weekofyear(date_day)                              as semaine,
    month(date_day)                                   as mois,
    quarter(date_day)                                 as trimestre,
    year(date_day)                                    as annee,

    -- Année universitaire : commence en septembre
    case
        when month(date_day) >= 9
        then concat(year(date_day),     '-', year(date_day) + 1)
        else concat(year(date_day) - 1, '-', year(date_day))
    end                                               as annee_universitaire,

    -- Semestre universitaire
    case
        when month(date_day) between 9  and 12 then 'S1'
        when month(date_day) between 1  and 2  then 'S1'
        when month(date_day) between 2  and 6  then 'S2'
        else 'Vacances'
    end                                               as semestre

from date_spine
