{{
    config(
        alias="users",
    )
}}

WITH final AS (
    SELECT 
        user_id::string AS UserId,
        City,
        UPPER(country) AS Country,
        Hometown
    FROM {{ source('meetup_dev', 'users_bronze') }}
)

SELECT * FROM final