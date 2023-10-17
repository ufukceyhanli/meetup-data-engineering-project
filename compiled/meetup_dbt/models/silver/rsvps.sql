

WITH events_exploded AS (
    SELECT 
        
    
md5(cast(concat(coalesce(cast(group_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(name as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(time as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(venue_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS EventId,
        EXPLODE(rsvps) AS rsvps
    FROM `playground`.`ufuk_meetup_dev`.`events_bronze`
),

transfromed AS (
    SELECT
        
    
md5(cast(concat(coalesce(cast(EventId as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(rsvps.user_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS RsvpId,
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