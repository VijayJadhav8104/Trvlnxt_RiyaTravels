
CREATE Proc [dbo].[FetchMainAgentBalance] --'367','IN'
@ID INT,
@CountryCode varchar(5)
AS BEGIN 
	declare @CountryId INT
SELECT @CountryId=ID FROM mCountry WHERE CountryCode=@CountryCode

 select ISNULL(UCM.AgentBalance,0) AgentBalance ,ISNULL(AutoTicketing,0) AutoTicketing, ISNULL (SelfBalance,0) SelfBalance,ISNULL (CancelRequest,0) CancelRequest from mUserCountryMapping UCM inner join mUser U on UCM.UserId =  U.ID  where UCM.UserId = @ID
 and  UCM.CountryId = @CountryId
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchMainAgentBalance] TO [rt_read]
    AS [dbo];

