-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 21/06/2018 >
-- Description:	< Get All Latest Blog For Blog Template Page...,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetLatestBlogTemplate] --[GetLatestBlogTemplate] 'ten-beach-destinations-for-a-warm-winter-holiday-with-the-family'
@Id			VARCHAR(100)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN

declare @countryid as int
	
	select @countryid=country from BlogMaster  where Url = @Id


	select top 3
			Id,
			Url, 
		    MetaTitle,
			Headline,
		    convert( varchar, InsertDate, 106) as InsertDate,
		    BlogThumbnail 
	from BlogMaster
	where Url <> @Id and Preview_Flag='A' and country=@countryid
	order by Id desc

	
	
	--select top 3
	--		Id,
	--		Url, 
	--	    MetaTitle,
	--		Headline,
	--	    convert( varchar, InsertDate, 106) as InsertDate,
	--	    BlogThumbnail 
	--from BlogMaster
	--where Url <> @Id and Preview_Flag='A'
	--order by Id desc

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetLatestBlogTemplate] TO [rt_read]
    AS [dbo];

