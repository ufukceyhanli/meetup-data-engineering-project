{{
    config(
        alias="rsvps",
    )
}}

WITH events_exploded AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['group_id', 'name', 'time', 'venue_id']) }} AS EventId,
        EXPLODE(rsvps) AS rsvps
    FROM {{ source('meetup_dev', 'events_bronze') }}
),

transfromed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['EventId', 'rsvps.user_id']) }} AS RsvpId,
        EventId,
        rsvps.user_id::timestamp AS UserId,
        rsvps.guests AS Guests,
        rsvps.response::boolean AS Response,
        from_unixtime(LEFT(rsvps.when, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS RsvpUtc
    FROM events_exploded
),

rank_records AS (
    SELECT
        *,
        RANK() OVER(PARTITION BY RsvpId ORDER BY RsvpUtc DESC) as Ranking
    FROM transfromed
),

final AS (
    SELECT
        RsvpId,
        EventId,
        UserId,
        Guests,
        Response,
        RsvpUtc
    FROM rank_records
    WHERE Ranking = 1
)

SELECT * FROM final
