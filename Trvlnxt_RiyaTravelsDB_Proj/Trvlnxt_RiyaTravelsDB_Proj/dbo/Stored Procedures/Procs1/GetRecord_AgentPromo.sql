






CREATE proc [dbo].[GetRecord_AgentPromo]

@ID int

as
begin


select 
ID,
PromoID,
InsertdDate,
InsertedBy,
PKID,
AgencyName,
CustomerCOde,
case when Flag is null then  'False' else 'True' end Flag,
b.FKUserID

from
B2BRegistration b
left join Agent_Promocode a on a.AgentID=b.FKUserID and a.PromoID = @ID


where b.Icast is not null

ORDER BY a.ID DESC


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_AgentPromo] TO [rt_read]
    AS [dbo];

