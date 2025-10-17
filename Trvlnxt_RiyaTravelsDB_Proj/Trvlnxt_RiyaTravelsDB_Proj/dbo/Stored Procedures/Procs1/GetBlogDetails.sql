-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 02/07/2018 >
-- Description:	< Get All Details For Blog Page And Bind Data...,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBlogDetails]
	-- Add the parameters for the stored procedure here
	
	@Id nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @blogid int
	select @blogid=Id from BlogMaster  where Url= @Id;
	select bm.Id, 
			bm.Country,
			bm.Url,
			bm.MetaTitle,
			bm.Description,
			bm.Keywords,
			bm.BlogOrder,
			--bm.InsertDate,
			CONVERT(nvarchar(max), bm.InsertDate, 106) as InsertDate,
			bm.TagName,
			bm.Author,
			bm.CoverImage,
			bm.Headline,
			bm.SubHeadline,
			bm.Head,
			bm.SubHead,
			bm.PointDescription,
			bm.PointImage,
			bm.BlogInduction,
			bm.BlogTDImage
		from BlogMaster bm 
		where bm.Url= @Id

	select bt.BlogId,
			bt.PointHead,
			bt.PointSubHead,
			bt.Point_Images,
			bt.PointDescription,
			bt.OrderNumber,
			--bt.Point_img_link as ImageLink
			case when bt.Point_img_link IS NULL THEN ''
			else bt.Point_img_link end as ImageLink,

			case when bt.PointImgUrl IS NULL THEN ''
			else bt.PointImgUrl end as ImageContentUrl

		from BlogTemplateDetails bt
		where bt.BlogId=@blogid
		order by cast (bt.OrderNumber as int) asc

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBlogDetails] TO [rt_read]
    AS [dbo];

