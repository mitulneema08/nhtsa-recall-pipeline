{% snapshot recalls_snapshot %}

{{
    config(
        target_schema='nhtsa_silver',
        unique_key="NHTSACampaignNumber || '-' || Model",
        strategy='check',
        check_cols='all',
    )
}}

select *
from {{ source('nhtsa_silver', 'raw_recalls') }}

{% endsnapshot %}