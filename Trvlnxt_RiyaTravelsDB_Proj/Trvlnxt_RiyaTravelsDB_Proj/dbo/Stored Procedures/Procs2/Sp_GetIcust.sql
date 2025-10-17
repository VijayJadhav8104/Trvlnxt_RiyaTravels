
-- =============================================
-- Author:		Bhavika kawa
-- Create date: 23/04/2020
-- Description:	To get Icust on the basis of Country
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetIcust]
	@CountryId int,
	@UserType int
AS
BEGIN
	
	declare @CountryCode varchar(20)

	select @CountryCode = CountryCode from mCountry where ID=@CountryId

	SELECT PKID, Icast, AgencyName, al.UserID, Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
	inner join agentLogin al on al.UserID = b.FKUserID
	where al.BookingCountry = @CountryCode AND AgentApproved=1 and userTypeID=@UserType
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetIcust] TO [rt_read]
    AS [dbo];

