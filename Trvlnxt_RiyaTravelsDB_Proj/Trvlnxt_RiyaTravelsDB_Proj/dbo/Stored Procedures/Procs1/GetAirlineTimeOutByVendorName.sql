
--exec GetAirlineTimeOutByVendorName "QP"
CREATE PROCEDURE [dbo].[GetAirlineTimeOutByVendorName]
	@VendorName Varchar(100)
AS
BEGIN
	SELECT 
	
	VenderTime
	FROM Tbl_AirlineTimeOut 
	WHERE VendorName=@VendorName
END
