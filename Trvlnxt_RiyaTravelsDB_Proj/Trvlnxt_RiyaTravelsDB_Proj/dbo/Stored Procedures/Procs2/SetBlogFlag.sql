-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <Create Date,,>
-- Description:	<Final Blog Set Flag ,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetBlogFlag]
	-- Add the parameters for the stored procedure here
	@Bid nvarchar(max),
	@Country varchar(max),
	@Url varchar(max),
	@MetaTitle varchar(max),
	@Description varchar(max),
	@Keywords varchar(max),
	@BlogOrder varchar(max),
	@TagName varchar(max),
	@Image Varchar(max), 
	@BlogThumbnail varchar(max),
	@Author nvarchar(max),
	@Headline nvarchar(max),
	@SubHeadline nvarchar(max),
	@BlogInduction nvarchar(max),
	@CoverImage nvarchar(max),
	@InsertDate nvarchar(max),
	@AdvertisementURL nvarchar(max)=null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	 update BlogMaster set  
								Country=@Country,
								Url=@Url,
								MetaTitle=@MetaTitle,
								[Description]=@Description,
								Keywords=@Keywords,
								BlogOrder=@BlogOrder,
								TagName=@TagName,
								InsertDate=@InsertDate,
								BlogTDImage=case when @Image ='' then BlogTDImage else @Image end,
								BlogThumbnail=case when @BlogThumbnail ='' then BlogThumbnail else @BlogThumbnail end,
								Author=@Author,
								Headline=@Headline,
								SubHeadline=@SubHeadline,
								BlogInduction=@BlogInduction,
								 Preview_Flag='A' ,
								CoverImage=case when @CoverImage ='' then CoverImage else @CoverImage end
						

		where Id=@Bid


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SetBlogFlag] TO [rt_read]
    AS [dbo];

