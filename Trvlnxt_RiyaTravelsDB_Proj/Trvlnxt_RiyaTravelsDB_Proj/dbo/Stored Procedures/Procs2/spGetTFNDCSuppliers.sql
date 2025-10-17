-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spGetTFNDCSuppliers 
	-- Add the parameters for the stored procedure here


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT SupplierName  from TravelFusionSupplierList where status=1

	--select distinct SupplierName from TF_SupplierSectorMapping where Sector like '%'+@onwardsector+@retsector+'%'

	select distinct SupplierName from TravelFusionSupplierList where IsNDC=1 and Status=1
END
