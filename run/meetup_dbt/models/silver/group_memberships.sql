
  
    
        create or replace table `playground`.`ufuk_meetup_dev`.`group_memberships`
      
      
    using delta
      
      
      
      
      
      
      
      as
      

WITH user_memberships_exploded AS (
    SELECT 
        user_id::string AS UserId,
        EXPLODE(memberships) AS memberships
    FROM `playground`.`ufuk_meetup_dev`.`users_bronze`
),

final AS (
    SELECT DISTINCT
        
    
md5(cast(concat(coalesce(cast(UserId as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(memberships.group_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS MembershipId,
        UserId,
        
    
md5(cast(concat(coalesce(cast(memberships.group_id as string), '_dbt_utils_surrogate_key_null_')) as string)) AS GroupId,
        from_unixtime(LEFT(memberships.joined, 10), 'yyyy-MM-dd HH:mm:ss')::timestamp AS JoinedUtc
    FROM user_memberships_exploded
)

SELECT * FROM final
  