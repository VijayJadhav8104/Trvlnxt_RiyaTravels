-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[Sp_GetIcustByName] --'IN','B2B'
	-- Add the parameters for the stored procedure here
	@Country varchar(50),
	@UserType varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @UserTypeID int

	select @UserTypeID = ID from mCommon where Category='UserType' and Value=@UserType

	SELECT PKID, Icast, AgencyName, al.UserID, Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
	inner join agentLogin al on al.UserID = b.FKUserID
	where al.BookingCountry = @Country AND AgentApproved=1 and UserTypeID=@UserTypeID
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetIcustByName] TO [rt_read]
    AS [dbo];

