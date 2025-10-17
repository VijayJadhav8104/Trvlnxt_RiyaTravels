



create proc [dbo].[GetList_AgentList]

@AgentName varchar(100)

as
begin

Select 
PKID,
AgencyName,
Icast
from B2BRegistration
where AgencyName like @AgentName + '%'

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_AgentList] TO [rt_read]
    AS [dbo];

