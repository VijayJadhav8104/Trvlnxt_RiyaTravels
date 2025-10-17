-- =============================================
-- Author:		<Pranav>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FilterPricingData]
	-- Add the parameters for the stored procedure here
	@venderName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select a.Id,FromRange,ToRange,Amount,Percentage,ProfileId,[txtCurrency],b.VendorName from  HotelDiscountDetails a
	join tblVendor b on a.VendorId=b.Id
	
	 WHERE  IsActive!= 1 or IsActive is Null and VendorName=@venderName 
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FilterPricingData] TO [rt_read]
    AS [dbo];

