
--sp_helptext GetVendorFareType_ByAirline

CREATE PROCEDURE [dbo].[GetVendorFareType_ByAirline]  
	@VendorName varchar(20)  
	,@OfficeId varchar(100)  
	,@FromSector varchar(10) = NULL  
	,@ToSector varchar(10) = NULL  
	,@TravelDate DateTime = NULL  
	,@TripType varchar(10) = NULL  
AS              
BEGIN    
    
	DECLARE @faretypeid VARCHAR(MAX) = ''  
  
	SELECT TOP 1 @faretypeid = Value   
	FROM mVendorCredential   
	WHERE VendorId = (SELECT ID FROM mVendor WHERE REPLACE(UPPER(VendorName),' ','') = REPLACE(UPPER(@VendorName),' ','') and IsDeleted=0 and IsActive=1)   
	AND FieldName = 'Fare Type' AND OfficeId = @OfficeId        
  
	SELECT ID  
	, FareName  
	, FareType  
	, ProductClass  
	, International  
	, (CASE   

		WHEN @TravelDate >= CAST('2024-09-30' AS DATE) AND @TravelDate <= CAST('2024-10-31' AS DATE)
		AND @FromSector = 'DXB' AND @ToSector = 'CMB'
		AND ProductClass IN ('X', 'V', 'T', 'L', 'H', 'B', 'M','K', 'R', 'E', 'W', 'Y') THEN '50'

		WHEN @TravelDate >= CAST('2024-09-15' AS DATE) AND @TravelDate <= CAST('2024-10-26' AS DATE)
		AND @FromSector = 'DXB' AND (@ToSector = 'CMB' or @ToSector = 'MAA' or @ToSector = 'DAC')
		AND ProductClass IN ('X', 'V', 'T', 'L', 'H', 'B', 'M','K', 'R', 'E', 'W', 'Y') THEN '50'

		WHEN @TravelDate >= CAST('2024-07-16' AS DATE) AND @TravelDate <= CAST('2024-11-30' AS DATE)
		AND @FromSector = 'DXB' AND @ToSector = 'CMB' 
		AND ProductClass IN ('X', 'V', 'T', 'L', 'H', 'B', 'M','K', 'R', 'E', 'W', 'Y') THEN '40'  

		WHEN @TravelDate >= CAST('2024-08-12' AS DATE) AND @TravelDate <= CAST('2024-09-10' AS DATE) 
		AND ProductClass != 'O' 
		AND @FromSector = 'DXB' AND @ToSector = 'MAA' THEN '40'  
  
		WHEN @TravelDate >= CAST('2024-07-16' AS DATE) AND @TravelDate <= CAST('2024-11-30' AS DATE) 
		AND ProductClass IN ('X', 'V', 'T', 'L', 'H', 'B', 'M','K', 'R', 'E', 'W', 'Y') THEN '30'  
  
	   --WHEN @TravelDate >= CAST('2024-07-16' AS DATE) AND @TravelDate <= CAST('2024-11-30' AS DATE) AND ProductClass IN ('X', 'V', 'T', 'L', 'H', 'B', 'M') THEN '30'  
  
	   --WHEN @TravelDate >= CAST('2024-07-16' AS DATE) AND @TravelDate <= CAST('2024-11-30' AS DATE) AND ProductClass IN ('K', 'R', 'E', 'W', 'Y') THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-10-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'DXB' AND @ToSector = 'CMB' AND @TripType = 'OW' THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-10-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'DXB' AND @ToSector = 'CMB' AND @TripType = 'RTS' THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-10-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'CMB' AND @ToSector = 'DXB' AND @TripType = 'RTS' THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-10-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'DXB' AND @ToSector = 'MAA' AND @TripType = 'OW' THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-10-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'DXB' AND @ToSector = 'MLE' AND @TripType = 'OW' THEN '40'  
   
	   --WHEN @TravelDate <= CAST('2024-10-28' AS DATE) AND ProductClass != 'O' AND @FromSector = 'DXB' AND @ToSector = 'CMB' AND @TripType = 'OW' THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-12-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'DXB' AND @ToSector = 'CMB' AND @TripType = 'RTS' THEN '40'  
  
	   --WHEN @TravelDate <= CAST('2024-12-31' AS DATE) AND ProductClass != 'O' AND @FromSector = 'CMB' AND @ToSector = 'DXB' AND @TripType = 'RTS' THEN '40'  
  
	   --WHEN @TravelDate >= CAST('2024-05-01' AS DATE) AND @TravelDate <= CAST('2024-05-31' AS DATE) AND FareIndicator = 'CLASSIC FARE' AND @FromSector = 'MAA' AND @ToSector = 'CMB' THEN '35'  
  
		ELSE Domestics END) AS Domestics  
	, FareIndicator  
	, FareColor  
	, (CASE   
			WHEN @TravelDate >= CAST('2024-08-12' AS DATE) AND @TravelDate <= CAST('2024-09-10' AS DATE) 
			AND ProductClass != 'O'  
			AND @FromSector = 'DXB' AND @ToSector = 'MAA' 
			THEN 'Baggage allowance includes 2 checked-in pieces'  
  
		 -- WHEN @TravelDate <= CAST('2024-06-10' AS DATE) AND ProductClass != 'O'  
		 -- AND @FromSector = 'DXB' AND @ToSector = 'CMB' AND @TripType = 'OW' THEN 'Baggage allowance includes 2 checked-in pieces'  
  
		 -- WHEN @TravelDate <= CAST('2024-06-10' AS DATE) AND ProductClass != 'O'  
		 -- AND @FromSector = 'DXB' AND @ToSector = 'CMB' AND @TripType = 'RTS' THEN 'Baggage allowance includes 2 checked-in pieces'  
  
		 -- WHEN @TravelDate <= CAST('2024-06-10' AS DATE) AND ProductClass != 'O'  
		 -- AND @FromSector = 'DXB' AND @ToSector = 'MAA' AND @TripType = 'OW' THEN 'Baggage allowance includes 2 checked-in pieces'  
  
		 ELSE '' END) AS BaggageNote  
	, (CASE WHEN Refundable = 'Refundable' THEN 'REFUNDABLE' ELSE 'NON-REFUNDABLE' END) AS Refundable
	FROM mFareTypeByAirline   
	WHERE ID IN (SELECT Data FROM sample_split((@faretypeid), ','))  
  
END