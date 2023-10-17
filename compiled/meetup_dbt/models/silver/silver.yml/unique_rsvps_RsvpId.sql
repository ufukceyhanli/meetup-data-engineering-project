
    
    

select
    RsvpId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`rsvps`
where RsvpId is not null
group by RsvpId
having count(*) > 1


