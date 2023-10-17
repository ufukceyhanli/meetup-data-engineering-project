
    
    

select
    MembershipId as unique_field,
    count(*) as n_records

from `playground`.`ufuk_meetup_dev`.`group_memberships`
where MembershipId is not null
group by MembershipId
having count(*) > 1


