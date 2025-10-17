-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- execute AgentCompanyMappingDetails 51354
-- =============================================
CREATE PROCEDURE AgentCompanyMappingDetails
	@AgentId int=0
AS
BEGIN
	
	declare @Userid int=0;
	set @Userid = (select PKID from B2BRegistration where FKUserID=@AgentId and Status=1)

	select HC.Name as CompanyName
		   ,CC.CompanyName as ClientName
		   ,CC.CompanyUsername as ClientUsername
		   ,CC.CompanyPassword as ClientPassword
		   ,CC.ClientNumber as ClientId
		   ,CC.Status as ClientCompanyStatus

	from HotelApiClients HC
	join HotelApiClientsCompany CC on HC.Id=cc.ClientId
	where HC.AgentId=@Userid and HC.Status=1 and CC.Status=1


END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AgentCompanyMappingDetails] TO [rt_read]
    AS [dbo];

