{{
    config(
        schema='nhtsa_gold',
        materialized='table'
    )
}}

select
    manufacturer,
    component,
    model_year,
    count(distinct recall) as recall_count,
    count(*) as affected_vehicle_line_count,
    min(report_received_date) as earliest_report_date,
    max(report_received_date) as latest_report_date,
    countif(park_it) as park_it_count,
    countif(park_outside) as park_outside_count,
    countif(over_the_air_update) as ota_remediable_count

from {{ ref('stg_recalls') }}

group by manufacturer, component, model_year