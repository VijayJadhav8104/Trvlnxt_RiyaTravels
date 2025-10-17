CREATE PROC [Hotel].[DestinationRPTMailer]      
AS      
BEGIN      
    SET NOCOUNT ON;      
      
    -- Define list of countries to ensure inclusion      
    DECLARE @Countries TABLE (CountryName VARCHAR(100));      
    INSERT INTO @Countries (CountryName)      
  --  VALUES ('UNITED ARAB EMIRATES'), ('THAILAND'), ('SAUDI ARABIA'),('INDIA');      
   VALUES  ('CANADA'),('INDIA'),('MEXICO'),('THAILAND'),('SAUDI ARABIA'), ('UNITED ARAB EMIRATES'),    
   ('UNITED STATES'),('UNITED STATES OF AMERICA');     
    -- Get yesterday's date      
    DECLARE @ReportDate DATE = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);      
      
    -- Main report data      
    ;WITH RawData AS (      
        SELECT       
            UPPER(ISNULL(NULLIF(HotelBookCountryName, ''), NULLIF(CountryName, ''))) AS Country,      
            UPPER(ISNULL(NULLIF(CityName, ''), 'NA')) AS City,      
            UPPER(ISNULL(NULLIF(SupplierName, ''), 'NA')) AS SupplierName,      
            COUNT(pkId) AS Booking_Count,      
         --   SUM(TRY_CAST(DisplayDiscountRate AS DECIMAL(18, 2))) AS Amount_in_INR,      
   SUM(TRY_CAST((SupplierRate * SupplierINRROEValue) AS DECIMAL(18, 2))) AS Amount_in_INR,      
            SUM(TRY_CAST(SelectedNights AS INT)) AS Total_Room_Nights      
        FROM Hotel_BookMaster HB WITH (NOLOCK)      
 Left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId      
    WHERE FkStatusId IN (3,4)       
            AND CAST(InsertedDate AS DATE) = @ReportDate      
            AND (      
                UPPER(ISNULL(HotelBookCountryName, CountryName)) IN (SELECT CountryName FROM @Countries)      
             --   OR UPPER(ISNULL(CountryName, '')) IN (SELECT CountryName FROM @Countries)      
            )      
        GROUP BY       
            ISNULL(NULLIF(HotelBookCountryName, ''), NULLIF(CountryName, '')),      
            CityName,      
            SupplierName      
      
         
    ),      
          
    -- Fill in missing countries      
    AllCountries AS (      
        SELECT       
            UPPER(CountryName) AS Country       
        FROM @Countries      
    ),      
          
    Combined AS (      
        SELECT       
            C.Country,      
            ISNULL(R.City, 'NA') AS City,      
            ISNULL(R.SupplierName, 'NA') AS SupplierName,      
            ISNULL(R.Booking_Count, 0) AS Booking_Count,      
            ISNULL(R.Amount_in_INR, 0) AS Amount_in_INR,      
            ISNULL(R.Total_Room_Nights, 0) AS Total_Room_Nights,      
            0 AS SortOrder      
        FROM AllCountries C      
        LEFT JOIN RawData R ON R.Country = C.Country      
    )      
      
    -- Final Select including totals and window functions      
    SELECT       
        Country,      
        City,      
        SupplierName,      
        Booking_Count,      
        Amount_in_INR,      
        Total_Room_Nights,      
        SUM(Booking_Count) OVER (PARTITION BY Country) AS Total_Booking_Count_By_Country,      
        SUM(Amount_in_INR) OVER (PARTITION BY Country) AS Total_Amount_in_INR_By_Country,      
        SUM(Total_Room_Nights) OVER (PARTITION BY Country) AS Total_Room_Nights_By_Country,      
        SortOrder      
    FROM (      
        SELECT * FROM Combined      
        UNION ALL      
        SELECT       
            'Total', '', '',       
            COUNT(pkId),       
          --  SUM(TRY_CAST(DisplayDiscountRate AS DECIMAL(18,2))),      
    SUM(TRY_CAST((SupplierRate * SupplierINRROEValue) AS DECIMAL(18,2))),      
            SUM(TRY_CAST(SelectedNights AS INT)),      
            1 AS SortOrder      
        FROM Hotel_BookMaster HB WITH (NOLOCK)      
 Left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId      
    WHERE FkStatusId IN (3,4)       
            AND CAST(InsertedDate AS DATE) = @ReportDate      
            AND (      
                UPPER(ISNULL(HotelBookCountryName, CountryName)) IN (SELECT CountryName FROM @Countries)      
              --  OR UPPER(ISNULL(CountryName, '')) IN (SELECT CountryName FROM @Countries)      
      
          
            )      
         
    ) FinalResult      
    ORDER BY SortOrder, Country asc, City, SupplierName;      
END 