Create PROCEDURE [dbo].[Sp_GetFlightTypeFilterByVendor]
	@VendorName varchar(20)
AS            
BEGIN  
  
	SELECT FlightType FROM tbl_FlightTypeFilter WHERE  VendorName =@VendorName

END 