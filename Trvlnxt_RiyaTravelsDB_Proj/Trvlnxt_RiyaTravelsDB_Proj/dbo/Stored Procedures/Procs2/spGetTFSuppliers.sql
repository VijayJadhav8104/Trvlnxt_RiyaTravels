-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetTFSuppliers] 
	-- Add the parameters for the stored procedure here
	@onwardsector varchar(100),
	@retsector varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT SupplierName  from TravelFusionSupplierList where status=1

	--select distinct SupplierName from TF_SupplierSectorMapping where Sector in(@onwardsector,@retsector)

	select distinct TF_SupplierSectorMapping.SupplierName,IsNDC from TF_SupplierSectorMapping 
	left join TravelFusionSupplierList  on TravelFusionSupplierList.PkId=TF_SupplierSectorMapping.SupplierId
	where Sector like '%'+@onwardsector+'%' and TravelFusionSupplierList.Status=1
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetTFSuppliers] TO [rt_read]
    AS [dbo];

