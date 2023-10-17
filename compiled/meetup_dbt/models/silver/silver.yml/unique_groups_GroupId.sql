
    
    

select
    GroupId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`groups`
where GroupId is not null
group by GroupId
having count(*) > 1


