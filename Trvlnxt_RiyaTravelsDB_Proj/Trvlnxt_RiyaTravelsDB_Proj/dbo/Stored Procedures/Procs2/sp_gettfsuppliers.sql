create PROCEDURE [dbo].[sp_gettfsuppliers]
	-- Add the parameters for the stored procedure here
	--@code varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from TravelFusionSupplierList
	--where Code=@code
END
