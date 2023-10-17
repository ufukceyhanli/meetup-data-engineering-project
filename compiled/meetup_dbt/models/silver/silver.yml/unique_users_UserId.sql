
    
    

select
    UserId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`users`
where UserId is not null
group by UserId
having count(*) > 1


