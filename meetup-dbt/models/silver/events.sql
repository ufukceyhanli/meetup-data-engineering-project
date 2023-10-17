{{
    config(
        alias="events",
    )
}}

WITH events_cleaned AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['group_id', 'name', 'time', 'venue_id']) }} AS EventId,
        {{ dbt_utils.generate_surrogate_key(['group_id']) }} AS GroupId,
        venue_id::string AS VenueId,
        Name AS EventName,
        from_unixtime(LEFT(created, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS CreatedUtc,
        Description,
        rsvp_limit AS RsvpLimit,
        from_unixtime(LEFT(time, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS EventTime,
        duration/3600000 AS Duration,
        Status
    FROM {{ source('meetup_dev', 'events_bronze') }}
),

rank_records AS (
    SELECT
        *,
        RANK() OVER(PARTITION BY EventId ORDER BY CreatedUtc DESC) as Ranking
    FROM events_cleaned
),

final AS (
    SELECT
        EventId,
        GroupId,
        VenueId,
        EventName,
        CreatedUtc,
        Description,
        RsvpLimit,
        EventTime,
        Duration,
        Status
    FROM rank_records
    WHERE Ranking = 1
)

SELECT * FROM final
