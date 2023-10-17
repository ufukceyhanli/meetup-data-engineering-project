
    
    

select
    GroupTopicId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`group_topics`
where GroupTopicId is not null
group by GroupTopicId
having count(*) > 1


