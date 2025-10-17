-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPublishBlogData] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select pm.PId,
			pm.BlogOrder,
			pm.BlogTDImage,
			pm.BlogTDImageUrl,
			CONVERT(nvarchar(max), pm.CreateDate, 106) as InsertDate,
			pm.ActiveFlag,
			cm.CountryName 

	From PublishBlogMaster pm
    join CountryMaster cm on pm.Country=cm.C_Id
	where ActiveFlag='A'

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllPublishBlogData] TO [rt_read]
    AS [dbo];

