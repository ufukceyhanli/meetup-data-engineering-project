{{
    config(
        alias="group_topics",
    )
}}

WITH groups_exploded AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['group_id']) }} AS GroupId,
        EXPLODE(topics) AS Topics
    FROM {{ source('meetup_dev', 'groups_bronze') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['GroupId','Topics']) }} AS GroupTopicId,
        GroupId,
        Topics
    FROM groups_exploded
)

SELECT * FROM final
