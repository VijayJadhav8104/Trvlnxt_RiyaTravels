
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchBindData]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select * from IssuingOfficeId
    -- Insert statements for procedure here
	SELECT AirlineCode AS [_CODE], PKiD AS [_NAME] from dbo.AirlineCode_Console
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchBindData] TO [rt_read]
    AS [dbo];

