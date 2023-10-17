
  
    
        create or replace table `playground`.`ufuk_meetup_dev`.`group_topics`
      
      
    using delta
      
      
      
      
      
      
      
      as
      

WITH groups_exploded AS (
    SELECT 
        
    
md5(cast(concat(coalesce(cast(group_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS GroupId,
        EXPLODE(topics) AS Topics
    FROM `playground`.`ufuk_meetup_dev`.`groups_bronze`
),

final AS (
    SELECT
        
    
md5(cast(concat(coalesce(cast(GroupId as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(Topics as string), '_dbt_utils_surrogate_key_null_')) as string)) AS GroupTopicId,
        GroupId,
        Topics
    FROM groups_exploded
)

SELECT * FROM final
  