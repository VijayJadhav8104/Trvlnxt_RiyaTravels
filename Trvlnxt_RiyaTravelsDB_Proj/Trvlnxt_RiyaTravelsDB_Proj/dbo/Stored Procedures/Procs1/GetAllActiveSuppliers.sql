CREATE PROC GetAllActiveSuppliers
AS
BEGIN
	SELECT * FROM B2BHotelSupplierMaster WHERE IsActive=1;
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllActiveSuppliers] TO [rt_read]
    AS [dbo];

