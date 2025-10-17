
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getglobalsimcountryID]
	-- Add the parameters for the stored procedure here
	@countryname varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select PKID_int from Globalsimcountrymaster where countryname_vc=@countryname
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getglobalsimcountryID] TO [rt_read]
    AS [dbo];

