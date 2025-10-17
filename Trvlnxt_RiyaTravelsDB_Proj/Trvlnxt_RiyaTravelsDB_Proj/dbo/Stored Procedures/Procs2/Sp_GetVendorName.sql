create PROCEDURE [dbo].[Sp_GetVendorName] --exec Sp_GetVendorName 'RT20250320085339485'
	@OrderID varchar(20)
AS            
BEGIN  

	SELECT VendorName FROM tblBookMaster WHERE  orderId =@OrderID

END 