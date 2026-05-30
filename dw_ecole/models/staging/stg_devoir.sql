with source as (select * from {{ source('raw', 'DEVOIR') }})
select
    cast(ID_DEVOIR as integer)          as id_devoir,
    cast(ID_MODULE as integer)          as id_module,
    cast(ID_PROFESSEUR as integer)      as id_professeur,
    try_cast(DATE_DONNE as date)        as date_donne,
    try_cast(DATE_RENDU as date)        as date_rendu,
    trim(TYPE)                          as type_devoir,
    cast(DUREE_ESTIMEE_H as float)      as duree_estimee_h
from source
where ID_DEVOIR is not null
