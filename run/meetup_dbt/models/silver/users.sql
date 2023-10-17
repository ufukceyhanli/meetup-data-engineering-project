
  
    
        create or replace table `playground`.`ufuk_meetup_dev`.`users`
      
      
    using delta
      
      
      
      
      
      
      
      as
      

WITH final AS (
    SELECT 
        user_id::string AS UserId,
        City,
        UPPER(country) AS Country,
        Hometown
    FROM `playground`.`ufuk_meetup_dev`.`users_bronze`
)

SELECT * FROM final
  