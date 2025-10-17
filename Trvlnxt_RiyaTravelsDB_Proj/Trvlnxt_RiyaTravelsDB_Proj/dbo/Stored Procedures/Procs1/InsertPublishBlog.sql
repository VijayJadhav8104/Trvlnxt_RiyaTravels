-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertPublishBlog]
	-- Add the parameters for the stored procedure here
	
	@Country nvarchar(100),
	@BlogOrder nvarchar(max),
	@BlogTDImage nvarchar(max),
	@ImageUrl nvarchar(max),
	@Tags nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	insert into PublishBlogMaster (
									Country,
									BlogOrder,
									BlogTDImage,
									BlogTDImageUrl,
									Tags,
									CreateDate,
									ActiveFlag) 
	
	values(
			@Country,
			@BlogOrder,
			@BlogTDImage,
			@ImageUrl,
			@Tags,
			GETDATE(),
			'A')


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPublishBlog] TO [rt_read]
    AS [dbo];

