      
        
--EXEC Hotel.DestinationRPTMailer        
        
CREATE PROC [Hotel].[DestinationRPExcelExport]        
as        
Begin        
SELECT         
   ISNULL(Country,'NA') as Country,        
    City,        
    SupplierName,        
    [Booking_Count],        
    [Amount_in_INR],        
    [Total_Room_Nights],        
      
    -- New columns: totals per Country using window functions      
    SUM([Booking_Count]) OVER (PARTITION BY Country) AS Total_Booking_Count_By_Country,        
    SUM([Amount_in_INR]) OVER (PARTITION BY Country) AS Total_Amount_in_INR_By_Country,        
    SUM([Total_Room_Nights]) OVER (PARTITION BY Country) AS Total_Room_Nights_By_Country,        
  SortOrder    
FROM (        
    -- Main grouped data        
    SELECT         
        UPPER(ISNULL(HotelBookCountryName, CountryName)) AS Country,          
        UPPER(ISNULL(CityName, 'NA')) AS City,        
        UPPER(ISNULL(SupplierName, 'NA')) AS SupplierName,        
        COUNT(pkId) AS [Booking_Count],        
       -- SUM(TRY_CAST(DisplayDiscountRate AS DECIMAL(18, 2))) AS [Amount_in_INR],      
	   SUM(TRY_CAST((SupplierRate * SupplierINRROEValue) AS DECIMAL(18, 2))) AS [Amount_in_INR],
        SUM(TRY_CAST(SelectedNights AS INT)) AS [Total_Room_Nights],        
        0 AS SortOrder        
    FROM Hotel_BookMaster HB WITH (NOLOCK)
	Left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId
    WHERE FkStatusId IN (3,4)  and SH.Isactive=1      
      AND CAST(InsertedDate AS DATE) = CAST((GETDATE()-1) AS DATE)     
     
    GROUP BY HotelBookCountryName, CountryName, CityName, SupplierName        
        
    UNION ALL        
        
    -- Total row        
    SELECT         
        'Total' AS Country,        
        '' AS City,        
        '' AS SupplierName,        
        COUNT(pkId) AS [Booking_Count],        
       -- SUM(TRY_CAST(DisplayDiscountRate AS DECIMAL(18, 2))) AS [Amount_in_INR],
	   SUM(TRY_CAST((SupplierRate * SupplierINRROEValue) AS DECIMAL(18, 2))) AS [Amount_in_INR],
        SUM(TRY_CAST(SelectedNights AS INT)) AS [Total_Room_Nights],        
        1 AS SortOrder        
    FROM Hotel_BookMaster HB WITH (NOLOCK)
	Left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId
    WHERE FkStatusId IN (3,4)  and  SH.Isactive=1  
      AND CAST(InsertedDate AS DATE) = CAST((GETDATE()-1) AS DATE)    
       
) AS FinalResult        
      
ORDER BY SortOrder, Country, City, SupplierName;      
      
END 