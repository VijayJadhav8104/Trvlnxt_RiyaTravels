-- =============================================
-- Author:		<Altamash Khan>
-- Create date: < 08/06/2018 >
-- Description:	< Delete Advertisement ...>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAdvertisementImage]
	-- Add the parameters for the stored procedure here
	@Id nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	delete from AdvertisementMaster where Id=@Id

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteAdvertisementImage] TO [rt_read]
    AS [dbo];

