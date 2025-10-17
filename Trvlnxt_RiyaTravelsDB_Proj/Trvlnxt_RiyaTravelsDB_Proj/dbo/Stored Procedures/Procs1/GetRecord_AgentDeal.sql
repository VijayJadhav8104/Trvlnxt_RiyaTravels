




CREATE proc [dbo].[GetRecord_AgentDeal]

@ID int

as
begin


select 
ID,
DealID,
--AgentID as PKID,
InsertdDate,
InsertedBy,
PKID,
AgencyName,
CustomerCOde,
case  when Flag is null then  'False' else 'True' end Flag,
b.FKUserID
--Flag
from
B2BRegistration b
left join Agent_Deal a on a.AgentID=b.FKUserID and a.DealID = @ID

where b.Icast is not null

--ORDER BY a.ID DESC


end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_AgentDeal] TO [rt_read]
    AS [dbo];

