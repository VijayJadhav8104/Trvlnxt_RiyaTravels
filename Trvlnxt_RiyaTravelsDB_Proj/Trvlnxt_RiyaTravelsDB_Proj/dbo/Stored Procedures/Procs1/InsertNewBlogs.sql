
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <01/06/2018,>
-- Description:	<Insert New Blog ...,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertNewBlogs]
	-- Add the parameters for the stored procedure here
--	@Blogid int,
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
	@Head nvarchar(max),
	@SubHead nvarchar(max),
	@PointDescription nvarchar(max),
	@CoverImage nvarchar(max),
	@PointImage nvarchar(max),
--	@id nvarchar(max),
	@BlogID nvarchar(max)=null,
	@InsertDate nvarchar(max),
	@AdvertisementURL nvarchar(max)=null
	


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if exists (select Id from BlogMaster where Id=@BlogID)
	begin
	
		update BlogMaster set  
								Country=@Country,
								Url=@Url,
								MetaTitle=@MetaTitle,
								[Description]=@Description,
								Keywords=@Keywords,
								BlogOrder=@BlogOrder,
								TagName=@TagName,
								InsertDate=@InsertDate,
						--		BlogTDImage=@Image,
								BlogTDImage=case when @Image ='' then BlogTDImage else @Image end,
						--		BlogThumbnail=@BlogThumbnail,
								BlogThumbnail=case when @BlogThumbnail ='' then BlogThumbnail else @BlogThumbnail end,
								Author=@Author,
								Headline=@Headline,
								SubHeadline=@SubHeadline,
								BlogInduction=@BlogInduction,
						--		CoverImage=@CoverImage
								CoverImage=case when @CoverImage ='' then CoverImage else @CoverImage end
						--		Head=@Head,
						--		SubHead=@SubHead,
						--		PointDescription=@PointDescription
								--Preview_Flag='1'

		where Id=@Blogid

		update AdvertisementMaster set AdvertisementURL=@AdvertisementURL where BlogId=@Blogid
		select SCOPE_IDENTITY();
	end


else if not exists(select Id from BlogMaster where Id=@BlogID)
	
		begin
			insert into BlogMaster(Country,
								Url,
								MetaTitle,
								[Description],
								Keywords,
								BlogOrder,
								TagName,
								BlogTDImage,
								BlogThumbnail,
								Author,
								Headline,
								SubHeadline,
								BlogInduction,
								InsertDate,
						--		Head,
						--		SubHead,
						--		PointDescription,
						--		PointImage,
								CoverImage,
								Preview_Flag
							)

					values(@Country,
								@Url,
								@MetaTitle,
								@Description,
								@Keywords,
								@BlogOrder,
								@TagName,
								@Image,
								@BlogThumbnail,
								@Author,
								@Headline,
								@SubHeadline,
								@BlogInduction,
								@InsertDate,
							--	@Head,
							--	@SubHead,
							--	@PointDescription,
							--	@PointImage,
								@CoverImage,
								'0'
								)
				
						select SCOPE_IDENTITY();
					end
		
		
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertNewBlogs] TO [rt_read]
    AS [dbo];

