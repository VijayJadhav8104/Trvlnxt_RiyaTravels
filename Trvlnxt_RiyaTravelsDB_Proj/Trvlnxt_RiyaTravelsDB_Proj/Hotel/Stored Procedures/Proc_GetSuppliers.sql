CREATE PROCEDURE [Hotel].[Proc_GetSuppliers]
AS
BEGIN
----- -
	SELECT 
		ID, 
		SupplierName
	FROM
		B2BHotelSupplierMaster
	ORDER BY
		SupplierName ASC
END