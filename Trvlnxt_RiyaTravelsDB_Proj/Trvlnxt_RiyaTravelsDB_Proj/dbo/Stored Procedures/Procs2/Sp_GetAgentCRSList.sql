create procedure [dbo].[Sp_GetAgentCRSList]
as
begin

select Id,Name from AgencyCRS
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentCRSList] TO [rt_read]
    AS [dbo];

