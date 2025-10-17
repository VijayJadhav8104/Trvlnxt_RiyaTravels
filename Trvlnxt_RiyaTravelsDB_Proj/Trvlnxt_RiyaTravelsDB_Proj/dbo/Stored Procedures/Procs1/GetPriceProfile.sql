-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetPriceProfile
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
	select * From PricingProfile where IsActive=1
	order by CreateDate desc

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPriceProfile] TO [rt_read]
    AS [dbo];

