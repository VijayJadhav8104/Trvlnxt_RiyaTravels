CREATE Procedure [dbo].[Sp_GetAgentTypeList]
as
begin
select  distinct c.ID as AgentId,C.Value AS UserType from mUserTypeMapping UT
INNER JOIN mCommon C ON C.ID=UT.UserTypeId AND IsActive=1 
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentTypeList] TO [rt_read]
    AS [dbo];

