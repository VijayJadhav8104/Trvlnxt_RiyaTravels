-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 14/06/2018 >
-- Description:	< Create New Blog Template for TravelDiaries ... >
-- =============================================
CREATE PROCEDURE [dbo].[CreateBlogTemplate] 
	-- Add the parameters for the stored procedure here
	
	@Author nvarchar(max),
	@Headline nvarchar(max),
	@SubHeadline nvarchar(max),
	@BlogInduction nvarchar(max),
	@Head nvarchar(max),
	@SubHead nvarchar(max),
	@Description nvarchar(max),
	@CoverImage nvarchar(max),
	@PointImage nvarchar(max),
	@id nvarchar(max),
	@BlogID nvarchar(max) OUTPUT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if exists ( select Id,Head,Headline from BlogTemplateMaster where Id=@id )
		begin
			
			update BlogTemplateMaster set Author=@Author,
											Headline=@Headline,
											SubHeadline=@SubHeadline,
											BlogInduction=@BlogInduction,
											Head=@Head,
											SubHead=@SubHead,
											Description=@Description

											where Id=@id;

									select 0;
		end

	else if not exists (select Id from BlogTemplateMaster where Id=@id)
		begin
				insert into BlogTemplateMaster (
											 Author,
											 Headline,
											 SubHeadline,
											 BlogInduction,
											 InsertDate,
											 CoverImage) 
							values(@Author,
								   @Headline,
								    @SubHeadline,
									@BlogInduction,
									getdate(),
									@CoverImage
									);
			select @BlogID = SCOPE_IDENTITY();
									
				--insert into BlogTemplateDetails(BlogId,PointHead,PointSubHead,PointDescription,Point_Images)
				--			values(scope_identity(),
				--						@Head,
				--						@SubHead,
				--						@Description,
				--						@PointImage)

				--			select SCOPE_IDENTITY();
		end

END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CreateBlogTemplate] TO [rt_read]
    AS [dbo];

