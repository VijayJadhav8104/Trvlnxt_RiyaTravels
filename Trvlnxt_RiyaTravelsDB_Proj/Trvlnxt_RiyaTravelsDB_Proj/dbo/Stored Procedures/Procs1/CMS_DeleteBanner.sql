
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_DeleteBanner]
	-- Add the parameters for the stored procedure here
	@PKID int

AS
BEGIN

	SET NOCOUNT ON;
   
	delete from  CMS_DealsBanner where PKID=@PKID
	
	
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_DeleteBanner] TO [rt_read]
    AS [dbo];

