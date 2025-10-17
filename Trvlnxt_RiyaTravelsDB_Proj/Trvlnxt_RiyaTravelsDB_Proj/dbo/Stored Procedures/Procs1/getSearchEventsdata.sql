-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getSearchEventsdata]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Hotel_CountryMaster --where Code='138'


END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getSearchEventsdata] TO [rt_read]
    AS [dbo];

