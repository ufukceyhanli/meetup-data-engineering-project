{{
    config(
        alias="group_memberships",
    )
}}

WITH user_memberships_exploded AS (
    SELECT 
        user_id::string AS UserId,
        EXPLODE(memberships) AS memberships
    FROM {{ source('meetup_dev', 'users_bronze') }}
),

final AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['UserId', 'memberships.group_id']) }} AS MembershipId,
        UserId,
        {{ dbt_utils.generate_surrogate_key(['memberships.group_id']) }} AS GroupId,
        from_unixtime(LEFT(memberships.joined, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS JoinedUtc
    FROM user_memberships_exploded
)

SELECT * FROM final
