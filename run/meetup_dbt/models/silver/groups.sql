
  
    
        create or replace table `playground`.`ufuk_meetup_dev`.`groups`
      
      
    using delta
      
      
      
      
      
      
      
      as
      

WITH final AS (
    SELECT 
        
    
md5(cast(concat(coalesce(cast(group_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS GroupId,
        Name AS GroupName,
        from_unixtime(LEFT(created, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS CratedUtc,
        REPLACE(description, '<p>', '') AS Description,
        City,
        lat::decimal(5,2) AS Lat,
        lon::decimal(5,2) AS Lon,
        Link
    FROM `playground`.`ufuk_meetup_dev`.`groups_bronze`
)

SELECT * FROM final
  