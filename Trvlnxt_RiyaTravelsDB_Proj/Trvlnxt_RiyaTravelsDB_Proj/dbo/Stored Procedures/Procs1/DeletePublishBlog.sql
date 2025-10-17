-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeletePublishBlog] 
	-- Add the parameters for the stored procedure here
	
	@Id nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	update PublishBlogMaster
		set ActiveFlag='D'

		where PId=@Id
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeletePublishBlog] TO [rt_read]
    AS [dbo];

