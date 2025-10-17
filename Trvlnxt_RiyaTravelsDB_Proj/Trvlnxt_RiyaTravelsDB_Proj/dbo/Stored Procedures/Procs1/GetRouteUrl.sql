-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRouteUrl]
	
@Action varchar(125)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select REPLACE(Url,'https://www.riya.travel/travel-diaries/','') AS Url, NEWID()  AS Name, '~/Blogs/BlogDetails.aspx' AS PhysicalPath from BlogMaster 
	where  Preview_Flag='A'
	--union
	--SELECT Url, NEWID()  AS Name, PhysicalPath
	--FROM tblFlightDealUrl
	--WHERE IsLive ='Compleated' AND IsActive = 'A'
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRouteUrl] TO [rt_read]
    AS [dbo];

