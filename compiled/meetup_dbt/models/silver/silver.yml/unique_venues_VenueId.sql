
    
    

select
    VenueId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`venues`
where VenueId is not null
group by VenueId
having count(*) > 1


