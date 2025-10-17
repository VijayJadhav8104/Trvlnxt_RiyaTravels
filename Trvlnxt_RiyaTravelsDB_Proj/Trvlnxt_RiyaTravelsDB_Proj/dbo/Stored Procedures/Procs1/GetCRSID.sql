Create PROCEDURE [dbo].[GetCRSID]
@CategoryValue varchar(50)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  pkid,CategoryValue FROM tbl_commonmaster where CategoryValue = @CategoryValue and category='CRS'
END