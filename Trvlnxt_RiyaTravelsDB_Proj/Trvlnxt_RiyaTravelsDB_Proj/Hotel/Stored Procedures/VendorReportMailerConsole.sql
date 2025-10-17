CREATE PROC [Hotel].[VendorReportMailerConsole]                      
AS                      
BEGIN                      
  
    DROP TABLE IF EXISTS #temp, #temp1;          
  
    CREATE TABLE #temp          
    (          
        Vendor_Name varchar(400),          
        Vendor_Group varchar(400),          
        Vendor_Billing_Currency varchar(20),          
        Selling_Market varchar(20),                      
        Total_Booking_Foriegn_Currency int,          
        Total_Booking_Amount decimal(18,2),          
        Booking_Count int,          
        Percentage_Share decimal(18,2),          
        Vendor_Status varchar(20),          
        BookingPercentage DECIMAL(18,2),          
        orderby INT          
    );          
  
    CREATE TABLE #temp1          
    (          
        Vendor_Name varchar(400),          
        Vendor_Group varchar(400),          
        Vendor_Billing_Currency varchar(20),          
        Selling_Market varchar(20),                      
        Total_Booking_Foriegn_Currency int,          
        Total_Booking_Amount decimal(18,2),          
        Booking_Count int,          
        Percentage_Share decimal(18,2),          
        Vendor_Status varchar(20),          
        BookingPercentage DECIMAL(18,2),          
        orderby INT          
    );          
  
    -- HOTEL  
    INSERT INTO #temp1  
    SELECT                      
        SM.SupplierName AS Vendor_Name,                      
        ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                      
        COALESCE(HB.SupplierCurrencyCode, '-') AS Vendor_Billing_Currency,                      
        CASE COALESCE(HB.BookingCountry, '-')                      
            WHEN 'IN' THEN 'INDIA'                      
            WHEN 'AE' THEN 'UAE'                      
            WHEN 'CA' THEN 'CANADA'                      
            WHEN 'US' THEN 'USA'                      
            WHEN 'TH' THEN 'Thailand'                      
            ELSE COALESCE(HB.BookingCountry, '-')                      
        END AS Selling_Market,                      
        COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                      
        CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18, 2)) AS Total_Booking_Amount,                      
        COALESCE(COUNT(HB.pkId), 0) AS Booking_Count,                      
        CAST(COUNT(HB.pkId) * 100.0 / NULLIF(SUM(COUNT(HB.pkId)) OVER (), 0) AS DECIMAL(18, 2)) AS Percentage_Share,                      
        CASE SM.IsActive WHEN 1 THEN 'Active' ELSE 'Deactivate' END AS Vendor_Status,                      
        ISNULL(CAST(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)) * 100.0 /   
                NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate))) OVER (), 0)  
            AS DECIMAL(18, 2)), 0) AS BookingPercentage,            
        1 AS orderby             
    FROM B2BHotelSupplierMaster SM WITH (NOLOCK)                                      
    LEFT JOIN Hotel_BookMaster HB WITH (NOLOCK)                                       
        ON SM.Id = HB.SupplierPkId AND SM.SupplierType = 'Hotel'                          
        AND HB.CurrentStatus IN ('Vouchered','Confirmed')                                         
        AND CAST(HB.inserteddate AS DATE) = DATEADD(day, -1, CAST(GETDATE() AS DATE))          
    GROUP BY                      
        SM.SupplierName, SM.SupplierGroup, SM.IsActive, HB.BookingCountry, HB.SupplierCurrencyCode, SM.SupplierType, SM.IsDelete          
    HAVING SM.SupplierType = 'Hotel' AND SM.IsDelete = 0          
          
    UNION ALL          
  
    -- ACTIVITY  
    SELECT                      
        SM.SupplierName,                      
        ISNULL(SM.SupplierGroup, SM.SupplierName),                      
        COALESCE(HB.SupplierCurrency, '-'),                      
       CASE COALESCE(HB.BookingCurrency, '-')                      
            WHEN 'INR' THEN 'INDIA'                      
            WHEN 'AED' THEN 'UAE'                      
            WHEN 'CAD' THEN 'CANADA'                      
            WHEN 'USD' THEN 'USA'                     
            WHEN 'THB' THEN 'Thailand'                      
            ELSE COALESCE(HB.BookingCurrency, '-')                      
        END,                      
        COALESCE(SUM(HB.SupplierRate), 0),                      
        ISNULL(CAST(SUM(COALESCE(HB.BookingRate * HB.FinalRoe, HB.SupplierRate * HB.Roevalue)) AS DECIMAL(18, 2)), 0),       
        ISNULL(COUNT(HB.bookingid), 0),                      
        ISNULL(CAST(COUNT(HB.bookingid) * 100.0 / NULLIF(SUM(COUNT(HB.bookingid)) OVER (), 0) AS DECIMAL(18, 2)), 0),                      
        CASE SM.IsActive WHEN 1 THEN 'Active' ELSE 'Deactivate' END,                      
        ISNULL(CAST(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)) * 100.0 /  
            NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate))) OVER (), 0) AS DECIMAL(18, 2)), 0),            
        2          
    FROM B2BHotelSupplierMaster SM WITH (NOLOCK)                                      
    LEFT JOIN SS.SS_BookingMaster HB WITH (NOLOCK)                                       
        ON SM.RhSupplierId = HB.providerId AND SM.SupplierType = 'Activity'                         
        AND HB.BookingStatus IN ('Vouchered','Confirmed')                                         
        AND CAST(HB.creationDate AS DATE) = DATEADD(day, -1, CAST(GETDATE() AS DATE))          
    GROUP BY SM.SupplierName, SM.SupplierGroup, SM.IsActive, HB.BookingCurrency, HB.SupplierCurrency, SM.SupplierType, SM.IsDelete          
    HAVING SM.SupplierType = 'Activity' AND SM.IsDelete = 0          
  
    UNION ALL          
  
    -- TRANSFER  
    SELECT                      
        SM.SupplierName,                      
        ISNULL(SM.SupplierGroup, SM.SupplierName),                      
        COALESCE(HB.SupplierCurrency, '-'),                      
        CASE COALESCE(HB.BookingCurrency, '-')                      
            WHEN 'INR' THEN 'INDIA'                      
            WHEN 'AED' THEN 'UAE'                      
            WHEN 'CAD' THEN 'CANADA'                      
            WHEN 'USD' THEN 'USA'                     
            WHEN 'THB' THEN 'Thailand'                      
            ELSE COALESCE(HB.BookingCurrency, '-')                      
        END,                      
        COALESCE(SUM(HB.SupplierRate), 0),                      
        ISNULL(CAST(SUM(COALESCE(HB.AmountBeforePgCommission, HB.SupplierRate * HB.SupplierToFinalRoe)) AS DECIMAL(18, 2)), 0),       
        ISNULL(COUNT(HB.BookingId), 0),                      
        ISNULL(CAST(COUNT(HB.BookingId) * 100.0 / NULLIF(SUM(COUNT(HB.BookingId)) OVER (), 0) AS DECIMAL(18, 2)), 0),                      
        CASE SM.IsActive WHEN 1 THEN 'Active' ELSE 'Deactivate' END,                      
        ISNULL(CAST(SUM(COALESCE(HB.SupplierRate * HB.FinalRoe, HB.AmountBeforePgCommission)) * 100.0 /  
            NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.FinalRoe, HB.AmountBeforePgCommission))) OVER (), 0) AS DECIMAL(18, 2)), 0),            
        3          
    FROM B2BHotelSupplierMaster SM WITH (NOLOCK)                                      
    LEFT JOIN TR.TR_BookingMaster HB WITH (NOLOCK)                                       
        ON SM.SupplierName = HB.providerName AND SM.SupplierType = 'Transfer'                        
        AND HB.BookingStatus IN ('Vouchered','Confirmed')                                         
        AND CAST(HB.creationDate AS DATE) = DATEADD(day, -1, CAST(GETDATE() AS DATE))          
    GROUP BY SM.SupplierName, SM.SupplierGroup, SM.IsActive, HB.BookingCurrency, HB.SupplierCurrency, SM.SupplierType, SM.IsDelete          
    HAVING SM.SupplierType = 'Transfer' AND SM.IsDelete = 0    
  
    -- TOTAL Rows for Hotel, Activity, Transfer  
    INSERT INTO #temp  
    SELECT 'Total', 'Total', 'NA', 'NA', 0,  
           SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)),  
           COUNT(HB.pkId), 100, '-', 100, 1000  
    FROM Hotel_BookMaster HB WITH (NOLOCK)  
    LEFT JOIN B2BHotelSupplierMaster SM WITH (NOLOCK)  
        ON SM.Id = HB.SupplierPkId AND SM.SupplierType = 'Hotel' AND SM.IsDelete = 0 
    WHERE HB.CurrentStatus IN ('Vouchered', 'Confirmed')  
        AND CAST(HB.inserteddate AS DATE) = DATEADD(day, -1, CAST(GETDATE() AS DATE));  
  
    INSERT INTO #temp  
    SELECT 'Total', 'Total', 'NA', 'NA', 0,  
           SUM(COALESCE(HB.BookingRate * HB.FinalRoe, HB.SupplierRate * HB.Roevalue)),  
           COUNT(HB.BookingId), 100, '-', 100, 1001  
    FROM SS.SS_BookingMaster HB WITH (NOLOCK)  
    LEFT JOIN B2BHotelSupplierMaster SM WITH (NOLOCK)  
        ON SM.RhSupplierId = HB.providerId AND SM.SupplierType = 'Activity'   AND SM.IsDelete = 0  
    WHERE HB.BookingStatus IN ('Vouchered', 'Confirmed')  
        AND CAST(HB.creationDate AS DATE) = DATEADD(day, -1, CAST(GETDATE() AS DATE));  
  
    INSERT INTO #temp  
    SELECT 'Total', 'Total', 'NA', 'NA', 0,  
           SUM(ISNULL(COALESCE(HB.SupplierRate * HB.SupplierToFinalRoe, HB.AmountBeforePgCommission), 0)),  
           COUNT(HB.BookingId), 100, '-', 100, 1002  
    FROM TR.TR_BookingMaster HB WITH (NOLOCK)  
    LEFT JOIN B2BHotelSupplierMaster SM WITH (NOLOCK)  
        ON SM.SupplierName = HB.providerName AND SM.SupplierType = 'Transfer'  AND SM.IsDelete = 0  
    WHERE HB.BookingStatus IN ('Vouchered', 'Confirmed')  
        AND CAST(HB.creationDate AS DATE) = DATEADD(day, -1, CAST(GETDATE() AS DATE));  
  
    -- FINAL OUTPUT  
    SELECT        
        Vendor_Name, Vendor_Group, Vendor_Billing_Currency, Selling_Market,  
        Total_Booking_Foriegn_Currency, Total_Booking_Amount, Booking_Count,  
        Percentage_Share, Vendor_Status, BookingPercentage, orderby  
    FROM #temp1  where Vendor_Name not like '%TEST%'
  
    UNION ALL  
  
    SELECT  
        'Total', 'Total', 'NA', 'NA', 0,  
        SUM(Total_Booking_Amount), SUM(Booking_Count), 100, '-', 100, 20001  
    FROM #temp  where  Vendor_Name not like '%TEST%'
  
    ORDER BY   
        orderby, Vendor_Name, Vendor_Group;  
  
END;  