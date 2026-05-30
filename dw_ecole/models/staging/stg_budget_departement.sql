with source as (select * from {{ source('raw', 'BUDGET_DEPARTEMENT') }})
select
    cast(ID_BUDGET as integer)          as id_budget,
    trim(DEPARTEMENT)                   as departement,
    cast(ANNEE as integer)              as annee,
    cast(BUDGET_PREVU as float)         as budget_prevu,
    cast(BUDGET_EXECUTE as float)       as budget_execute,
    trim(TYPE_DEPENSE)                  as type_depense,
    case when cast(BUDGET_PREVU as float) > 0
         then cast(BUDGET_EXECUTE as float) / cast(BUDGET_PREVU as float)
         else null end                  as taux_execution,
    cast(BUDGET_PREVU as float) - cast(BUDGET_EXECUTE as float) as ecart_budget
from source
where ID_BUDGET is not null
