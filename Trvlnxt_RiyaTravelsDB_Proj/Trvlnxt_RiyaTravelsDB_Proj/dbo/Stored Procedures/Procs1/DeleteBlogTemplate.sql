-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 14/06/2018>
-- Description:	< Delete BlogTemplate Items >
-- =============================================
CREATE PROCEDURE [dbo].[DeleteBlogTemplate] 
	-- Add the parameters for the stored procedure here
	@Id nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete  BlogTemplateMaster
	where Id=@Id
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteBlogTemplate] TO [rt_read]
    AS [dbo];

