with source as (

    select *
    from {{ ref('recalls_snapshot') }}
    where dbt_valid_to is null

)

select
    NHTSACampaignNumber as campaign_number,
    substr(NHTSACampaignNumber, 1, length(NHTSACampaignNumber) - 3) as recall,
    NHTSAActionNumber as action_number,
    Make as make,
    Model as model,
    ModelYear as model_year,
    Manufacturer as manufacturer,
    Component as component,
    Summary as summary,
    Consequence as consequence,
    Remedy as remedy,
    Notes as notes,
    ReportReceivedDate as report_received_date,
    overTheAirUpdate as over_the_air_update,
    parkOutSide as park_outside,
    parkIt as park_it,
    _pulled_model as pulled_model,
    _pulled_model_year as pulled_model_year,
    dbt_valid_from as snapshot_valid_from,
    dbt_scd_id as snapshot_id

from source