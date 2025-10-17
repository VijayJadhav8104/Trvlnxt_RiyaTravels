
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <01/06/2018>
-- Description:	<Show All Blog ...,,>
-- =============================================
CREATE PROCEDURE [dbo].[DisplayAllBlog]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select  bm.Id,
			cm.CountryName,
			bm.Url,
			bm.MetaTitle,
			bm.Description,
			bm.Keywords,
			bm.BlogOrder,
			bm.BlogTDImage,
			bm.BlogThumbnail,
			bm.BlogOrder,
			bm.Author,
			bm.Headline,
			bm.SubHeadline,
			bm.CoverImage,
			bm.BlogInduction,
			bm.Country,
			bm.TagName as TagID,
------		tm.TagName,
			am.AdvertisementImage,
			CONVERT(nvarchar(max), bm.InsertDate, 106) as InsertDate,
			bm.Preview_Flag,
			am.AdvertisementURL
			
		
	 from BlogMaster bm
----- join TagsMaster tm on bm.TagName=tm.Id
      left join CountryMaster cm on bm.Country=cm.C_Id
	  left join AdvertisementMaster am on bm.Id=am.BlogId
	  where bm.Preview_Flag='A'
	  order by bm.BlogOrder asc
	 
	
	
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DisplayAllBlog] TO [rt_read]
    AS [dbo];

