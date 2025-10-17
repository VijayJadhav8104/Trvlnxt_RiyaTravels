-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE searchPriceProfile

	@profileName  nvarchar(500)=''
AS
BEGIN
	
	select * from PricingProfile where IsActive=1 and ProfileName like '%'+@profileName+'%'

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[searchPriceProfile] TO [rt_read]
    AS [dbo];

