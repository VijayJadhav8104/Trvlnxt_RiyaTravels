
CREATE PROCEDURE [dbo].[CMS_DeleteBackgroundBanner]
	-- Add the parameters for the stored procedure here
	@PKID int

AS
BEGIN
   
	delete from  CMS_BackgroundBanner where PKID=@PKID
	
	
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_DeleteBackgroundBanner] TO [rt_read]
    AS [dbo];

