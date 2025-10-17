-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 16/07/2018 >
-- Description:	< Get Advertisement Image For Blog Page,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAdvertisementImage]
	-- Add the parameters for the stored procedure here
	
	@Id nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	select * from AdvertisementMaster 
	where BlogId=@Id 
	--order by InsertDate desc
	--where Active='1'

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAdvertisementImage] TO [rt_read]
    AS [dbo];

