
CREATE PROC GetAllProducts
AS
BEGIN
	SET NOCOUNT ON;
	Select pkid,ProductName from mProducts Where IsActive=1
END
