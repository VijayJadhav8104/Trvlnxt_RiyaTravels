
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_DeleteSocial] 
	-- Add the parameters for the stored procedure here
	@pid bigint,
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@id=1)
	begin
	delete from CMS_SocialRelease where PKID_in=@pid
	end
	else
	begin
	delete from CMS_TestImonial where PKID=@pid
	end
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_DeleteSocial] TO [rt_read]
    AS [dbo];

