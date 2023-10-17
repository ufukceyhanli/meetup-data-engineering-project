
  
    
        create or replace table `playground`.`ufuk_meetup_dev`.`venues`
      
      
    using delta
      
      
      
      
      
      
      
      as
      

WITH final AS (
    SELECT 
        venue_id::string AS VenueId,
        Name AS VenueName,
        City,
        UPPER(country) AS Country,
        lat::decimal(5,2) AS Lat,
        lon::decimal(5,2) AS Lon
    FROM `playground`.`ufuk_meetup_dev`.`venues_bronze`
)

SELECT * FROM final
  