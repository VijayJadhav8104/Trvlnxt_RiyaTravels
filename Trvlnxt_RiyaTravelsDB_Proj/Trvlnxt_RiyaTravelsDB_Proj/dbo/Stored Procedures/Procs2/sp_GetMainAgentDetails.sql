






CREATE PROCEDURE [dbo].[sp_GetMainAgentDetails]-- '3','US'
@ID INT,
@CountryCode varchar(5)
AS
BEGIN

declare @CountryId INT
SELECT @CountryId=ID FROM mCountry WHERE CountryCode=@CountryCode

 select ISNULL(UCM.AgentBalance,0) AgentBalance ,ISNULL(AutoTicketing,0) AutoTicketing, ISNULL (SelfBalance,0) SelfBalance,ISNULL (CancelRequest,0) CancelRequest
 ,EmailID, MobileNo  from mUserCountryMapping UCM inner join mUser U on UCM.UserId =  U.ID  where UCM.UserId = @ID
 and  UCM.CountryId = @CountryId

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetMainAgentDetails] TO [rt_read]
    AS [dbo];

