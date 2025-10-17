






CREATE proc [dbo].[GetRecord_AgentMarkup]

@ID int

as
begin


select 
ID,
MarkupID,

InsertdDate,
InsertedBy,
PKID,
AgencyName,
CustomerCOde,
case when Flag is null then  'False' else 'True' end Flag,
b.FKUserID

from
B2BRegistration b
left join Agent_Markup a on a.AgentID=b.FKUserID and a.MarkupID = @ID

where b.Icast is not null

ORDER BY a.ID DESC



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_AgentMarkup] TO [rt_read]
    AS [dbo];

