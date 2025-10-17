-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <06/06/2018>
-- Description:	<Delete For New Blogs,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteBlogs]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete BlogMaster 
	where Id=@id

	delete BlogTemplateDetails
	where BlogId=@id

	delete AdvertisementMaster
	where BlogId=@id

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteBlogs] TO [rt_read]
    AS [dbo];

