-- Create date: 31-05-2018
-- Description:this sp is used for the fecthing the data on the Gridview on PricingProfile page...
-- =============================================
CREATE PROCEDURE [dbo].[spFetchPricingProcess] 
	-- Add the parameters for the stored procedure here
	@venderName varchar(100)=''
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select a.Id,FromRange,ToRange,Amount,Percentage,ProfileId,[txtCurrency],b.VendorName from  HotelDiscountDetails a
	--join tblVendor b on a.VendorId=b.Id
	
	-- WHERE    IsActive != 1 or IsActive is Null 
	-- and (VendorName=@venderName or @venderName='')


  select distinct a.Id,a.FromRange,a.ToRange,a.Amount,a.Percentage,a.ProfileId,a.[txtCurrency],b.VendorName,c.Country from  HotelDiscountDetails a
	join tblVendor b on a.VendorId=b.Id
	left join HotelContryCurrency c on a.CountryId=c.CountryId
	 WHERE    a.IsActive != 1 or a.IsActive is Null
	 and (VendorName=@venderName or @venderName='')
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spFetchPricingProcess] TO [rt_read]
    AS [dbo];

