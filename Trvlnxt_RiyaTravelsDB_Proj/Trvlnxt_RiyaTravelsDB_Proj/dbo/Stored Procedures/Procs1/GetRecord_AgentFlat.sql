






CREATE proc [dbo].[GetRecord_AgentFlat]

@ID int

as
begin


select 
ID,
FlatD,
--AgentID as PKID,
InsertdDate,
InsertedBy,
PKID,
AgencyName,
CustomerCOde,
case when Flag is null then  'False' else 'True' end Flag,
b.FKUserID

from
B2BRegistration b
left join Agent_Flat a on a.AgentID=b.FKUserID and a.FlatD = @ID


where b.Icast is not null

ORDER BY a.ID DESC


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_AgentFlat] TO [rt_read]
    AS [dbo];

