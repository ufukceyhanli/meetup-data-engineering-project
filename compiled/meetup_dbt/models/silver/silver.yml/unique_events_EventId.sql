
    
    

select
    EventId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`events`
where EventId is not null
group by EventId
having count(*) > 1


