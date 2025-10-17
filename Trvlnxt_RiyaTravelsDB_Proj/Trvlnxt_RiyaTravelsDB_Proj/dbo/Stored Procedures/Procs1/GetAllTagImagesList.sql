-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <11/06/2018>
-- Description:	< Get All Tag Images and Bind on TravelDiaries page ...>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllTagImagesList] --'','IN'
	-- Add the parameters for the stored procedure here
	
	@TagName nvarchar(max),
	@Country varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if @TagName=''
	begin
		select bm.Id,
				bm.Url,
				bm.BlogTDImage,
				bm.BlogOrder,
				bm.TagName,cast(bm.BlogOrder as int)
			--	tm.TagName
		from BlogMaster bm
		where bm.BlogTDImage is not null and bm.Preview_Flag='A' and Country in (select C_ID from CountryMaster WHERE CountryCode=@Country)
		      and bm.InsertDate <= GETDATE()
		Union
		
		select pm.PId,
				pm.BlogTDImageUrl,
				pm.BlogTDImage,
				pm.BlogOrder,
				pm.Tags,cast(pm.BlogOrder as int)
			--	tm.TagName
		from PublishBlogMaster pm  
		where BlogTDImage is not null and pm.ActiveFlag='A' and Country in (select C_ID from CountryMaster WHERE CountryCode=@Country)

		order by cast(bm.BlogOrder as int)
		select 2

	end

	--else if @TagName is not null
	--	begin
	--		select bm.Id,
	--				bm.Url,
	--				bm.BlogTDImage,
	--				bm.BlogOrder,
	--				tm.TagName
	--		from BlogMaster bm
	--		join TagsMaster tm on bm.TagName=tm.Id

	--		where BlogTDImage is not null  and tm.TagName=@TagName
	--		order by bm.Id desc

	--	select 1
	--end

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllTagImagesList] TO [rt_read]
    AS [dbo];

