-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 26/08/2018,,>
-- Description:	<Show Advertisement All Images.,,>
-- =============================================
CREATE PROCEDURE [dbo].[ShowAllAddImages] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from AdvertisementMaster order by Id desc

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ShowAllAddImages] TO [rt_read]
    AS [dbo];

