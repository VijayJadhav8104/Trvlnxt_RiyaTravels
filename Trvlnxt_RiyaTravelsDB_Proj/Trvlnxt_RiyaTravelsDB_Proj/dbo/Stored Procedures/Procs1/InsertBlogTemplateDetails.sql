-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 26/06/2018 >
-- Description:	< Insert More data For Blog Details like point Head, Point Sub Head etc...,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertBlogTemplateDetails] 
	-- Add the parameters for the stored procedure here
	
	@Head nvarchar(max),
	@SubHead nvarchar(max),
	@Description nvarchar(max),
--	@CoverImage nvarchar(max),
	@PointImage nvarchar(max),
	@id nvarchar(max)=isnull,
	@BlogId nvarchar(max),
	@PointimgLink nvarchar(max),
	@PointImgUrl nvarchar(max),
	@OrderNumber nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--	if not exists(select PointHead from BlogTemplateDetails where PointHead=@Head)
	
--	begin
		insert into BlogTemplateDetails(BlogId,
									PointHead,
									PointSubHead,
									PointDescription,
									Point_Images,
									Point_img_link,
									PointImgUrl,
									OrderNumber
									)

						values(		
									@BlogId,
									@Head,
									@SubHead,
									@Description,
									@PointImage,
									@PointimgLink,
									@PointImgUrl,
									@OrderNumber
									)

	--	select 1;
 -- end

  --else if exists (select PointHead from BlogTemplateDetails where PointHead=@Head)
		--	begin
		--		update BlogTemplateDetails set
		--									PointHead=@Head,
		--									PointSubHead=@SubHead,
		--									PointDescription=@Description,
		--									Point_Images=@PointImage,
		--									Point_img_link=@PointimgLink,
		--									PointImgUrl=@PointImgUrl

		--				where Id=@id
		--	select 0;
		--end
		
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertBlogTemplateDetails] TO [rt_read]
    AS [dbo];

