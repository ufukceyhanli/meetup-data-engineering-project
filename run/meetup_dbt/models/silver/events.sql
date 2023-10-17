
  
    
        create or replace table `playground`.`ufuk_meetup_dev`.`events`
      
      
    using delta
      
      
      
      
      
      
      
      as
      

WITH events_cleaned AS (
    SELECT DISTINCT
        
    
md5(cast(concat(coalesce(cast(group_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(name as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(time as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(venue_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS EventId,
        
    
md5(cast(concat(coalesce(cast(group_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS GroupId,
        venue_id::string AS VenueId,
        Name AS EventName,
        from_unixtime(LEFT(created, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS CreatedUtc,
        Description,
        rsvp_limit AS RsvpLimit,
        from_unixtime(LEFT(time, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS EventTime,
        duration/3600000 AS Duration,
        Status
    FROM `playground`.`ufuk_meetup_dev`.`events_bronze`
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
  