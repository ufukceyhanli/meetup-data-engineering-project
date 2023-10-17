{{
    config(
        alias="groups",
    )
}}

WITH final AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['group_id']) }} AS GroupId,
        Name AS GroupName,
        from_unixtime(LEFT(created, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS CratedUtc,
        REPLACE(description, '<p>', '') AS Description,
        City,
        lat::decimal(5,2) AS Lat,
        lon::decimal(5,2) AS Lon,
        Link
    FROM {{ source('meetup_dev', 'groups_bronze') }}
)

SELECT * FROM final
