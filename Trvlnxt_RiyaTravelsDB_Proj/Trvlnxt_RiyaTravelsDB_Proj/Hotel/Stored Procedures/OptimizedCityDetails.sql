
-- =============================================
-- Author:		Akash
-- Create date: 22 Aug 2025
-- Description:	Get Optimized City Hotels and  Suppliers Info
-- =============================================
CREATE PROCEDURE Hotel.OptimizedCityDetails

	@LocationId Varchar(200) =null 
AS
BEGIN
	
	Select distinct HotelID from [AllAppLogs].Hotel.OptimizedCity where CityID=@LocationId 
	
	--Select distinct SM.RhSupplierId from [AllAppLogs].Hotel.OptimizedCity OC
	--left join B2BHotelSupplierMaster SM on OC.SupplierName=SM.SupplierName
	--where CityID=@LocationId and  SM.RhSupplierId is not null

	SELECT DISTINCT SM.RhSupplierId 
    FROM [AllAppLogs].Hotel.OptimizedCity OC
    LEFT JOIN B2BHotelSupplierMaster SM 
    ON OC.SupplierName COLLATE Latin1_General_CI_AI = SM.SupplierName COLLATE Latin1_General_CI_AI
    WHERE CityID = 221688 
    AND SM.RhSupplierId IS NOT NULL

END
