with source as (select * from {{ source('raw', 'SEUIL_ALERTE') }})
select
    cast(ID_SEUIL as integer)       as id_seuil,
    trim(KPI)                       as kpi,
    cast(SEUIL_ALERTE as float)     as seuil_alerte,
    trim(NIVEAU)                    as niveau,
    trim(MESSAGE)                   as message
from source
