CREATE PROC GetSupplierListForTF
AS
BEGIN
	SET NOCOUNT ON;

	Select * from TravelFusionSupplierList  WITH(NOLOCK)	
	Where Status=1 AND PkId NOT IN (Select top 1 SupplierId from TF_SupplierSectorMapping WITH(NOLOCK))
END
