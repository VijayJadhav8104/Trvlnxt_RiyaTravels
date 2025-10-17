CREATE PROCEDURE [dbo].[Sp_GetFlightTypeFilter]
	@VendorName varchar(20)
	,@FlightType varchar(20)
AS            
BEGIN  
  
	SELECT VendorName
	, FlightType 
	FROM tbl_FlightTypeFilter 
	WHERE FlightType = @FlightType 
	--AND VendorName = @VendorName
	AND UPPER(REPLACE(RTRIM(LTRIM(VendorName)), ' ', '')) = UPPER(REPLACE(RTRIM(LTRIM(@VendorName)), ' ', ''))

END