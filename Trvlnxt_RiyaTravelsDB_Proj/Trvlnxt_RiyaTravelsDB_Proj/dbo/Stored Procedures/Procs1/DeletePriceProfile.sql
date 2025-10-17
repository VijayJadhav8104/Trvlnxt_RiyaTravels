
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DeletePriceProfile
	-- Add the parameters for the stored procedure here
	@Id int=0

AS
BEGIN
	
	update PricingProfile set IsActive=0
	where Id=@Id

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeletePriceProfile] TO [rt_read]
    AS [dbo];

